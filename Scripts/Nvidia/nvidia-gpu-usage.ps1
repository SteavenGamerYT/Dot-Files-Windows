$nvidiaSmi = "C:\Windows\System32\nvidia-smi.exe"
$usage = & $nvidiaSmi --query-gpu=utilization.gpu --format=csv,noheader,nounits
Write-Output "$usage%"
