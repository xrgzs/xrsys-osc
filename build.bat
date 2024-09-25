chcp 936
PUSHD %~dp0

:check
echo version: %GITHUB_WORKFLOW_VERSION%
rem lookup nsis location
if not exist "C:\Program Files (x86)\NSIS\makensis.exe" (
  echo Cannot find nsis!
  exit
)

:download
if exist osc\xrsoft.exe goto build

rem https://github.com/stdin82/htfx/releases v0.0.3
call :downloadlanzou "https://xrgzs.lanzouv.com/irdVI27gi2pg" osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe
rem Special purpose, not describable v34.0.0.317
call :downloadlanzou "https://xrgzs.lanzouv.com/ihcxj29z4hbe" osc\runtime\flash.exe
@rem rem MSVC Runtime repacked by dreamcast2.ys168.com
@rem rem curl.exe -sSL xxxxxxxxxx" -o osc\runtime\MSVBCRT.AIO.exe || exit
rem MSVC Runtime repacked by Xiaoran Studio using NSIS v2024.8.14.0
call :downloadlanzou "https://xrgzs.lanzouv.com/iWN6I27gi6ch" osc\runtime\MSVCRedist.AIO.exe

rem https://github.com/abbodi1406/KMS_VL_ALL_AIO v52 modified server address
call :downloadlanzou "https://xrgzs.lanzouv.com/iEOKz27gibqb" osc\xrkms\KMS_VL_ALL_AIO.cmd
rem https://github.com/zbezj/HEU_KMS_Activator v42.2.0
call :downloadlanzou "https://xrgzs.lanzouv.com/i8NFT2a8fagh" osc\xrkms\kms.exe

rem oscol offline
curl.exe -SL --connect-timeout 5 http://url.xrgzs.top/osconline -o osc\oscoffline.bat || exit
curl.exe -SL --connect-timeout 5 http://url.xrgzs.top/oscsoft -o osc\oscsoftof.txt || exit

rem good thing
call :downloadlanzou "https://xrgzs.lanzouv.com/ixdbP27giisf" osc\xrsoft.exe

:build
rem use github env version first
if not defined GITHUB_WORKFLOW_VERSION (
  set GITHUB_WORKFLOW_VERSION=2.5.0.0
)
>osc\apifiles\Version.txt echo %GITHUB_WORKFLOW_VERSION%
"C:\Program Files (x86)\NSIS\makensis.exe" /V4 /DCUSTOM_VERSION=%GITHUB_WORKFLOW_VERSION% "osc.nsi" || exit
exit

:downloadlanzou <shareurl> <outpath>
curl.exe -SL --connect-timeout 3 "https://api.xrgzs.top/lanzou/?type=down&url=%~1" -o "%~2" || (
    @echo api.xrgzs.top failed, try another...
    curl.exe -SL --connect-timeout 3 "https://lz.qaiu.top/parser?url=%~1" -o "%~2" || exit
)
goto :eof