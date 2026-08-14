---
name: gbk
description: "Handle Chinese mojibake in CMD, .bat/.cmd files, Windows logs, and native command output by using PowerShell to read raw bytes as GBK/CP936, capture command output with an explicit decoder, and convert it to UTF-8/Unicode. Use when text contains 锟斤拷, mojibake, or replacement characters and the source encoding must be verified."
---

# GBK PowerShell Text Handling

Use this skill when Windows command content is unreadable because bytes were decoded with the wrong encoding. Keep the source unchanged until the decoded result has been checked.

## Required Workflow

1. Classify the source:
   - Existing file: read its raw bytes and choose the decoder explicitly.
   - Native command output: re-run the command and capture it before PowerShell decodes it.
   - Console display only: separate console code-page settings from file encoding.
2. Start with GBK/CP936 when the content is Chinese text from legacy Windows tools. Use `[System.Text.Encoding]::GetEncoding(936)` rather than relying on `Get-Content` defaults.
3. Decode to a .NET string, inspect for replacement characters (`U+FFFD`) and implausible text, then convert or write with an explicit target encoding.
4. Preserve the original and write to a new destination until the result is verified.
5. Report the assumed source encoding, target encoding, source path or command, and any uncertainty.

## Read a GBK File

Use byte-level APIs so the behavior is stable across Windows PowerShell 5.1 and PowerShell 7:

```powershell
$path = 'C:\path\to\input.cmd'
$gbk = [System.Text.Encoding]::GetEncoding(936)
$text = [System.IO.File]::ReadAllText($path, $gbk)
$text
```

For binary-safe inspection or when line handling must be controlled:

```powershell
$bytes = [System.IO.File]::ReadAllBytes($path)
$text = $gbk.GetString($bytes)
```

Do not use bare `Get-Content $path` for a suspected GBK file. Its default encoding differs by PowerShell version and can silently produce mojibake.

## Convert GBK to UTF-8

Never overwrite the source on the first attempt. Use UTF-8 without a BOM unless the consuming application requires a BOM:

```powershell
$source = 'C:\path\to\input.cmd'
$destination = 'C:\path\to\input-utf8.cmd'
$gbk = [System.Text.Encoding]::GetEncoding(936)
$utf8 = [System.Text.UTF8Encoding]::new($false)

$text = [System.IO.File]::ReadAllText($source, $gbk)
[System.IO.File]::WriteAllText($destination, $text, $utf8)
```

To preserve a UTF-8 BOM, construct the encoder with `$true` instead. Do not use `Set-Content -Encoding utf8` when the exact BOM behavior matters, because Windows PowerShell 5.1 and PowerShell 7 differ.

## Capture CMD Output Correctly

If `cmd /c ...` has already been assigned to a PowerShell variable and is garbled, the original bytes usually cannot be recovered from that string. Re-run the command and capture bytes first:

```powershell
$tmp = Join-Path $env:TEMP ("gbk-{0}.log" -f [guid]::NewGuid())
$cmdLine = 'your-command > "' + $tmp + '" 2>&1'
& cmd.exe /d /c $cmdLine

$gbk = [System.Text.Encoding]::GetEncoding(936)
$bytes = [System.IO.File]::ReadAllBytes($tmp)
$text = $gbk.GetString($bytes)
Remove-Item -LiteralPath $tmp
$text
```

Use the GBK decoder only when the program or batch workflow is known to emit GBK/CP936. If the encoding is unknown, retain `$bytes` and test the candidates described below before choosing a decoder. `chcp 936` is not a substitute for this check: some tools emit a fixed encoding, and modern CMD environments can still produce UTF-8 bytes under redirection.

For commands containing shell metacharacters or nested quotes, place the command in a temporary `.cmd` file and redirect that file's output instead of attempting fragile inline quoting. Keep stdout and stderr together only when that is acceptable for the task.

For a native executable that is not a CMD built-in, a process API with `StandardOutputEncoding` and `StandardErrorEncoding` set to `$gbk` is also valid. Avoid sequentially draining large stdout and stderr streams, which can deadlock; use asynchronous reads or redirect to files.

## Distinguish Encoding From Code Pages

- `[System.Text.Encoding]::GetEncoding(936)` decodes GBK/CP936 bytes. This is the primary operation for files and redirected output.
- `chcp 936` requests a CMD code page but does not guarantee that every child tool or redirected stream emits GBK. It does not convert existing bytes or repair a string that PowerShell already misdecoded.
- `$OutputEncoding` controls text sent from PowerShell to a native command. It is not a general decoder for text coming back.
- `[Console]::OutputEncoding` controls console rendering. Changing it may make display readable but does not change the source file.

Prefer explicit byte decoding and temporary captures over global code-page changes.

## Verify Before Trusting the Result

Check for a BOM before assuming GBK. Common prefixes are UTF-8 (`EF BB BF`), UTF-16LE (`FF FE`), and UTF-16BE (`FE FF`). For a file without a BOM:

1. Decode as GBK/936.
2. Check for `U+FFFD`, control-character noise, or implausible Chinese text.
3. If the result is still wrong, test strict UTF-8 and the relevant OEM code page instead of overwriting the file.

Example replacement-character check:

```powershell
if ($text.IndexOf([char]0xFFFD) -ge 0) {
    throw 'Decoding produced replacement characters; do not overwrite the source.'
}
```

When the source encoding is genuinely unknown, state the candidates and evidence. Do not claim that GBK is certain merely because the text is Chinese.

## Common Failure Modes

- Bare `Get-Content`, `gc`, `type`, or `Out-File` silently uses a version- or locale-dependent encoding.
- `chcp 65001` does not convert existing GBK bytes to UTF-8.
- Piping already-decoded text through another encoding command cannot reconstruct lost bytes; capture the command again.
- Converting in place destroys the recovery path. Write a sibling output file and compare it first.
- Treating a `.cmd` extension as an encoding indicator is unsafe; inspect the bytes and content instead.
