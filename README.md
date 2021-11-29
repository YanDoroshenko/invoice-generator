# invoice-generator

A little Bash tool that generates invoices.

## Requirements
 - bc
 - jq
 - pdflatex

## Configuration
Configuration is done through `config.json` file.

## Running
To generate an invoice run `./gen_invoice.sh HOURS RATE` where HOURS and RATE are decimal numbers.
