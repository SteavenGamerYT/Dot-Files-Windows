$nvidiaSmi = "C:\Windows\System32\nvidia-smi.exe"
$watts = & $nvidiaSmi --query-gpu=power.draw --format=csv,noheader,nounits
Write-Output "$watts W"

