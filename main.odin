package main

import "core:fmt"
import "core:os"

config : struct {
	filename: string,
	command: enum {
		Balance, Register, Export, Print
	},
	account: string
}


main :: proc() {
	parse_args()
	ledger, err := ledger_parse(config.filename)
	if err.code != nil {
		fmt.eprintfln("Error reading file %s: line %d: %s", config.filename, err.line_number, err.code)
	}
	switch config.command {
	case .Balance:
		balance_command(ledger, config.account)
	case .Register:
		register_command(ledger, config.account)
	case .Export:
		export_ledger(ledger)
	case .Print:
		print_ledger(ledger)
	}
}

parse_args :: proc() {
	config.filename = "ledger.tsv"
	for i := 1; i < len(os.args); i+=1 {
		arg := os.args[i]
		if arg == "-f" {
			if i+1 < len(os.args) {
				config.filename = os.args[i+1]
				i+=1
				continue
			} else {
				fmt.eprintln("-f: no file given")
				os.exit(1)
			}
		} else if arg == "balance" || arg == "bal" {
			config.command = .Balance
			if i+1 < len(os.args) {
				config.account = os.args[i+1]
				i+=1
				continue
			}
		} else if arg == "register" || arg == "reg" {
			config.command = .Register
			if i+1 < len(os.args) {
				config.account = os.args[i+1]
				i+=1
				continue
			}
		} else if arg == "export" {
			config.command = .Export
		} else if arg == "print" {
			config.command = .Print
		} else {
			fmt.eprintfln("Unknown command: %s", arg)
			os.exit(1)
		}
	}
}
