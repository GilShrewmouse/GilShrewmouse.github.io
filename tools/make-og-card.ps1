# Draws the link-preview card (assets/img/og-card.jpg, 1200x630) used when the site is shared.
# Run it from the project folder in PowerShell (Windows, no installs needed):
#   powershell -ExecutionPolicy Bypass -File tools\make-og-card.ps1
# Edit the texts / cover names below when the tagline or your favourite games change.
# This folder is excluded from the website (see `exclude:` in _config.yml).
Add-Type -AssemblyName System.Drawing
$repo = Split-Path $PSScriptRoot -Parent
$W = 1200; $H = 630
$gold = [System.Drawing.Color]::FromArgb(214,176,90)

# ---- things you may want to change -------------------------------------------------------
$name    = 'Ekaterina Podsevalova'
$tagline = "(L)QA in gamedev by trade,`nmostly silent lurker by life."
$roles   = 'QA Manager   |   Localization QA   |   Games'
$domain  = 'gilshrewmouse.github.io'
$rightText = 'My game QA portfolio'
$covers  = 'Cyberpunk2077','Hades2','Dispatch','Gothic1Remake'     # file names in assets/img/games (without .jpg)
# ------------------------------------------------------------------------------------------

$bmp = New-Object System.Drawing.Bitmap $W, $H
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'; $g.InterpolationMode = 'HighQualityBicubic'; $g.TextRenderingHint = 'AntiAlias'; $g.PixelOffsetMode = 'HighQuality'
function RoundRect($x,$y,$w,$h,$r) { $p = New-Object System.Drawing.Drawing2D.GraphicsPath; $d = $r*2
  $p.AddArc($x,$y,$d,$d,180,90); $p.AddArc($x+$w-$d,$y,$d,$d,270,90); $p.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90); $p.AddArc($x,$y+$h-$d,$d,$d,90,90); $p.CloseFigure(); $p }
function Draw-Rounded($img,$x,$y,$w,$h,$r,$border) {
  $path = RoundRect $x $y $w $h $r
  $state = $g.Save(); $g.SetClip($path); $g.DrawImage($img, $x, $y, $w, $h); $g.Restore($state)
  if ($border -gt 0) { $pen = New-Object System.Drawing.Pen $gold, $border; $g.DrawPath($pen, $path); $pen.Dispose() }
  $path.Dispose() }

# background photo + the site's warm dark overlay
$bg = [System.Drawing.Image]::FromFile("$repo\assets\img\background.jpg")
$scale = [math]::Max($W / $bg.Width, $H / $bg.Height); $bw = $bg.Width * $scale; $bh = $bg.Height * $scale
$g.DrawImage($bg, ($W - $bw) / 2, ($H - $bh) / 2 - 40, $bw, $bh); $bg.Dispose()
$g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(150, 14, 10, 6))), 0, 0, $W, $H)

# avatar
$av = [System.Drawing.Image]::FromFile("$repo\assets\img\av_square.jpg"); Draw-Rounded $av 80 66 280 280 26 6; $av.Dispose()

# texts
$px = [System.Drawing.GraphicsUnit]::Pixel; $reg = [System.Drawing.FontStyle]::Regular
$fName = New-Object System.Drawing.Font 'Segoe UI Semibold', 52, $reg, $px
$fTag  = New-Object System.Drawing.Font 'Segoe UI', 30, $reg, $px
$fRole = New-Object System.Drawing.Font 'Segoe UI Semibold', 26, $reg, $px
$white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(242,235,221))
$muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(207,193,168))
$goldB = New-Object System.Drawing.SolidBrush $gold
$g.DrawString($name, $fName, $white, 396, 104)
$g.DrawString($tagline, $fTag, $muted, 398, 178)
$g.DrawString($roles, $fRole, $goldB, 398, 288)

# cover row
$cw = 262; $ch = 122; $gap = 14; $x0 = 80; $y0 = 398
for ($i = 0; $i -lt $covers.Count; $i++) {
  $im = [System.Drawing.Image]::FromFile("$repo\assets\img\games\$($covers[$i]).jpg")
  Draw-Rounded $im ($x0 + $i * ($cw + $gap)) $y0 $cw $ch 10 0; $im.Dispose() }
$g.DrawString($domain, $fRole, $goldB, 80, 556)
$sz = $g.MeasureString($rightText, $fRole); $g.DrawString($rightText, $fRole, $muted, 1120 - $sz.Width + 6, 556)
$g.Dispose()

$jpg = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$ep = New-Object System.Drawing.Imaging.EncoderParameters 1
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), ([long]88)
$out = "$repo\assets\img\og-card.jpg"
$bmp.Save($out, $jpg, $ep); $bmp.Dispose()
"Saved $out ({0} KB)" -f [math]::Round((Get-Item $out).Length / 1KB)
