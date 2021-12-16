$key = "YOUR_KEY_SERVICE"
$endpoint = "YOUR_ENDPOINT_SERVICE"


# Code to call Computer Vision service for image analysis
$img_file = "woodlog-lake.jpg"
if ($args.count -gt 0 -And $args[0] -in ("woodlog-lake.jpg", "sunset-traffic.jpg", "cute-baby-traditional.jpg"))
{
    $img_file = $args[0]
}

$img = "https://raw.githubusercontent.com/zeenfts/azure-ai-workshop/main/img/$img_file"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","application/json" )

$body = "{'url' : '$img'}"

write-host "Analyzing image..."
$result = Invoke-RestMethod -Method Post `
          -Uri "$endpoint/vision/v3.2/analyze?visualFeatures=Categories,Description,Objects" `
          -Headers $headers `
          -Body $body | ConvertTo-Json -Depth 5

$analysis = $result | ConvertFrom-Json
Write-Host("`nDescription:")
foreach ($caption in $analysis.description.captions)
{
    Write-Host ($caption.text)
}

Write-Host("`nObjects in this image:")
foreach ($object in $analysis.objects)
{
    Write-Host (" -", $object.object)
}

Write-Host("`nTags relevant to this image:")
foreach ($tag in $analysis.description.tags)
{
    Write-Host (" -", $tag)
}

Write-Host("`n")
