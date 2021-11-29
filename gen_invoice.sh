#!/bin/bash

invoice_number=$(date '+%Y%m01')

contractor_name=$(jq -r '.contractor_name' config.json)
contractor_address1=$(jq -r '.contractor_address1' config.json)
contractor_address2=$(jq -r '.contractor_address2' config.json)
contractor_address3=$(jq -r '.contractor_address3' config.json)

client_name=$(jq -r '.client_name' config.json)
client_address1=$(jq -r '.client_address1' config.json)
client_address2=$(jq -r '.client_address2' config.json)
client_address3=$(jq -r '.client_address3' config.json)


id=$(jq -r '.id' config.json)
tax_id=$(jq -r '.tax_id' config.json)
bank_name=$(jq -r '.bank_name' config.json)
iban=$(jq -r '.iban' config.json)
bic=$(jq -r '.bic' config.json)
bank_address_line1=$(jq -r '.bank_address_line1' config.json)
bank_address_line2=$(jq -r '.bank_address_line2' config.json)
service=$(jq -r '.service' config.json)

date_format="+%d.%m.%Y"
today=$(date $date_format)
due=$(date -d "+30 days" $date_format)

number_regex='^[0-9]+(\.[0-9]+)?$'

hours=$1
rate=$2

if [[ ! $hours =~ $number_regex ]] || [[ ! $rate =~ $number_regex ]]; then
    echo "Usage: gen_invoice.sh HOURS RATE"
    exit 1
fi

amount=$(bc <<< "scale=2;$hours * $rate")

sed "s/{{invoice_number}}/$invoice_number/" invoice.tex.template |
    sed "s/{{contractor_name}}/$contractor_name/" |
    sed "s/{{contractor_address1}}/$contractor_address1/" |
    sed "s/{{contractor_address2}}/$contractor_address2/" |
    sed "s/{{contractor_address3}}/$contractor_address3/" |
    sed "s/{{client_name}}/$client_name/" |
    sed "s/{{client_address1}}/$client_address1/" |
    sed "s/{{client_address2}}/$client_address2/" |
    sed "s/{{client_address3}}/$client_address3/" |
    sed "s/{{id}}/$id/" |
    sed "s/{{tax_id}}/$tax_id/" |
    sed "s/{{bank_name}}/$bank_name/" |
    sed "s/{{iban}}/$iban/" |
    sed "s/{{bic}}/$bic/" |
    sed "s/{{bank_address_line1}}/$bank_address_line1/" |
    sed "s/{{bank_address_line2}}/$bank_address_line2/" |
    sed "s/{{service}}/$service/" |
    sed "s/{{hours}}/$hours/" |
    sed "s/{{rate}}/$rate/" |
    sed "s/{{amount}}/$amount/" |
    sed "s/{{today}}/$today/" |
    sed "s/{{due}}/$due/" > "$invoice_number.tex"
pdflatex "$invoice_number.tex"
rm "$invoice_number.aux"
rm "$invoice_number.tex"
rm "$invoice_number.log"
