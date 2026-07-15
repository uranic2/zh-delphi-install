$ErrorActionPreference = "Stop"

# 1. Настройка путей (измените под ваш проект)
$SOURCE_DIR = "C:\DelphiLib\jedi-apilib\jwapi\trunk\Win32API"                # Папка, где лежат ваши .pas файлы
$OUTPUT_DIR = "C:\DelphiLib\jedi-apilib\jwapi\trunk\DCU_D26"     # Куда складывать скомпилированные .dcu

# Подключение внешнего файла конфигурации (Dot Sourcing)
if (Test-Path -Path "$PSScriptRoot\config.ps1") {
    . "$PSScriptRoot\config.ps1"
} else {
    Write-Error "Файл конфигурации config.ps1 не найден!"
    Read-Host "Нажмите Enter для выхода..."
    exit
}


# Проверяем наличие компилятора
if (-not (Test-Path -Path $DCC32_EXE)) {
    Write-Host "[ОШИБКА] Компилятор dcc32.exe не найден по пути: $Dcc32Path" -ForegroundColor Red
    return
}

# 2. Поиск всех .pas файлов в директории
Write-Host "[ПОИСК] Поиск исходных кодов в $SourceDir..." -ForegroundColor Cyan
$pasFiles = Get-ChildItem -Path $SOURCE_DIR -Filter "*.pas" -File

if ($pasFiles.Count -eq 0) {
    Write-Host "[INFO] В папке $$SOURCE_DIR не найдено файлов .pas для компиляции." -ForegroundColor Yellow
    return
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


# 3. Цикл компиляции
Write-Host "[СТАРТ] Найдено файлов: $($pasFiles.Count). Запуск dcc32..." -ForegroundColor Cyan

foreach ($file in $pasFiles) {
    Write-Host "`n[COMPILING] $($file.Name)..." -ForegroundColor Magenta
    
    # Формируем аргументы для dcc32:
    # -B = Полная пересборка (Build all)
    # -Q = Quiet режим (выводить только ошибки/предупреждения)
    # -N = Путь для сохранения выходных .dcu файлов
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
     $file.FullName
)

    
    # Запуск компилятора
    & $DCC32_EXE $CompilerArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[УСПЕХ] Скомпилирован: $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "[ОШИБКА] Ошибка компиляции файла: $($file.Name)" -ForegroundColor Red
        # Если нужно прервать весь скрипт при первой ошибке компиляции, раскомментируйте строку ниже:
        # return
    }
}

Write-Host "`n[ЗАВЕРШЕНО] Процесс компиляции окончен." -ForegroundColor Green
