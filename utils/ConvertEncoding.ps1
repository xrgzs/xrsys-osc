# 定义尝试的编码列表
$encodings = [System.Text.Encoding]::UTF8, [System.Text.Encoding]::Unicode, [System.Text.Encoding]::GetEncoding("GB2312"), [System.Text.Encoding]::ASCII, [System.Text.Encoding]::GetEncoding("Big5")

# 获取所有 .reg 文件
$files = Get-ChildItem "*.reg" -Recurse

foreach ($file in $files) {
    $isCorrect = $false
    foreach ($encoding in $encodings) {
        try {
            $content = [System.IO.File]::ReadAllText($file.FullName, $encoding)
            Write-Host "$content" -BackgroundColor DarkGray
            Write-Host "尝试使用 $($encoding.WebName) 编码读取文件 '$($file.Name)'。" -ForegroundColor Green
            Write-Host "这是正常的文件吗？(y/n)" -ForegroundColor Yellow
            $answer = Read-Host
            if ($answer.ToLower() -eq 'y') {
                $isCorrect = $true
                break
            }
        } catch {
            Write-Host "使用 $($encoding.WebName) 编码读取文件失败。"
        }
    }

    if (-not $isCorrect) {
        Write-Host "请指定正确的编码："
        $customEncodingName = Read-Host
        $customEncoding = [System.Text.Encoding]::GetEncoding($customEncodingName)

        try {
            $content = [System.IO.File]::ReadAllText($file.FullName, $customEncoding)
            Write-Host "使用自定义编码 '$customEncodingName' 成功读取文件。"
        } catch {
            Write-Host "使用自定义编码 '$customEncodingName' 读取文件失败。"
            continue
        }
    }

    # 转换文件为 UTF-16LE 编码
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::Unicode)
    Write-Host "文件 '$($file.Name)' 已成功转换为 UTF-16LE 编码。"
}