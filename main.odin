package main

import "core:fmt"
import "core:os"

Config :: struct {
	filename: string,
	command: enum {
		Balance, Register, Export, Print
	},
	account: string
}

ConfigError :: string


main :: proc() {
	config, config_err := parse_args()
	if config_err != "" {
		fmt.eprintln(config_err)
		os.exit(1)
	}
	ledger, err := ledger_parse(config.filename)
	if err.code != .None {
		fmt.eprintfln("Error reading file %s: line %d: %s", config.filename, err.line_number, err.code)
		os.exit(1)
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
	free_all(context.temp_allocator)
}

parse_args :: proc() -> (config: Config, err: ConfigError) {
	config.filename = "ledger.tsv"
	for i := 1; i < len(os.args); i+=1 {
		arg := os.args[i]
		if arg == "-f" {
			if i+1 < len(os.args) {
				config.filename = os.args[i+1]
				i+=1
				continue
			} else {
				err = "-f: no file given"
				return
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
			err = fmt.aprintf("Unknown command: %s", arg)
			return
		}
	}
	return
}
