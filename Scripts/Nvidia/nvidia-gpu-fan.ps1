$nvidiaSmi = "C:\Windows\System32\nvidia-smi.exe"
$fanSpeed = & $nvidiaSmi --query-gpu=fan.speed --format=csv,noheader,nounits
Write-Output "$fanSpeed%"

