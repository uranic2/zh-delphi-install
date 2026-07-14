$ErrorActionPreference = "Stop"

# Подключение внешнего файла конфигурации (Dot Sourcing)
if (Test-Path -Path "$PSScriptRoot\config.ps1") {
    . "$PSScriptRoot\config.ps1"
} else {
    Write-Error "Файл конфигурации config.ps1 не найден!"
    Read-Host "Нажмите Enter для выхода..."
    exit
}

# Сборка путей к библиотекам
$LibPaths = @(
    "$BDS\lib\Win32\Release"
    "C:\DelphiLib\Devexpress $DXVer\Library\RS$IDEVer"
    "C:\Users\Public\Documents\Embarcadero\Studio\$BDSVER\Dcp"
)
$DELPHI_LIB = $LibPaths -join ";"

# Список Unit Scope Names
$ScopesList = @(
    "Winapi"; "System"; "Xml"; "Data"; "Datasnap"; "Web"
    "Soap"; "Vcl"; "Vcl.Imaging"; "Vcl.Touch"; "Vcl.Samples"; "Vcl.Shell"
)
$SCOPES = $ScopesList -join ";"

# Переход в рабочую директорию пакетов
Set-Location -Path "$LIB_DIR\packages"

# Создание целевой папки, если она отсутствует
if (-not (Test-Path -Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# Массив аргументов для компилятора
$CompilerArgs = @(
    "-B"
    "-N0$OUTPUT_DIR"
    "-LE$OUTPUT_DIR"
    "-LN$OUTPUT_DIR"
    "-U$DELPHI_LIB"
    "-I$DELPHI_LIB"
    "-O$DELPHI_LIB"
    "-NS$SCOPES"
    "cxStatusKeeperPackageRS$IDEVer.dpk"
)

# Запуск компиляции
Write-Host "Запуск компиляции пакета cxStatusKeeperPackageRS$IDEVer..." -ForegroundColor Cyan
& $DCC32_EXE $CompilerArgs

# Проверка результата сборки
if ($LASTEXITCODE -eq 0) {
    Write-Host "`n[УСПЕХ] Сборка завершена удачно." -ForegroundColor Green
    
    # Регистрация пакета в реестре Delphi IDE
    Write-Host "Регистрация пакета в Delphi Known Packages..." -ForegroundColor Cyan
    
    $RegPath  = "HKCU:\Software\Embarcadero\BDS\$BDSVER\Known Packages"
    $BplPath  = "$OUTPUT_DIR\cxStatusKeeperPackageRS$IDEVer.bpl"
    $BplDesc  = "cxStatusKeeperPackageRS"
    
    New-ItemProperty -Path $RegPath -Name $BplPath -Value $BplDesc -PropertyType String -Force | Out-Null
    
    Write-Host "Пакет успешно зарегистрирован!" -ForegroundColor Green
} else {
    Write-Warning "`n[ОШИБКА] Компилятор dcc32 вернул код ошибки: $LASTEXITCODE. Регистрация в реестре отменена."
}

# Пауза
Read-Host "`nДля продолжения нажмите Enter..."