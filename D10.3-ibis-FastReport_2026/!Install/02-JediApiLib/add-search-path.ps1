$ErrorActionPreference = "Stop"

# Подключение внешнего файла конфигурации (Dot Sourcing)
if (Test-Path -Path "$PSScriptRoot\config.ps1") {
    . "$PSScriptRoot\config.ps1"
} else {
    Write-Error "Файл конфигурации config.ps1 не найден!"
    Read-Host "Нажмите Enter для выхода..."
    exit
}


# Путь к ключу реестра и имя параметра



$registryPath = "HKCU:\Software\Embarcadero\BDS\$BDSVER\Library\Win32"
$valueName    = "Search Path"
$pathToAdd    = "C:\DelphiLib\jedi-apilib\jwapi\trunk\DCU_D$IDEVer"


# Проверка существования ветки реестра
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Получение текущего значения
$currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

if ($null -eq $currentValue) {
    # Если параметра не существовало, создаем его с новым путем
    New-ItemProperty -Path $registryPath -Name $valueName -Value $pathToAdd -PropertyType String -Force | Out-Null
    Write-Host "Параметр 'Search Path' создан со значением: $pathToAdd" -ForegroundColor Green
} else {
    # Разделяем пути по точке с запятой и очищаем от пробелов
    $existingPaths = $currentValue -split ';' | ForEach-Object { $_.Trim() }

    # Проверяем, есть ли уже такой путь (без учета регистра)
    if ($existingPaths -contains $pathToAdd) {
        Write-Host "Данный путь уже присутствует в Search Path." -ForegroundColor Yellow
    } else {
        # Формируем новую строку, добавляя точку с запятой при необходимости
        if ($currentValue -match ';$') {
            $newValue = $currentValue + $pathToAdd
        } elseif ($currentValue -eq "") {
            $newValue = $pathToAdd
        } else {
            $newValue = $currentValue + ";" + $pathToAdd
        }
        
        # Записываем обновленное значение в реестр
        Set-ItemProperty -Path $registryPath -Name $valueName -Value $newValue -Force
        Write-Host "Путь успешно добавлен в конец Search Path." -ForegroundColor Green
    }
}
