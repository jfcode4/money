package main

import "core:fmt"

print_ledger :: proc(l: Ledger) {
	for entry in l {
		fmt.printfln("%4d-%2d-%2d  %20s -> %-20s  % 7d.%2d  %s",
			entry.date.year, entry.date.month, entry.date.day,
			entry.from, entry.to,
			entry.amount/1000, entry.amount%1000/10,
			entry.description)
	}
}
