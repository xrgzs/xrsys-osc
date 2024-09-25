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
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/irdVI27gi2pg" -o osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe || exit
rem Special purpose, not describable v34.0.0.317
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ihcxj29z4hbe" -o osc\runtime\flash.exe || exit
@rem rem MSVC Runtime repacked by dreamcast2.ys168.com
@rem rem curl.exe -sSL xxxxxxxxxx" -o osc\runtime\MSVBCRT.AIO.exe || exit
rem MSVC Runtime repacked by Xiaoran Studio using NSIS v2024.8.14.0
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iWN6I27gi6ch" -o osc\runtime\MSVCRedist.AIO.exe || exit

rem https://github.com/abbodi1406/KMS_VL_ALL_AIO v52 modified server address
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iEOKz27gibqb" -o osc\xrkms\KMS_VL_ALL_AIO.cmd || exit
rem https://github.com/zbezj/HEU_KMS_Activator v42.2.0
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i8NFT2a8fagh" -o osc\xrkms\kms.exe || exit

rem oscol offline
curl.exe -sSL http://url.xrgzs.top/osconline -o osc\oscoffline.bat || exit
curl.exe -sSL http://url.xrgzs.top/oscsoft -o osc\oscsoftof.txt || exit

rem good thing
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ixdbP27giisf" -o osc\xrsoft.exe || exit

:build
rem use github env version first
if not defined GITHUB_WORKFLOW_VERSION (
  set GITHUB_WORKFLOW_VERSION=2.5.0.0
)
>osc\apifiles\Version.txt echo %GITHUB_WORKFLOW_VERSION%
"C:\Program Files (x86)\NSIS\makensis.exe" /V4 /DCUSTOM_VERSION=%GITHUB_WORKFLOW_VERSION% "osc.nsi" || exit
exit