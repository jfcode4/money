package main

import "core:fmt"

help :: proc() {
	fmt.println(
`money: A double-entry accounting program

FLAGS:
	-f <filename>            Use a different data file. Default is 'ledger.tsv'.

COMMANDS:
	balance|bal              Show account balances
	register|reg <account>   Show transaction history of an account
	print                    Print all transactions in a user-readable format
	export                   Export the data into the ledger format
	help:                    Show this help info`)
}
