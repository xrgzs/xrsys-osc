$ErrorActionPreference = 'Stop'
# 过滤白名单路径
Add-MpPreference -ExclusionPath 'C:\Windows\Setup\Set\*'
Add-MpPreference -ExclusionPath 'C:\Program Files\Xiaoran\*'
Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Xiaoran\*'
# 设置CPU使用的优先级为低
Set-MpPreference -EnableLowCpuPriority $true
# 设置CPU空闲时才执行定时扫描
Set-MpPreference -ScanOnlyIfIdleEnabled $true
# 设置CPU平均使用率（非严格限定值，只是一个平均值），范围为5~100，建议小于10
Set-MpPreference -ScanAvgCPULoadFactor 6
# 关闭快速扫描的追加扫描
Set-MpPreference -DisableCatchupQuickScan $true
# 关闭全部扫描的追加扫描
Set-MpPreference -DisableCatchupFullScan $true
# 暂时关闭实时防御
Set-MpPreference -DisableRealtimeMonitoring $true