Unicode true
; 安装程序初始定义常量
!define PRODUCT_NAME "潇然系统"
!define PRODUCT_DESC "潇然系统优化组件"
; !define /date PRODUCT_VERSION "3.24.%m.%d"
!define PRODUCT_PUBLISHER "Xiaoran Studio"
!define PRODUCT_WEB_SITE "https://xrgzs.github.io/"
!define PRODUCT_VERSION "${CUSTOM_VERSION}"

; 实测不压固实更小
SetCompressor lzma
SetCompressorDictSize 32

!include "x64.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON ".\osc.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE ".\osc\LICENSE.txt"
; 组件选择页面
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ComponentsPageShow
!insertmacro MUI_PAGE_COMPONENTS
; 自定义页面
Function ComponentsPageShow
  ; 获取窗口句柄
  FindWindow $0 "#32770" "" $HWNDPARENT
  ; 创建RECT结构体来存储尺寸信息
  System::Alloc 16 ; RECT结构体大小为16字节
  Pop $1 ; 将地址存储在$1
  ; 调用GetClientRect来填充RECT结构体
  System::Call 'User32::GetClientRect(i $HWNDPARENT, i $1)'
  ; 从RECT结构体中读取宽度和高度
  System::Call '*$1(i .r2, i .r3, i .r4, i .r5)' ; r2=left, r3=top, r4=right, r5=bottom
  IntOp $6 $4 - $2 ; 计算宽度
  IntOp $7 $5 - $3 ; 计算高度
  ; 根据窗口尺寸调整组件框大小
  GetDlgItem $8 $0 1032
  System::Call "User32::SetWindowPos(i $8, i 0, i 0, i 0, ir6, ir7, i 0)"
  ; 释放RECT结构体内存
  System::Free $1
  ; 获取组件框句柄并调整组件框大小
	GetDlgItem $1 $0 1006 ;上方提示语
	ShowWindow $1 ${SW_HIDE}
	GetDlgItem $1 $0 1021 ;左侧横条
	ShowWindow $1 ${SW_HIDE}
	GetDlgItem $1 $0 1022 ;左侧提示语
	ShowWindow $1 ${SW_HIDE}
	GetDlgItem $1 $0 1023 ;左侧所需空间
	ShowWindow $1 ${SW_HIDE}
	GetDlgItem $1 $0 1042 ;右侧组件描述
	ShowWindow $1 ${SW_HIDE}
	GetDlgItem $1 $0 1043 ;右侧组件描述内容
	ShowWindow $1 ${SW_HIDE}

  ; 创建Windir\Setup文件夹
  CreateDirectory "$WINDIR\Setup"
FunctionEnd
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
; !insertmacro MUI_PAGE_FINISH

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------


Name "${PRODUCT_NAME} V${PRODUCT_VERSION}"
OutFile "osc.exe"
InstallDir "$WINDIR\Setup\Set"
ShowInstDetails show
BrandingText "${PRODUCT_NAME} V${PRODUCT_VERSION}"

; info of installer execute file
VIProductVersion "${PRODUCT_VERSION}" ;版本号，格式为 X.X.X.X (若使用则本条必须)
VIAddVersionKey FileDescription "${PRODUCT_DESC}" ;文件描述(标准信息)
VIAddVersionKey FileVersion "${PRODUCT_VERSION}" ;文件版本(标准信息)
VIAddVersionKey ProductName "${PRODUCT_NAME} V${PRODUCT_VERSION}" ;产品名称
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}" ;产品版本
VIAddVersionKey Comments "${PRODUCT_NAME} V${PRODUCT_VERSION}" ;备注
VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}" ;公司名
VIAddVersionKey LegalCopyright "Copyright @ 2024 ${PRODUCT_PUBLISHER}. All Rights Reserved." ;合法版权
VIAddVersionKey InternalName "${PRODUCT_NAME}" ;内部名称
VIAddVersionKey LegalTrademarks "${PRODUCT_PUBLISHER}" ;合法商标 ;
VIAddVersionKey OriginalFilename "osc.exe" ;源文件名
VIAddVersionKey PrivateBuild "XRSYS" ;个人内部版本说明
VIAddVersionKey SpecialBuild "NSIS" ;特殊内部版本说明


Section /o "-潇然系统部署接口-部署前" XRAPI1
  ${If} ${FileExists} "$INSTDIR\xrsysstepapifiles.flag"
    DetailPrint "APIFILES已经解压，跳过此操作！"
  ${Else}
	  SetOutPath "$INSTDIR\apifiles"
	  SetOverwrite on
	  DetailPrint "解压APIFILES..."
	  File /r ".\osc\apifiles\*.*"
    FileOpen $0 "$INSTDIR\xrsysstepapifiles.flag" w
    FileClose $0
  ${EndIf}

  ${If} ${FileExists} "$INSTDIR\xrsysstepapi1.flag"
    DetailPrint "API1已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi1.flag" w
    FileClose $0
    SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API1..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/1" SW_SHOWMINIMIZED
  ${EndIf}
SectionEnd

Section /o "-潇然系统部署接口-部署中" XRAPI2
  ${If} ${FileExists} "$INSTDIR\xrsysstepapi2.flag"
    DetailPrint "API2已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi2.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API2..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/2" SW_SHOWMINIMIZED
	${EndIf}
SectionEnd

Section /o "-潇然系统部署接口-部署后" XRAPI3
  ${If} ${FileExists} "$INSTDIR\xrsysstepapi3.flag"
    DetailPrint "API3已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi3.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API3..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/3" SW_SHOWMINIMIZED
	${EndIf}
SectionEnd

Section /o "-潇然系统部署接口-登录时" XRAPI4
  ${If} ${FileExists} "$INSTDIR\xrsysstepapifiles.flag"
    DetailPrint "APIFILES已经解压，跳过此操作！"
  ${Else}
	  SetOutPath "$INSTDIR\apifiles"
	  SetOverwrite on
	  DetailPrint "解压APIFILES..."
	  File /r ".\osc\apifiles\*.*"
    FileOpen $0 "$INSTDIR\xrsysstepapifiles.flag" w
    FileClose $0
  ${EndIf}

  ${If} ${FileExists} "$INSTDIR\xrsysstepapi4.flag"
    DetailPrint "API4已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi4.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API4..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/4" SW_SHOWMINIMIZED
	${EndIf}
SectionEnd

Section /o "-潇然系统部署接口-进桌面" XRAPI5
  ${If} ${FileExists} "$INSTDIR\xrsysstepapi5.flag"
    DetailPrint "API5已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi5.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API5..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/5" SW_HIDE
	${EndIf}
SectionEnd

SectionGroup "优化设置"
  Section /o "清理上次运行信息"
    nsExec::ExecToLog 'cmd.exe /c "del /f /q "%WinDir%\\Setup\\*.txt""'
    nsExec::ExecToLog 'cmd.exe /c "del /f /q "%WinDir%\\Version.txt""'
  SectionEnd
  Section /o "自行解决正版化"
    DetailPrint "正在输出TAG-xrsysnokms..."
    FileOpen $0 "$WINDIR\Setup\xrsysnokms.txt" w
    FileClose $0
  SectionEnd
  Section /o "禁用安装运行库"
    DetailPrint "正在输出TAG-xrsysnoruntime..."
    FileOpen $0 "$WINDIR\Setup\xrsysnoruntime.txt" w
    FileClose $0
  SectionEnd
  Section /o "禁用安装主题"
    DetailPrint "正在输出TAG-xrsysnotheme..."
    FileOpen $0 "$WINDIR\Setup\xrsysnotheme.txt" w
    FileClose $0
  SectionEnd
  Section /o "禁用安装软件"
    DetailPrint "正在输出TAG-zjsoftforcepure..."
    FileOpen $0 "$WINDIR\Setup\zjsoftforcepure.txt" w
    FileClose $0
  SectionEnd
  Section /o "启用安装软件"
    DetailPrint "正在输出TAG-zjsoftforce..."
    FileOpen $0 "$WINDIR\Setup\zjsoftforce.txt" w
    FileClose $0
  SectionEnd
  Section /o "强制禁用Windows Update"
    DetailPrint "正在输出TAG-xrsysfkwu..."
    FileOpen $0 "$WINDIR\Setup\xrsysfkwu.txt" w
    FileClose $0
  SectionEnd
  Section /o "启用UAC"
    DetailPrint "正在输出TAG-xrsysuac..."
    FileOpen $0 "$WINDIR\Setup\xrsysuac.txt" w
    FileClose $0
  SectionEnd
  Section /o "禁用设置机器名"
    DetailPrint "正在输出TAG-xrsysnopcname..."
    FileOpen $0 "$WINDIR\Setup\xrsysnopcname.txt" w
    FileClose $0
  SectionEnd
  Section /o "禁用上报安装信息"
    DetailPrint "正在输出TAG-xrsysnoupdata..."
    FileOpen $0 "$WINDIR\Setup\xrsysnoupdata.txt" w
    FileClose $0
  SectionEnd
SectionGroupEnd

Section "-潇然系统优化工具" XROSC
  SetOutPath "$INSTDIR\osc"
  SetOverwrite try
  DetailPrint "解压相关OSC数据..."
  File /r ".\osc\*.*"
  DetailPrint "运行OSC主程序..."
  ${DisableX64FSRedirection}
  nsExec::ExecToLog "$INSTDIR\osc\osc.bat"
SectionEnd

Section -Post
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function .onInit
	${If} ${RunningX64}
		${DisableX64FSRedirection}
		SetRegView 64
	${EndIf}
	
	${GetParameters} $0 ;获取传入参数
  ${GetOptions} $0 "/1" $1  ;检查执行XRAPI /1参数
	IfErrors +3 +1
	SectionSetFlags ${XROSC} 0
  SectionSetFlags ${XRAPI1} 1
  
  ${GetOptions} $0 "/2" $1  ;检查执行XRAPI /2参数
	IfErrors +3 +1
	SectionSetFlags ${XROSC} 0
  SectionSetFlags ${XRAPI2} 1
  
  ${GetOptions} $0 "/3" $1  ;检查执行XRAPI /3参数
	IfErrors +3 +1
	SectionSetFlags ${XROSC} 0
  SectionSetFlags ${XRAPI3} 1
  
  ${GetOptions} $0 "/4" $1  ;检查执行XRAPI /4参数
	IfErrors +3 +1
	SectionSetFlags ${XROSC} 0
  SectionSetFlags ${XRAPI4} 1
  
  ${GetOptions} $0 "/5" $1  ;检查执行XRAPI /5参数
	IfErrors +3 +1
	SectionSetFlags ${XROSC} 0
  SectionSetFlags ${XRAPI5} 1
  
FunctionEnd
