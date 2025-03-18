# money

A double-entry accounting program similar to ledger but uses a simpler data format.

## Build instructions
First, you need to have the Odin compiler installed, then run:
```bash
odin build .
```
Then install the executable somewhere on your PATH:
```bash
cp money ~/.local/bin/
```

## Data format
The accounting data is simply stored as a list of transactions in a TSV file.
```tsv
# Date      From       To                 Amount  Description
2020-01-05  in:salary  as:cash            100     First salary
2020-01-05  as:cash    ex:food            12.04   Meal
2020-01-08  as:cash    ex:transportation  42.50   Train
2020-02-14  as:cash    as:bank:kbc        20      Deposit
```
The program reads the data from `ledger.tsv` by default. You can change it with the `-f` flag.

## Commands
`money balance` gives you a balance sheet for all accounts.

```
$ money balance
         45.46  as
         20.00    bank
         20.00      kbc
         25.46    cash
         54.54  ex
         12.04    food
         42.50    transportation
       -100.00  in
       -100.00    salary
```

`money register <account>` gives you the transactions of a specific account including a running total.

```
$ money register as:cash
2020-01-05     100.00   =     100.00  First salary
2020-01-05     -12.04   =      87.96  Meal
2020-01-08     -42.50   =      45.46  Train
2020-02-14     -20.00   =      25.46  Deposit
```
