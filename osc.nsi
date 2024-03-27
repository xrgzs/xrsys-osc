; 安装程序初始定义常量
!define PRODUCT_NAME "潇然系统优化工具"
!define PRODUCT_DESC "潇然系统优化工具"
; !define /date PRODUCT_VERSION "2.24.%m.%d"
!define PRODUCT_PUBLISHER "Xiaoran Studio"
!define PRODUCT_WEB_SITE "https://xrgzs.github.io/"
!define PRODUCT_VERSION "${CUSTOM_VERSION}"

; 实测不压固实更小
SetCompressor lzma
SetCompressorDictSize 32

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON ".\osc.ico"

; 欢迎页面
; !insertmacro MUI_PAGE_WELCOME
; Components page
; !insertmacro MUI_PAGE_COMPONENTS
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
InstallDir "$WINDIR\Setup\Set\osc"
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

Section "XROSC" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite on
  DetailPrint "解压相关数据..."
  File /r ".\osc\*.*"
  DetailPrint "运行OSC主程序..."
  ExecShellWait "open" "$INSTDIR\osc.bat" SW_SHOWMINIMIZED
SectionEnd

Section -Post
SectionEnd
