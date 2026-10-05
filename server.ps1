Add-Type -AssemblyName System.Web

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://*:8080/')
$listener.Start()

Write-Host "=======================================================" -ForegroundColor Green
Write-Host " [v] srever working!" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Green
Write-Host ""

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $response = $context.Response
        
        # جلب النص من الحافظة
        $text = Get-Clipboard
        if ([string]::IsNullOrWhiteSpace($text)) {
            $text = "لم يتم نسخ أي نص بعد..."
        }
        
        $encodedText = [System.Web.HttpUtility]::HtmlEncode($text)
        
        # تصميم صفحة الاستقبال للهاتف
        $html = @"
<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>الحافظة المحلية</title>
    <style>
        body { font-family: system-ui, sans-serif; padding: 20px; background: #f0f2f5; margin: 0; }
        .card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); }
        .title { font-size: 14px; color: #65676b; margin-bottom: 12px; font-weight: bold; }
        .content { font-size: 18px; line-height: 1.6; color: #050505; white-space: pre-wrap; word-break: break-word; }
    </style>
</head>
<body>
    <div class="card">
        <div class="title">📋 آخر نص تم نسخه من الكمبيوتر:</div>
        <div class="content">$encodedText</div>
    </div>
</body>
</html>
"@

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
    catch {
        # تجاهل أخطاء قطع الاتصال السريع من المتصفح
    }
}
