package main

import "core:fmt"

print_ledger :: proc(l: Ledger) {
	for entry in l {
		fmt.printfln("%4d-%2d-%2d  %20s -> %-20s  %10s  %s",
			entry.date.year, entry.date.month, entry.date.day,
			entry.from, entry.to,
			format_amount(entry.amount),
			entry.description)
	}
}
