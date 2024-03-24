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
rem 7-zip (x86) 2420
curl.exe -L https://file.uhsea.com/2403/35437cddd4ab429366756b60bfab91cfOY.exe -o osc\apifiles\7z.exe || exit
curl.exe -L https://file.uhsea.com/2403/49bcd9129f345d002933e31d4a60df24BU.dll -o osc\apifiles\7z.dll || exit
rem DMI-table decoder by GNU v2.10
curl.exe -L https://file.uhsea.com/2403/660e7e160669d06fbcb2771dc684091929.exe -o osc\apifiles\DMI.exe || exit
rem Special purpose, not describable
curl.exe -L https://file.uhsea.com/2403/5b5716e6373e21f2a4c3ed211cecb9f1SI.exe -o osc\apifiles\DriveCleaner.exe || exit
rem NetUser V1.01  16/12/97  (c) Siemens AG, ATD OI
curl.exe -L https://file.uhsea.com/2403/e064a2a4212ba04cfcb9a88f8d50c9b4H1.exe -o osc\apifiles\NetUser.exe || exit
rem NirCmd v2.86 https://www.nirsoft.net/utils/nircmd.html
curl.exe -L https://file.uhsea.com/2403/041d60d1cfc87214b254f75e8381037e80.exe -o osc\apifiles\nircmd.exe || exit
rem https://github.com/M2TeamArchived/NSudo/releases v8.2
curl.exe -L https://file.uhsea.com/2403/10fdf98fa1b888327c172e04bb92d762KW.exe -o osc\apifiles\NSudoLC.exe || exit
rem PECMD (support xpx86)
curl.exe -L https://file.uhsea.com/2403/d980423f7b70300b7b825650bc30cdbfIR.exe -o osc\apifiles\PECMD.exe || exit
rem SystemRestore tool by hp
curl.exe -L https://file.uhsea.com/2403/ca1e5c28b2637b556dff75d0043a2504FF.exe -o osc\apifiles\srtool.exe || exit
rem Deploying wallpaper (deprecated, need to be replace in another way)
curl.exe -L https://file.uhsea.com/2403/19d6324930e94b1a17d0be592e26ad97GE.exe -o osc\apifiles\waller.exe || exit
curl.exe -L https://file.uhsea.com/2403/06ba4e1e2830ad660395601917eaaf48KF.exe -o osc\apifiles\wall.exe || exit
rem Wbox - Ver. 1.11 - Message box for batch - (c) 2011-2013, Horst Schaeffer
curl.exe -L https://file.uhsea.com/2403/2f59ebbab5b524bd242bfd83a1845c64D9.exe -o osc\apifiles\Wbox.exe || exit
rem Winput Ver. 1.42 (c) 2007-2018, Horst Schaeffer
curl.exe -L https://file.uhsea.com/2403/212e6eeedcca0e58df990a17a6169a33TN.exe -o osc\apifiles\winput.exe || exit
rem wifi configurator for winxp from a forum i can't remember
curl.exe -L https://file.uhsea.com/2403/78e44975be54d2da27e86d98077352edGA.exe -o osc\apifiles\WLAN.exe || exit
rem Windows Update Blocker v1.8.0 https://www.sordum.org/9470
curl.exe -L https://file.uhsea.com/2403/f09c1fff4772af233adb0f28341fc743MY.exe -o osc\apifiles\Wub.exe || exit

rem OSFMount v1.5.1015 for better capability
curl.exe -L https://file.uhsea.com/2403/5ed4bb9132f5c5491d1b89994406f4028C.sys -o osc\Office\OSFMount.sys || exit
curl.exe -L https://file.uhsea.com/2403/db6d475dd41b68aeded317c26a1006c827.com -o osc\Office\OSFMount.com || exit

rem bookmarks for msedge v24.1.22
curl.exe -L https://file.uhsea.com/2403/db3dd0ec3d67a2f9becee7eaedf1e75073.exe -o osc\optimize\bookmarks.exe || exit
rem third-party optimizer, to be removed in the next stage
curl.exe -L https://file.uhsea.com/2403/78bbd63d73cc4a43dfa4149063799214H8.exe -o osc\optimize\yrxitong\yr.exe || exit

rem https://github.com/stdin82/htfx/releases v0.0.3
curl.exe -L https://file.uhsea.com/2403/693274c6ee6e975023df0eb1c620f66aB0.exe -o osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe || exit
rem Special purpose, not describable
curl.exe -L https://file.uhsea.com/2403/28600f9dfa3aeac0614201fddf09141dQY.exe -o osc\runtime\flash.exe || exit
rem MSVC Runtime repacked by dreamcast2.ys168.com
curl.exe -L https://file.uhsea.com/2403/f43c0f0045868282bb889beaab16d5a592.exe -o osc\runtime\MSVBCRT.AIO.exe || exit

rem PinToTaskbar x64 v1.0.1.11 by CrystalIDEA
curl.exe -L https://file.uhsea.com/2403/e5e9632d220dd682bbcdd55cea4bbd57UM.exe -o osc\themerec\PinToTaskbar.exe || exit
curl.exe -L https://file.uhsea.com/2403/673702659eeb280af390dff3a850ad19BA.dll -o osc\themerec\PinToTaskbarHelper.dll || exit

rem EnterpriseG SKU xrm-ms file
curl.exe -L https://file.uhsea.com/2403/7523c3a4a1c8f98f445765632f51f7c4HB.cab -o osc\xrkms\EnterpriseG.cab || exit
rem https://github.com/abbodi1406/KMS_VL_ALL_AIO v51 modified server address
curl.exe -L https://file.uhsea.com/2403/91cac88fb2888f3c440e2b99438f8fa9YF.cmd -o osc\xrkms\KMS_VL_ALL_AIO.cmd || exit
rem https://github.com/zbezj/HEU_KMS_Activator v42.0.1 modified server address
curl.exe -L https://file.uhsea.com/2403/6fd244ecd56e9595ad281101c49559b1W2.exe -o osc\xrkms\kms.exe || exit
rem https://github.com/Wind4/vlmcsd/releases v1113
curl.exe -L https://file.uhsea.com/2403/245d2208cc94c71240a0ef24b4fbd928CY.exe -o osc\xrkms\vlmcs.exe || exit

rem aria2c.exe v1.37.0 https://gitlab.com/q3aql/aria2-static-builds
curl.exe -L https://file.uhsea.com/2403/de8fd4f9dd9a0ac4b81aaefb72a3ba91KX.exe -o osc\aria2c.exe || exit
rem good thing
curl.exe -L https://file.uhsea.com/2403/a2e2d81f11eec83da97313b2adbc9b8672.exe -o osc\xrsoft.exe || exit

:build
rem use github env version first
if defined GITHUB_WORKFLOW_VERSION (
  "C:\Program Files (x86)\NSIS\makensis.exe" /V4 /DCUSTOM_VERSION=%GITHUB_WORKFLOW_VERSION% "osc.nsi" || exit
) else (
  "C:\Program Files (x86)\NSIS\makensis.exe" /V4 "osc.nsi" || exit
)

exit