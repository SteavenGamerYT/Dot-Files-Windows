$nvidiaSmi = "C:\Windows\System32\nvidia-smi.exe"
$temp = & $nvidiaSmi --query-gpu=temperature.gpu --format=csv,noheader,nounits
Write-Output "$temp°C"

