package main

import "core:encoding/csv"
import "core:strconv"
import "core:strings"
import "core:time/datetime"
import "core:os"

Ledger :: []Entry
Entry :: struct {
	date: datetime.Date,
	from: string, // debit account
	to:   string, // credit account
	amount:  i64, // in fractions of 1000
	description: string
}
ParseError :: struct {
	code: enum {
		None,
		CannotReadFile,
		InvalidDate,
		InvalidAmount,
		MissingField
	},
	line_number: int
}

parse_date :: proc(s: string) -> (date: datetime.Date, ok: bool) {
	iter := s
	year_str := strings.split_iterator(&iter, "-") or_return
	year := strconv.parse_u64(year_str, 10) or_return
	month_str := strings.split_iterator(&iter, "-") or_return
	month := strconv.parse_u64(month_str, 10) or_return
	day_str := strings.split_iterator(&iter, "-") or_return
	day := strconv.parse_u64(day_str, 10) or_return
	_date, err := datetime.components_to_date(year, month, day)
	if err != nil {
		ok = false
		return
	}
	date = _date
	ok = true
	return
}

parse_amount :: proc(s: string) -> (amount: i64, ok: bool) {
	head, _, tail := strings.partition(s, ".")
	units := strconv.parse_u64(head) or_return
	frac1, frac2, frac3: u64
	if len(tail) > 0 {
		frac1 = strconv.parse_u64(tail[0:1]) or_return
	}
	if len(tail) > 1 {
		frac2 = strconv.parse_u64(tail[1:2]) or_return
	}
	if len(tail) > 2 {
		frac3 = strconv.parse_u64(tail[2:3]) or_return
	}
	amount = i64(units*1000 + frac1 * 100 + frac2 * 10 + frac3)
	ok = true
	return
}

// tsv format
// 0     1     2   3       4
// date  from  to  amount  description
ledger_parse :: proc(filename: string) -> (Ledger, ParseError) {
	file, ok := os.read_entire_file(filename)
	if !ok {
		return nil, {.CannotReadFile, 0}
	}
	total_lines := strings.count(string(file), "\n")
	res := make([dynamic]Entry, 0, total_lines)
	line_number: int
	file_iter := string(file)
	for line in strings.split_lines_iterator(&file_iter) {
		line_number += 1
		if line == "" || strings.starts_with(line, "#") do continue
		line_iter := line
		date_str, ok := strings.split_iterator(&line_iter, "\t")
		if !ok {
			return nil, {.MissingField, line_number}
		}
		date, ok2 := parse_date(date_str)
		if !ok2 {
			return nil, {.InvalidDate, line_number}
		}
		from, ok3 := strings.split_iterator(&line_iter, "\t")
		if !ok3 {
			return nil, {.MissingField, line_number}
		}
		to, ok4 := strings.split_iterator(&line_iter, "\t")
		if !ok4 {
			return nil, {.MissingField, line_number}
		}
		amount_str, ok5 := strings.split_iterator(&line_iter, "\t")
		if !ok5 {
			return nil, {.MissingField, line_number}
		}
		amount, ok6 := parse_amount(amount_str)
		if !ok6 {
			return nil, {.InvalidAmount, line_number}
		}
		description, ok7 := strings.split_iterator(&line_iter, "\t")
		if !ok7 {
			return nil, {.MissingField, line_number}
		}
		append(&res, Entry{date, from, to, amount, description})
	}
	return res[:], {}
}
