package main

import "core:fmt"
import "core:slice"
import "core:strings"

parent_accounts :: proc(account: string, buf: ^[10]string) -> []string {
	buf[0] = account
	len := 1
	for len < 10 {
		i := strings.last_index(buf[len-1], ":")
		if i != -1 {
			buf[len] = buf[len-1][:i]
			len += 1
		} else {
			break
		}
	}
	return buf[:len]
}

indent_account :: proc(account: string) {
	count := strings.count(account, ":")
	i := strings.last_index(account, ":")
	for _ in 0..<count {
		fmt.print("  ")
	}
	fmt.print(account[i+1:])
}

balance_command :: proc(l: Ledger, account_filter: string) {
	accounts: map[string]i64
	defer delete(accounts)
	for entry in l {
		buf: [10]string
		for account in parent_accounts(entry.from, &buf) {
			accounts[account] -= entry.amount
		}
		for account in parent_accounts(entry.to, &buf) {
			accounts[account] += entry.amount
		}
	}
	keys := slice.map_keys(accounts) or_else []string{}
	defer delete(keys)
	slice.sort(keys)
	for key in keys {
		if accounts[key] == 0 {
			continue
		}
		fmt.printf("%14s  ", format_amount(accounts[key]))
		indent_account(key)
		fmt.println("")
	}
}
