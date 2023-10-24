# NIFC API endpoint for active wildfires
$apiUrl = 'https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Incident_Locations_YearToDate/FeatureServer/0/query'

# Define query parameters as a hashtable
$queryParams = @{
    'where' = '1=1'                  # Example: Retrieve all records (active wildfires)
    'outFields' = "*"  # Example: Specify fields you want
    'outSR' = '4326'                 # Example: Specify the spatial reference (WGS 1984)
    'f' = 'json'                     # Example: Specify JSON format for the response
}

# Construct the query string
$queryString = $queryParams.GetEnumerator() | ForEach-Object {
    "$($_.Key)=$($_.Value)"
}
$queryString = [string]::Join("&", $queryString)

# Combine the URL and query string correctly
$fullUrl = "$apiUrl" + "?" + "$queryString"

try {
    # Send the GET request to the API using Invoke-RestMethod
    $response = Invoke-RestMethod -Uri $fullUrl -Method Get

    # Access the data
    $data = $response.features

    # Now you can work with the data, for example, display the data
    $data | ForEach-Object {
        Write-Host "Incident Name: $($_.IncidentName)"
        Write-Host "County: $($_.attributes.POOCounty)"
        Write-Host "Catgeory: $($_.attributes.IncidentTypeCategory)"
        Write-Host "Size (acres): $($_.attributes.FinalAcres)"
        Write-Host "Cause: $($_.attributes.FireCause)"
        Write-Host "------------------------"
    }
    $data | Export-Csv -Path C:\Temp\FireData.csv
} catch {
    Write-Host "Error: $_"
}
