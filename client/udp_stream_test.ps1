Write-Host "Starting UDP stream test"

$bitrate = Read-Host "Please enter the bitrate in bps (ex 25000000 for 25Mbps)"
$server_ip = Read-Host "Please enter the server IP address"

$a = Get-Date

$start = Read-Host "Please start cstTraffic with correct bitrate and smart-meter API on the server. Then press enter"
Write-Host "Starting UDP stream test"
Write-Host "Idle for 60 seconds"
$date = $a.ToString('dd_MM_yy_hh_mm')
$postParams = @{file="network-wifi-udp-$bitrate-$date.csv"; status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/startRecording" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Start-Sleep -Seconds 60

$postParams = @{status='download'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
.\ctsTraffic.exe -target:$server_ip -protocol:udp -bitspersecond:$bitrate -framerate:60 -bufferdepth:1 -streamLength:60 -consoleverbosity:1 -connections:1 -iterations:1

$postParams = @{status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Write-Host "Idle for 60 seconds"
Start-Sleep -Seconds 60

$postParams = @{status='download'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
.\ctsTraffic.exe -target:$server_ip -protocol:udp -bitspersecond:$bitrate -framerate:60 -bufferdepth:1 -streamLength:60 -consoleverbosity:1 -connections:1 -iterations:1

$postParams = @{status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Write-Host "Idle for 60 seconds"
Start-Sleep -Seconds 60

$postParams = @{status='download'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
.\ctsTraffic.exe -target:$server_ip -protocol:udp -bitspersecond:$bitrate -framerate:60 -bufferdepth:1 -streamLength:60 -consoleverbosity:1 -connections:1 -iterations:1

$postParams = @{status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Write-Host "Idle for 60 seconds"
Start-Sleep -Seconds 60

$postParams = @{status='download'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
.\ctsTraffic.exe -target:$server_ip -protocol:udp -bitspersecond:$bitrate -framerate:60 -bufferdepth:1 -streamLength:60 -consoleverbosity:1 -connections:1 -iterations:1

$postParams = @{status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Write-Host "Idle for 60 seconds"
Start-Sleep -Seconds 60

$postParams = @{status='download'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
.\ctsTraffic.exe -target:$server_ip -protocol:udp -bitspersecond:$bitrate -framerate:60 -bufferdepth:1 -streamLength:60 -consoleverbosity:1 -connections:1 -iterations:1

$postParams = @{status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Write-Host "Idle for 60 seconds"
Start-Sleep -Seconds 60

Invoke-WebRequest -Uri "http://$server_ip/stopRecording" -Method POST -Body ''
Write-Host "Test done - please stop smart-meter API on the server"
