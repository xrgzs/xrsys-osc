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
rem download special file (too large or i don't want see in this open-source repository)
rem 7-zip (x86) 24.08
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ioeIt27ggtof" -o osc\apifiles\7z.exe || exit
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i0oS627ggtja" -o osc\apifiles\7z.dll || exit
rem DMI-table decoder by GNU v2.10
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/imAhv27gh4ob" -o osc\apifiles\DMI.exe || exit
rem Special purpose, not describable v3.1.0.0
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iyP0g27gh8ij" -o osc\apifiles\DriveCleaner.exe || exit
rem NetUser V1.01  16/12/97  (c) Siemens AG, ATD OI
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iuHSS27ghaha" -o osc\apifiles\NetUser.exe || exit
rem NirCmd v2.87 https://www.nirsoft.net/utils/nircmd.html
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ievIe27ghldc" -o osc\apifiles\nircmd.exe || exit
rem https://github.com/M2TeamArchived/NSudo/releases v8.2
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/inJx527ghore" -o osc\apifiles\NSudoLC.exe || exit
rem DrvIndex_x64-86-v7.23.10.2501
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i0xcO27ghqla" -o osc\apifiles\DrvIndex.exe || exit
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i1OJm27ghr3i" -o osc\apifiles\DrvIndex64.exe || exit
rem PECMD2012.1.88.05.94Stable-230422 x86 x64 noimd safe
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iYyPD27ght6d" -o osc\apifiles\PECMD.exe || exit
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/inl1x27ghtda" -o osc\apifiles\PECMD64.exe || exit
rem SystemRestore tool by hp
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iVJ2d27ghuwf" -o osc\apifiles\srtool.exe || exit
rem Wbox - Ver. 1.11 - Message box for batch - (c) 2011-2013, Horst Schaeffer
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i3ICl27ghwmh" -o osc\apifiles\Wbox.exe || exit
rem Winput Ver. 1.42 (c) 2007-2018, Horst Schaeffer
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iB8jF27ghx0b" -o osc\apifiles\winput.exe || exit
rem wifi configurator for winxp from a forum i can't remember
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i9Cur27ghxab" -o osc\apifiles\WLAN.exe || exit
rem Windows Update Blocker v1.8.0 https://www.sordum.org/9470
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i11k627ghxlc" -o osc\apifiles\Wub.exe || exit

rem OSFMount v1.5.1015 for better capability
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iDpL727ghyzc" -o osc\Office\OSFMount.sys || exit
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iBdf027ghywj" -o osc\Office\OSFMount.com || exit

rem bookmarks for msedge v24.1.22
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iHh5O27gi1rc" -o osc\optimize\bookmarks.exe || exit

rem https://github.com/stdin82/htfx/releases v0.0.3
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/irdVI27gi2pg" -o osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe || exit
rem Special purpose, not describable v34.0.0.317
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ihcxj29z4hbe" -o osc\runtime\flash.exe || exit
@rem rem MSVC Runtime repacked by dreamcast2.ys168.com
@rem rem curl.exe -sSL xxxxxxxxxx" -o osc\runtime\MSVBCRT.AIO.exe || exit
rem MSVC Runtime repacked by Xiaoran Studio using NSIS v2024.8.14.0
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iWN6I27gi6ch" -o osc\runtime\MSVCRedist.AIO.exe || exit
rem APPX Media Extentions
@rem pwsh.exe -file osc\runtime\getappx.ps1

rem PinToTaskbar x64 v1.0.1.11 by CrystalIDEA
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iIjeG27gia5e" -o osc\themerec\PinToTaskbar.exe || exit
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iBytS27gia7g" -o osc\themerec\PinToTaskbarHelper.dll || exit

rem EnterpriseG SKU xrm-ms file
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/itk3827giati" -o osc\xrkms\EnterpriseG.cab || exit
rem https://github.com/abbodi1406/KMS_VL_ALL_AIO v52 modified server address
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iEOKz27gibqb" -o osc\xrkms\KMS_VL_ALL_AIO.cmd || exit
rem https://github.com/zbezj/HEU_KMS_Activator v42.2.0
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/i8NFT2a8fagh" -o osc\xrkms\kms.exe || exit
rem https://github.com/Wind4/vlmcsd/releases v1113
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/ibdGz27gieud" -o osc\xrkms\vlmcs.exe || exit

rem aria2c.exe v1.37.0 https://gitlab.com/q3aql/aria2-static-builds
curl.exe -sSL "https://api.xrgzs.top/lanzou/?type=down&url=https://xrgzs.lanzouv.com/iLzju27gigxi" -o osc\aria2c.exe || exit

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