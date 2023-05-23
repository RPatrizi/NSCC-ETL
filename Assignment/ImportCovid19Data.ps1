param([string]$LastImportDate )

$SSISDate = $LastImportDate

$pathToJsonFile = Invoke-RestMethod -uri 'https://api.opencovid.ca/timeseries?stat=cases&stat=deaths&stat=hospitalizations&stat=icu&stat=tests_completed&stat=vaccine_administration_dose_3&geo=pt&fill=false&version=true&pt_names=short&hr_names=hruid&legacy=false&fmt=json'
$pathToOutputFile = "C:\Users\Student\Desktop\Assignment2\alldata.csv"

$pathToJsonFile.data.hospitalizations | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\Recovered.csv -NoTypeInformation

$pathToJsonFile.data.icu | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\ActiveCases.csv –NoTypeInformation

$pathToJsonFile.data.cases | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\Cases.csv –NoTypeInformation

$pathToJsonFile.data.deaths | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\Mortality.csv –NoTypeInformation

$pathToJsonFile.data.tests_completed | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\Testing.csv –NoTypeInformation

$pathToJsonFile.data.vaccine_administration_dose_3 | Select-Object name, region, date, value, value_daily | 
where {$_.date -ge $SSISDate} | export-csv -path C:\Users\Student\Desktop\Assignment2\CSV\FullyVaccinated.csv –NoTypeInformation