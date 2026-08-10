$ErrorActionPreference="Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Manifest = Join-Path $Root "SHA256SUMS.txt"

if(-not (Test-Path $Manifest)){ throw "SHA256SUMS.txt not found." }

$failed=$false
Get-Content $Manifest | ForEach-Object {
    if($_ -match '^([A-Fa-f0-9]{64})\s{2}(.+)$'){
        $expected=$matches[1].ToUpper()
        $name=$matches[2]
        $path=Join-Path $Root $name
        if(-not (Test-Path $path)){
            Write-Host "MISSING  $name"
            $failed=$true
        } else {
            $actual=(Get-FileHash $path -Algorithm SHA256).Hash.ToUpper()
            if($actual -eq $expected){
                Write-Host "OK       $name"
            } else {
                Write-Host "MISMATCH $name"
                $failed=$true
            }
        }
    }
}
if($failed){ throw "Integrity verification failed." }
Write-Host ""
Write-Host "ALL FILES VERIFIED"
