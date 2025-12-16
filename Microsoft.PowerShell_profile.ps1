# ==========================================
# 💀 PowerShell Hacker Edition (By Biso)
# Merged with your settings + ASCII logo
# ==========================================
# 🧩 Enable Terminal Icons
# Import-Module Terminal-Icons

# 🧠 PSReadline Settings
Set-PSReadlineOption -EditMode Windows
Set-PSReadlineOption -PredictionSource History
Set-PSReadlineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineOption -BellStyle None

# 🎨 Oh My Posh Local Theme (only if installed & theme file exists)
$localTheme = "$HOME\Documents\PowerShell\cobalt2.omp.json"
if (Test-Path $localTheme -PathType Leaf) {
    if (Get-Command 'oh-my-posh' -ErrorAction SilentlyContinue) {
        oh-my-posh init pwsh --config $localTheme | Invoke-Expression
    } else {
        Write-Host "⚠️  Theme file found but 'oh-my-posh' not installed." -ForegroundColor Yellow
        Write-Host "➡️  Install oh-my-posh or remove the theme file to silence this message." -ForegroundColor DarkGray
    }
}

# 🚀 Useful Aliases
# Set-Alias ll Get-ChildItem
# Set-Alias la Get-ChildItem
# Set-Alias cls Clear-Host
# Set-Alias reload '. $PROFILE'
# function up { Set-Location .. }

#-----------------------
# =========================
# Biso's Ra2e Aliases & Helpers
# =========================

# ---- Quick navigation ----
Set-Alias .. Up-Dir         # '..' already handled by function up if present, Up-Dir as backup
function Up-Dir { Set-Location .. }
Set-Alias ~ Set-Location
function c { Set-Location }             # c <path>  -> cd shortcut
function h { Set-Location $HOME }       # go home fast
Set-Alias desk desk                     # desk() function exists in profile; alias for consistency
Set-Alias docs docs

# ---- Pretty listing ----
# use Terminal-Icons if available, otherwise fallback to Get-ChildItem
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    function ls { param($p='.') Get-ChildItem -LiteralPath $p -Force | Sort-Object @{Expression={$_.PSIsContainer};Descending=$true},LastWriteTime }
    function ll { param($p='.') Get-ChildItem -LiteralPath $p -Force | Sort-Object @{Expression={$_.PSIsContainer};Descending=$true},LastWriteTime | Format-Table Mode, @{N='Size';E={if ($_.PSIsContainer){''}else{[math]::Round($_.Length/1KB,2).ToString() + ' KB'}}},LastWriteTime,Name -AutoSize }
    Set-Alias la ls
    Set-Alias lsl ll
} else {
    Set-Alias ls Get-ChildItem
    function ll { param($p='.') Get-ChildItem -Force -LiteralPath $p | Sort-Object @{Expression={$_.PSIsContainer};Descending=$true},LastWriteTime }
    Set-Alias la ls
    Set-Alias lsl ll
}

# ---- Git shortcuts (ra2e) ----
Set-Alias gst 'git status'
Set-Alias ga  'git add'
function gc { param($m) if ($m) { git commit -m $m } else { git commit } }   # gc "msg"
Set-Alias gp  'git push'
Set-Alias gpl 'git pull'
function gco { param($branch) if ($branch) { git checkout $branch } else { git checkout } }  # gco branch
function gcl { param($repo) if ($repo) { git clone $repo } else { Write-Host "Usage: gcl <repo-url>" -ForegroundColor Yellow } }

# ---- Edit / Profile ----
Set-Alias e Edit-Profile    # opens your configured editor (if Edit-Profile exists)
Set-Alias ep Edit-Profile
function edit { param($f) if ($f) { notepad $f } else { notepad $PROFILE } }  # edit file or profile

# ---- Admin / Elevated ----
function sudo {
    param($args)
    if ($args) { Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -Command $args" } else { Start-Process powershell -Verb runAs }
}
Set-Alias su sudo
Set-Alias admin sudo

# ---- System quickies ----
Set-Alias cls Clear-Host
Set-Alias reboot 'Restart-Computer'
Set-Alias shutdown 'Stop-Computer'
function mem { Get-CimInstance Win32_OperatingSystem | Select-Object @{N='FreeMB';E={[math]::Round($_.FreePhysicalMemory/1024,2)}}, @{N='TotalMB';E={[math]::Round($_.TotalVisibleMemorySize/1024,2)}} }

# ---- Network ----

function ips {
    Write-Host "🌐 IPv4 Addresses:" -ForegroundColor Cyan
    Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' } |
        Select-Object InterfaceAlias, IPAddress |
        Format-Table -AutoSize
}

# ---- Files helpers ----
function mk { param($name) New-Item -ItemType Directory -Path $name -Force; Set-Location $name }  # mk myfolder
function nf { param($name) New-Item -ItemType File -Path $name -Force }                         # nf file.txt
function rmf { param($p) Remove-Item $p -Recurse -Force }                                        # safe rm

# ---- Clipboard / Quick copy ----
function cpy { param($text) Set-Clipboard $text; Write-Host "Copied to clipboard" -ForegroundColor Green }

# ---- Fancy hacker alias ----
function hacker {
    Clear-Host
    Write-Host "╔══════════ Biso Hacker Mode ══════════╗" -ForegroundColor DarkGreen
    Write-Host "║  Quick cheats: gst | gco <b> | ll | mk  ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor DarkGreen
}

# ---- Small safeguards: avoid clashing with native commands ----
# If you already have a function/alias with same name, do not overwrite; prefer existing
# (this is a soft check — it won't revert overwritten ones, but it's safe to paste)
foreach ($a in 'ls','ll','ga','gp','gc','gst') {
    if (Get-Command $a -ErrorAction SilentlyContinue) { } else { }
}

# =========================
# End of Biso aliases
# =========================



#-----------------------

# 🧭 Quick Navigation
function desk { Set-Location "$HOME\Desktop" }
function docs { Set-Location "$HOME\Documents" }
function down { Set-Location "$HOME\Downloads" }

# 🧰 Utilities
function Edit-Profile { notepad $PROFILE }
function sysinfo { Get-ComputerInfo | Select-Object CsName, OsName, OsArchitecture, OsVersion }
function whereami { Get-Location }

# 💀 Hacker Banner (No loading text by default, small animated lead-in)
Clear-Host

# tiny "boot" animation (quick, non-blocking-feel)
# adjusts to be very short so startup stays snappy
for ($i = 0; $i -lt 3; $i++) {
    Write-Host -NoNewline "Initializing"
    for ($j = 0; $j -lt ($i+1); $j++) { Write-Host -NoNewline "." }
    Start-Sleep -Milliseconds 140
    Write-Host ""
}
Start-Sleep -Milliseconds 80
Clear-Host

# ASCII Logo + Hacker Message (green logo + red subtitle)
Write-Host @"
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⣠⣤⣤⣤⣤⣤⡙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠟⢁⣴⣿⣿⣿⣿⣿⣿⣿⣿⣦⣈⠻⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡿⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢹⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠈⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⢀⣿⣿⡿⠿⠛⢋⣉⣉⡙⠛⠿⢿⣿⣿⡄⢹⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣧⠘⢿⣤⡄⢰⣿⣿⣿⣿⣿⣿⣶⠀⣤⣽⠃⣸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⡿⠛⢋⣁⡈⢻⡇⢸⣿⣿⣿⣿⣿⣿⡿⢠⡿⢁⣈⡙⠛⢿⣿⣿⣿⣿
⣿⣿⣿⡿⢁⡾⠿⠿⠿⠄⠹⠄⠙⠛⠿⠿⠟⠋⠠⠞⠠⠾⠿⠿⠿⡄⢻⣿⣿⣿
⣿⣿⡿⢁⣾⠀⣶⣶⣿⣿⣶⣾⣶⣶⣶⣶⣶⣿⣿⣷⣾⣷⣶⣶⠀⣷⡀⢻⣿⣿
⣿⣿⠁⣼⣿⠀⣿⣿⣿⣿⣿⣿⠟⣉⣤⣤⣈⠛⣿⣿⣿⣿⣿⣿⠀⣿⣷⡈⢿⣿
⣿⠃⣼⣿⣿⠀⣿⣿⣿⣿⣿⡇⣰⡛⢿⡿⠛⣧⠘⣿⣿⣿⣿⣿⠀⣿⣿⣷⠈⣿
⡇⢸⣿⣿⣿⠀⣿⣿⣿⣿⣿⣧⡘⠻⣾⣷⠾⠋⣰⣿⣿⣿⣿⣿⠀⣿⣿⣿⣧⠘
⣷⣌⠙⠿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣄⣉⣉⣠⣿⣿⣿⣿⣿⣿⣿⠀⣿⡿⠛⣡⣼
⣿⣿⣿⣦⣈⠀⠿⠿⠿⠿⠿⠟⠛⠛⠛⠛⠿⠛⠟⠛⢿⣿⠛⠻⠀⢉⣴⣾⣿⣿
⣿⣿⣿⣿⣿⡀⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠀⣿⣿⣿⣿⣿
  ( Welcome @user 𓋖  Lets Hacke  )
"@ -ForegroundColor Red

Write-Host "`n[💀] System Boot Complete — Hacker Mode Activated..." -ForegroundColor Red
