$nvidiaSmi = "C:\Windows\System32\nvidia-smi.exe"
$vramUsed = & $nvidiaSmi --query-gpu=memory.used --format=csv,noheader,nounits
Write-Output "$vramUsed MiB"

