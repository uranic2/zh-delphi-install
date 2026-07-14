# config.ps1
$IDEVer     = "26"
$BDSVER     = "20.0"
$DXVer      = "20.1.8"

$BDS        = "C:\Program Files (x86)\Embarcadero\Studio\$BDSVER"
$DCC32_EXE  = "$BDS\bin\dcc32.exe"
$LIB_DIR    = "C:\DelphiLib\cxStatusKeeper"
$OUTPUT_DIR = "$LIB_DIR\LibD$IDEVer"