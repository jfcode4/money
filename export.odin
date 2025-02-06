package main

import "core:fmt"

export_ledger :: proc(l: Ledger) {
	for entry in l {
		fmt.printfln("%4d-%2d-%2d %s\n\t%-20s  % 7d.%2d\n\t%s",
			entry.date.year, entry.date.month, entry.date.day, entry.description,
			entry.to, entry.amount/1000, entry.amount%1000/10,
			entry.from)
	}
}
