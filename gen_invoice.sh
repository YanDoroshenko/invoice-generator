#!/bin/bash

config_file="config.json"
number_regex='^[0-9]+(\.[0-9]+)?$'
date_format="+%d.%m.%Y"

output_dir_str=$(jq -r '.output_dir' $config_file | grep -v "null")
if [ -z $output_dir_str ]; then
    output_dir="."
elif [ -d $output_dir_str ]; then
    output_dir=$output_dir_str
else
    echo "$output_dir_str, specified as output directory is not a directory"
    exit 1
fi

hours=$1
rate=$2

if [[ ! $hours =~ $number_regex ]] || [[ ! $rate =~ $number_regex ]]; then
    echo "Usage: gen_invoice.sh HOURS RATE [DATE]"
    echo "DATE must be in YYYY/mm/dd format (1776/07/04)"
    exit 1
fi

if [ -z $3 ]; then
    date=$(date "+%Y-%m-%d")
else
    date=$(date -d "$3" "+%Y-%m-%d")
fi

if [ -z $date ]; then
    echo "Usage: gen_invoice.sh HOURS RATE [DATE]"
    echo "DATE must be in YYYY/mm/dd format (1776/07/04)"
    exit 1
fi


amount=$(bc <<< "scale=2;$hours * $rate")

issue_date=$(date -d "$date" $date_format)
due_days=$(jq -r '.due_days' $config_file)
due_date=$(date -d "$date +$due_days days" $date_format)

contractor_name=$(jq -r '.contractor_name' $config_file)
contractor_address1=$(jq -r '.contractor_address1' $config_file)
contractor_address2=$(jq -r '.contractor_address2' $config_file)
contractor_address3=$(jq -r '.contractor_address3' $config_file)

client_name=$(jq -r '.client_name' $config_file)
client_address1=$(jq -r '.client_address1' $config_file)
client_address2=$(jq -r '.client_address2' $config_file)
client_address3=$(jq -r '.client_address3' $config_file)


id=$(jq -r '.id' $config_file)
tax_id=$(jq -r '.tax_id' $config_file)
bank_name=$(jq -r '.bank_name' $config_file)
iban=$(jq -r '.iban' $config_file)
bic=$(jq -r '.bic' $config_file)
bank_address1=$(jq -r '.bank_address1' $config_file)
bank_address2=$(jq -r '.bank_address2' $config_file)
service=$(jq -r '.service' $config_file)


invoice_number=$(date -d "$date -1 month" '+%Y%m01')

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
    sed "s/{{issue_date}}/$issue_date/" |
    sed "s/{{due_date}}/$due_date/" > "$invoice_number.tex"

echo "Generating invoice to $output_dir"
pdflatex "$invoice_number.tex" 1>/dev/null
mv "$invoice_number.pdf" "$output_dir"

rm "$invoice_number.aux"
rm "$invoice_number.tex"
rm "$invoice_number.log"

