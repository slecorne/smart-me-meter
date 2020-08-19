Write-Host "Starting Video Playback test"

#WPF Library for Playing Movie and some components
Add-Type -AssemblyName PresentationFramework
$VideoPlayer = New-Object System.Windows.Media.MediaPlayer

# Test sequence: 1. Play video 2. sleep for similar amount of time
function Start-Test {
  param ( $bitrate )

  #Movie Path
  $dir = Get-Location
  [uri]$VideoSource = "$dir\videos\jellyfish-$bitrate-h264.mkv"

  #Video Default Setting
  $VideoPlayer.Volume = 0;
  $VideoPlayer.Open($VideoSource)
  do {
    Write-Host "Get video duration $VideoSource"
    Start-Sleep -Milliseconds 100
    $duration = $VideoPlayer.NaturalDuration.TimeSpan.Seconds
  }
  until ($duration)
  Write-Host "Video duration: $duration"
  $VideoPlayer.Close()

  $postParams = @{status=$bitrate}
  Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"

  # Play video
  Start-process $VideoSource
  Start-Sleep -Seconds ($duration +1)

  $postParams = @{status="idle"}
  Invoke-WebRequest -Uri "http://$server_ip/status" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
  Start-Sleep -Seconds ($duration +1)
}

$server_ip = Read-Host "Please enter the server IP address"

$a = Get-Date

$start = Read-Host "Please ensure jellyfish smaple videos [http://www.jell.yfish.us/] are in /videos subdirectory. Then press enter"

Write-Host "Idle for 30 seconds"
$date = $a.ToString('dd_MM_yy_hh_mm')
$postParams = @{file="video-playback-test-$date.csv"; status='idle'}
Invoke-WebRequest -Uri "http://$server_ip/startRecording" -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
Start-Sleep -Seconds 30

$bitrate = "3-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "5-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "10-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "15-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "20-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "25-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "50-mbps-hd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate

$bitrate = "120-mbps-4k-uhd"
Write-Host "Starting Video playback test $bitrate Mbps"
Start-Test $bitrate
