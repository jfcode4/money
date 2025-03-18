package main

import "core:fmt"

register_command :: proc(l: Ledger, account: string) {
	sum: i64
	for entry in l {
		if entry.from == account || account == "" {
			sum -= i64(entry.amount)
			fmt.printfln("%4d-%2d-%2d %10s   = %10s  %s",
				entry.date.year, entry.date.month, entry.date.day,
				format_amount(-entry.amount), format_amount(sum),
				entry.description)
		}
		if entry.to == account || account == "" {
			sum += i64(entry.amount)
			fmt.printfln("%4d-%2d-%2d %10s   = %10s  %s",
				entry.date.year, entry.date.month, entry.date.day,
				format_amount(entry.amount), format_amount(sum),
				entry.description)
		}
	}
}
