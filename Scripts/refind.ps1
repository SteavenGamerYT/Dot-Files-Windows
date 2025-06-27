# ⚙️ CONFIGURATION
$refindDisk = 0
$refindPart = 1
$windowsDisk = 4
$windowsPart = 1
$refindLetter = "A:"
$windowsLetter = "B:"
$refindName = "rEFInd Boot Manager"
$easyuefi = "C:\Program Files\Hasleo\EasyUEFI\bin\EasyUEFIC.exe"

function Mount-Partition($disk, $part, $letter) {
    Write-Host "`n📦 Mounting Disk $disk Partition $part as $letter..."
    $script = @"
select disk $disk
select partition $part
assign letter=$($letter.TrimEnd(":"))
exit
"@
    $script | diskpart | Out-Null
    Start-Sleep -Milliseconds 500
}

function Unmount-Partition($letter) {
    Write-Host "🧹 Unmounting $letter..."
    mountvol $letter /d
}

# =============================
Write-Host "`n==============================="
Write-Host "  [1] Mounting rEFInd EFI as $refindLetter"
Write-Host "==============================="
Mount-Partition $refindDisk $refindPart $refindLetter

Write-Host "`n==============================="
Write-Host "  [2] Locating rEFInd Bootloader"
Write-Host "==============================="
$efiFile = Get-ChildItem -Path "$refindLetter\EFI" -Recurse -Filter "*refind*.efi" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match "refind_x64\.efi|bootx64\.efi" } |
    Select-Object -First 1

if (-not $efiFile) {
    Write-Error "❌ rEFInd bootloader not found in $refindLetter\EFI"
    Unmount-Partition $refindLetter
    exit 1
}

$relativePath = $efiFile.FullName.Replace("$refindLetter", "").Replace("/", "\")
Write-Host "✅ Found: $relativePath"

Write-Host "`n==============================="
Write-Host "  [3] Deleting All Existing EFI Boot Entries"
Write-Host "==============================="
$entries = & "$easyuefi" --list-efi
$indices = ($entries | Select-String '^\s*\d+\s' | ForEach-Object { ($_ -split '\s+')[0] })

foreach ($i in $indices) {
    Write-Host "  → Deleting entry index $i..."
    & "$easyuefi" --delete-efi --index $i
}

Write-Host "`n==============================="
Write-Host "  [4] Adding rEFInd Boot Entry"
Write-Host "==============================="
& "$easyuefi" --add-efi --type 2 `
    --name "$refindName" `
    --disk $refindDisk `
    --part $refindPart `
    --file "$relativePath"

Write-Host "`n==============================="
Write-Host "  [5] Setting rEFInd as Top Boot Entry"
Write-Host "==============================="
& "$easyuefi" --top-efi-by-name --name "$refindName"

Write-Host "`n==============================="
Write-Host "  [6] Unmounting rEFInd Partition"
Write-Host "==============================="
Unmount-Partition $refindLetter

# =============================
Write-Host "`n==============================="
Write-Host "  [7] Mounting Windows EFI Partition as $windowsLetter"
Write-Host "==============================="
Mount-Partition $windowsDisk $windowsPart $windowsLetter

Write-Host "`n==============================="
Write-Host "  [8] Copying Windows Bootloader (no firmware sync)"
Write-Host "==============================="
$bcdCommand = "bcdboot C:\Windows /s $windowsLetter /f UEFI /nofirmwaresync"
Invoke-Expression $bcdCommand

Write-Host "`n==============================="
Write-Host "  [9] Unmounting Windows EFI Partition"
Write-Host "==============================="
Unmount-Partition $windowsLetter

# ✅ Done
Write-Host "`n==============================="
Write-Host "  ✅ Done. rEFInd is now the default bootloader, Windows was added without touching boot order."
Write-Host "==============================="
