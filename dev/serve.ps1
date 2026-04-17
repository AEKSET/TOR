$port = 8080
$root = $PSScriptRoot
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving at http://localhost:$port/"

while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $localPath = $req.Url.LocalPath.TrimStart('/')
    if ($localPath -eq '') { $localPath = 'index.html' }
    $filePath = Join-Path $root $localPath
    if (Test-Path $filePath -PathType Leaf) {
        $bytes = [IO.File]::ReadAllBytes($filePath)
        $ext = [IO.Path]::GetExtension($filePath)
        $mime = @{ '.html'='text/html'; '.css'='text/css'; '.js'='application/javascript'; '.json'='application/json'; '.png'='image/png'; '.jpg'='image/jpeg' }[$ext]
        if (-not $mime) { $mime = 'application/octet-stream' }
        $res.ContentType = $mime
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $res.StatusCode = 404
    }
    $res.OutputStream.Close()
}
