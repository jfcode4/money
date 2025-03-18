package main

import "core:fmt"

format_amount :: proc(amount: i64) -> string {
	buf := make([]u8, 25, context.temp_allocator)
	return fmt.bprintf(buf, "%s%d.%2d",
		amount < 0 ? "-" : "",
		abs(amount) / 1000,
		abs(amount) % 1000 / 10)
}
