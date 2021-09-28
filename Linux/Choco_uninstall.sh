$csv = Import-Csv -Path .\apps.csv
foreach ($package in $csv) {
    Choco uninstall -y $package.name
} 
echo $package removed!