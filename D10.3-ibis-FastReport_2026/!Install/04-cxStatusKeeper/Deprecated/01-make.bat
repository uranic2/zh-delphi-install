@echo on

setlocal
set IDEVer=26
set DXVer=20.1.8

:: Пути к компилятору и проекту 
set "BDS=C:\Program Files (x86)\Embarcadero\Studio\20.0"
set "DCC32_EXE=%BDS%\bin\dcc32.exe"
set "LIB_DIR=C:\DelphiLib\cxStatusKeeper"
set "OUTPUT_DIR=%LIB_DIR%\LibD26"

::---------------------------------------------------
:: Пути к стандартным библиотекам Delphi (Rtl, Vcl и т.д.)
set "DELPHI_LIB=%BDS%\lib\Win32\Release;C:\DelphiLib\Devexpress 20.1.8\Library\RS26;C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp"

:: Список Unit Scope Names через точку с запятой (стандартный набор Delphi)
set "SCOPES=Winapi;System;Xml;Data;Datasnap;Web;Soap;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell"

cd %LIB_DIR%
cd packages

:: Создание целевой папки, если её нет
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Компиляция пакета
:: -U (Путь к используемым модулям .dcu)
:: -I (Путь к файлам включения .inc)
:: -O (Путь к объектным файлам .obj)

"%DCC32_EXE%" -B -N0"%OUTPUT_DIR%" -LE"%OUTPUT_DIR%" -LN"%OUTPUT_DIR%" -U"%DELPHI_LIB%" -I"%DELPHI_LIB%" -O"%DELPHI_LIB%" -NS"%SCOPES%" cxStatusKeeperPackageRS%IDEVer%.dpk
rem "%DCC32_EXE%" %CompilerOptionsVCL% dclcxStatusKeeperPackageRS%IDEVer%.dpk 
rem set CompilerOptionsVCL=-B -LEC:\Users\Public\Documents\Embarcadero\Studio\20.0\Bpl -LNC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp  -NU..\LibraryD26 -U"C:\Lib\Devexpress %DXVER%\Library\RS26" -NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell -IC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp cxStatusKeeperPackageRS26.dpk


pause
endlocal
