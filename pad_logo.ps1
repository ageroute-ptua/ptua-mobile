Add-Type -AssemblyName System.Drawing
$imagePath = "d:\ptua-mobile\assets\images\ageroute_logo.png"
$outputPath = "d:\ptua-mobile\assets\images\ageroute_logo_padded.png"
$img = [System.Drawing.Image]::FromFile($imagePath)
$size = [Math]::Max($img.Width, $img.Height) * 1.6
$newSize = [int]$size
$bmp = New-Object System.Drawing.Bitmap $newSize, $newSize
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
$x = [int](($newSize - $img.Width) / 2)
$y = [int](($newSize - $img.Height) / 2)
$g.DrawImage($img, $x, $y, $img.Width, $img.Height)
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Image padded successfully."
