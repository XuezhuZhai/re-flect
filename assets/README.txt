re•flect — asset placeholders
=============================
Every image/video slot on the page already has a labelled placeholder so nothing
looks broken. Replace a placeholder by dropping a real file with the SAME name
(or the .jpg/.mp4 the placeholder tells you to use).

assets/
  video/
    rural.mp4      LEFT hero video  — Glenshee / Scotland screen recording (5-15s, muted, ~1080p, H.264)
    urban.mp4      RIGHT hero video — Zurich street screen recording
  img/
    hero/  rural.svg  urban.svg      hero posters/stills (used until the .mp4 loads; can also drop rural.jpg / urban.jpg)
    case/  rural.svg  urban.svg      "two extremes" split cells
    tool/  map.svg    shading.svg    the two tool-feature screenshots
    team/  fritz jaboury xuezhu peter matthias anne (.svg)   member portraits
    brand/ favicon.svg  og-image.svg  site icon + social-share image (export og to .png before publishing)

Notes
- <img> slots accept .svg/.jpg/.png/.webp — if you add e.g. team/xuezhu.jpg, also update the
  src in index.html (or just overwrite xuezhu.svg with your image kept as .svg is not needed —
  easiest: keep the filename, change the extension in index.html).
- Hero videos: no video yet? the poster image + a themed gradient show automatically.
- Recommended sizes: hero video 1920x1080 · case/tool images ~1600x1200 · team ~640x500 · og 1200x630.
