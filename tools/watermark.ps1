<#
  watermark.ps1  —  centre-watermark every clean source with "re•flect".

  HOW IT WORKS
    Put clean originals under  assets/_src/  mirroring the live tree, e.g.
        assets/_src/img/case/foo.png     ->  assets/img/case/foo.jpg   (web-sized, watermarked)
        assets/_src/img/team/jane.jpg    ->  assets/img/team/jane.jpg
        assets/_src/video/clip.mov       ->  assets/video/clip.mp4     (1080p, watermarked)
    Then run:   pwsh tools/watermark.ps1        (or:  powershell -File tools\watermark.ps1)

    Images  -> .jpg, max 1600px wide, quality 4.
    Videos  -> .mp4, 1080p, H.264, faststart, muted.
    Idempotent: output is always rebuilt from _src, so re-running never double-marks.
    Pass a single file to process just that one:   tools/watermark.ps1 -Path assets\_src\img\team\jane.jpg
#>
param([string]$Path)
$ErrorActionPreference = 'Continue'   # ffmpeg writes progress to stderr; don't treat it as fatal
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root
[Environment]::CurrentDirectory = $Root   # native procs (ffmpeg) use THIS, not Set-Location, so relative wm.txt resolves

# locate ffmpeg (PATH first, then the winget install location)
$ff = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source
if (-not $ff) { $ff = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0-full_build\bin\ffmpeg.exe" }
if (-not (Test-Path $ff)) { throw "ffmpeg not found. Install it with:  winget install Gyan.FFmpeg" }

# temp font + text file (relative names avoid Windows drive-colon escaping inside the filter)
Copy-Item "C:\Windows\Fonts\arial.ttf" "$Root\wmfont.ttf" -Force
# build "re•flect" from the bullet's code point (avoids PS 5.1 source-encoding issues) and
# write UTF-8 WITHOUT BOM so ffmpeg's drawtext decodes it correctly
# plain ASCII watermark — no special chars, so no encoding/mojibake issues
$wmText = "re-flect @ETH Zurich"
[IO.File]::WriteAllText("$Root\wm.txt", $wmText, (New-Object System.Text.ASCIIEncoding))

# small, light, semi-transparent, faint shadow for legibility on bright images
$base  = "drawtext=fontfile=wmfont.ttf:textfile=wm.txt:fontsize=h/44:fontcolor=white@0.55:shadowcolor=black@0.30:shadowx=1:shadowy=1:x=(w-tw)/2"
$dtImg = "${base}:y=h-th-18"    # images  -> bottom centre  (braces: avoid $base:y being read as a scoped var)
$dtVid = "${base}:y=(h-th)/2"   # videos  -> centre

$srcRoot = Join-Path $Root 'assets\_src'
if (-not (Test-Path $srcRoot)) { throw "No assets\_src folder. Put clean originals there (mirror of assets/)." }

$items = if ($Path) { ,(Get-Item $Path) } else { Get-ChildItem $srcRoot -Recurse -File }
foreach ($f in $items) {
  $ext = $f.Extension.ToLower()
  if ($ext -in '.svg', '.gitkeep', '') { continue }
  $rel = $f.FullName.Substring($srcRoot.Length).TrimStart('\')
  $isVideo = $ext -in '.mp4', '.mov', '.m4v', '.webm', '.avi'
  if ($isVideo) {
    $out = Join-Path (Join-Path $Root 'assets') ([IO.Path]::ChangeExtension($rel, '.mp4'))
    New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null
    & $ff @('-y','-i',$f.FullName,'-vf',"scale=-2:1080,fps=30,$dtVid",'-c:v','libx264','-profile:v','high','-pix_fmt','yuv420p','-crf','28','-preset','medium','-movflags','+faststart','-an',$out) 2>$null
  } else {
    $out = Join-Path (Join-Path $Root 'assets') ([IO.Path]::ChangeExtension($rel, '.jpg'))
    New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null
    & $ff @('-y','-i',$f.FullName,'-vf',"scale=min(1600\,iw):-2,$dtImg",'-q:v','4',$out) 2>$null
  }
  if ($LASTEXITCODE -eq 0 -and (Test-Path $out)) { "  [ok] $rel" } else { "  [FAILED ffmpeg=$LASTEXITCODE] $rel" }
}

Remove-Item "$Root\wmfont.ttf", "$Root\wm.txt" -Force -ErrorAction SilentlyContinue
"done."
