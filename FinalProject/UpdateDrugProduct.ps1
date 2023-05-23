param ([string]$DT)

#DRUG_PRODUCT
$inputPath_DP = Invoke-RestMethod -uri 'https://health-products.canada.ca/api/drug/drugproduct/?lang=en&type=json'
$outputPath_DP = "C:\Users\Student\Desktop\Final Project\CSV\DRUG_PRODUCT.csv"

$inputPath_DP | Select-Object drug_code, class_name, drug_identification_number, brand_name, descriptor, number_of_ais, ai_group_no, company_name, last_update_date  |
where {$_.last_update_date -ge $DT} | ConvertTo-Csv -NoTypeInformation | Set-Content $outputPath_DP