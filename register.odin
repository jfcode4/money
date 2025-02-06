package main

import "core:fmt"

register_command :: proc(l: Ledger, account: string) {
	sum: i64
	for entry in l {
		if entry.from == account || account == "" {
			sum -= i64(entry.amount)
			fmt.printfln("%4d-%2d-%2d % 7d.%2d   = % 7d.%2d  %s",
				entry.date.year, entry.date.month, entry.date.day,
				-i64(entry.amount)/1000, entry.amount%1000/10,
				sum/1000, abs(sum)%1000/10,
				entry.description)
		}
		if entry.to == account || account == "" {
			sum += i64(entry.amount)
			fmt.printfln("%4d-%2d-%2d % 7d.%2d   = % 7d.%2d  %s",
				entry.date.year, entry.date.month, entry.date.day,
				entry.amount/1000, entry.amount%1000/10,
				sum/1000, abs(sum)%1000/10,
				entry.description)
		}
	}
}
