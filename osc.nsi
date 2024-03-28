Unicode true
; 安装程序初始定义常量
!define PRODUCT_NAME "潇然系统优化工具"
!define PRODUCT_DESC "潇然系统优化工具"
; !define /date PRODUCT_VERSION "3.24.%m.%d"
!define PRODUCT_PUBLISHER "Xiaoran Studio"
!define PRODUCT_WEB_SITE "https://xrgzs.github.io/"
!define PRODUCT_VERSION "${CUSTOM_VERSION}"

; 实测不压固实更小
; SetCompressor lzma
; SetCompressorDictSize 32

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
; 组件选择页面
!insertmacro MUI_PAGE_COMPONENTS
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


Section /o "XRAPI1" XRAPI1
  ${If} ${FileExists} "$INSTDIR\xrsysstepapifiles.flag"
    DetailPrint "APIFILES已经解压，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapifiles.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR\apifiles"
	  SetOverwrite on
	  DetailPrint "解压APIFILES..."
	  File ".\osc\apifiles\*.*"
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

Section /o "XRAPI2" XRAPI2
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

Section /o "XRAPI3" XRAPI3
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

Section /o "XRAPI4" XRAPI4
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

Section /o "XRAPI5" XRAPI5
  ${If} ${FileExists} "$INSTDIR\xrsysstepapi5.flag"
    DetailPrint "API5已经执行，跳过此操作！"
  ${Else}
    FileOpen $0 "$INSTDIR\xrsysstepapi5.flag" w
    FileClose $0
	  SetOutPath "$INSTDIR"
	  SetOverwrite try
	  DetailPrint "解压并执行API5..."
	  File ".\api\api.bat"
		ExecShellWait "open" "$OUTDIR\api.bat" "/5" SW_SHOWMINIMIZED
	${EndIf}
SectionEnd

Section "XROSC" XROSC
  SetOutPath "$INSTDIR\osc"
  SetOverwrite try
  DetailPrint "解压相关OSC数据..."
  File /r ".\osc\*.*"
  DetailPrint "运行OSC主程序..."
  ExecShellWait "open" "$INSTDIR\osc\osc.bat" SW_SHOWMINIMIZED
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
