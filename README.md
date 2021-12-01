# invoice-generator

A little Bash tool that generates invoices.

## Requirements
 - bc
 - jq
 - pdflatex

## Usage
To generate an invoice run `./gen_invoice.sh HOURS RATE [DATE]` where HOURS and RATE are decimal numbers. DATE is optional and allows you to specify an issue date. DATE must be in a YYYY/mm/dd format (1976/07/04). If DATE is not specified, current date is used. Invoice number is generated as `YYYYmm01`, where `YYYY` is the year and `mm` is the month of a month, previous to the issue date.

## Configuration
Configuration is done through `config.json` file.

> **_NOTE:_** If there are slashes in configuration values, they should be escaped by double backslash (`Main Str, 1/2` &#8594; `Main Str, 1\\/2`)

### Configuration options
#### Display values
Values of this configuration options are rendered directly on the resulting invoice. If you don't need some of them, set them to an empty string.

|Option|Description|
|:----|:----------|
|contractor\_name| Contractor name, displayed under the line under "Contractor" label in large bold text |
| contractor\_address1 | First line of contractor's address, displayed under contractor's name |
| contractor\_address2 | Second line of contractor's address, displayed under the first one |
| contractor\_address3 | Third line of contractor's address, displayed under the second one |
| client\_name | Client name, displayed under the line under "Client" label in large bold text |
| client\_address1 | First line of client's address, displayed under client's name |
| client\_address2 | Second line of client's address, displayed under the first one |
| client\_address3 | Third line of client's address, displayed under the second one |
| id | Contractor's identifier, shown in bold slightly to the right  and below "Client" and "Contractor" blocks |
| tax\_id | Contractor's tax identifier, shown in bold slightly to the right, under the ID |
| bank\_name | Bank name, displayed under tax ID |
| iban | International bank account number, shown under bank name |
| bic | BIC/SWIFT code of the bank, displeyed under the IBAN |
| bank\_address1 | First line of bank address, displayed under BIC/SWIFT |
| bank\_address2 | Second line of bank address, displayed under the first one |
| service | Description of service provided, shown in the leftmost column of the table below |

#### Other options
| Option | Description |
|:-------|:------------|
| due\_days | How many days is the invoice due, from this the due date is calculated |
| output\_dir | Path to the directory the invoice should be generated into |
