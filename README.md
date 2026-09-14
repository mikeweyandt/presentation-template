# Marp Presentation Template — The University of Akron

A minimal [Marp](https://marp.app/) presentation template styled with The University
of Akron's brand colors. Edit one Markdown file, then export a **PDF** or **PowerPoint**
with a single `make` command — all inside a reproducible devcontainer.

Two themes ship with it:

| Theme | For | Demo deck |
| --- | --- | --- |
| `akron` | general talks — light, brand-forward | `presentation.md` |
| `akron-cs` | technical talks and lectures — dark, terminal-inspired, with code, pseudocode, diagram and math styling | `lecture.md` |

Pick one per deck in the front matter (`theme: akron-cs`).

```
.
├── presentation.md              # general-purpose deck (uses `akron`)
├── lecture.md                   # CS lecture deck (uses `akron-cs`)
├── themes/
│   ├── akron.css                # light Akron theme
│   ├── akron-cs.css             # dark CS theme
│   └── akron-cs-handout.css     # light print variant of akron-cs
├── Makefile                     # make pdf / pptx / html / handout / watch
└── .devcontainer/               # Node + browser + fonts + Marp CLI
```

## Quick start

1. Open this folder in a devcontainer:
   - **VS Code** → *Dev Containers: Reopen in Container* (needs the
     [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).
   - Or with the CLI: `devcontainer up --workspace-folder .`
2. Edit `presentation.md`.
3. Build:

   ```bash
   make pptx    # → presentation.pptx
   make pdf     # → presentation.pdf
   ```

Run `make` with no target for the full list.

## Make targets

| Command       | Output                                              |
| ------------- | --------------------------------------------------- |
| `make pptx`   | `presentation.pptx` (PowerPoint)                    |
| `make pdf`    | `presentation.pdf`                                  |
| `make html`   | `presentation.html` (standalone deck)               |
| `make all`    | PDF **and** PPTX                                     |
| `make handout`| `*-handout.pdf` — light, print-friendly PDF          |
| `make watch`  | Live preview + hot reload at http://localhost:8080  |
| `make clean`  | Remove generated files                              |

Build a different file with `make pdf SRC=mydeck.md` — e.g. `make pdf SRC=lecture.md`.

## Writing slides

Slides are separated by `---`. Special layouts are applied per-slide with a Marp
class directive:

```markdown
<!-- _class: title -->     # full-blue opening slide
<!-- _class: divider -->   # section break
<!-- _class: end -->       # full-blue closing slide
```

Two even columns (raw HTML is enabled in the build):

```html
<div class="columns">
<div>

Left content

</div>
<div>

Right content

</div>
</div>
```

Live preview while editing is provided by the
[Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)
extension, which the devcontainer installs and points at the Akron theme automatically.

## The `akron-cs` theme

A dark, terminal-inspired theme for technical talks. Set it in the front matter:

```yaml
---
marp: true
theme: akron-cs
paginate: true
size: 16:9
header: '~/cs-501/lecture-04'
footer: 'CS 501 · The University of Akron'
---
```

`header:` and `footer:` are Marp's own directives — the theme styles them as a
terminal path chip and a muted lockup. Clear them on cover slides with
`<!-- _header: '' -->`.

### Slide classes

```markdown
<!-- _class: title -->      opening slide, grid wash + block cursor
<!-- _class: divider -->    section break (an `###` becomes the big numeral)
<!-- _class: end -->        closing slide
<!-- _class: code -->       a slide that is mostly one listing
<!-- _class: terminal -->   a slide that is mostly one transcript
```

### Helpers

All of these are raw HTML, which the build already enables. Keep a blank line
around Markdown nested inside a `<div>` or it will not be parsed.

```html
<div class="columns">…</div>        <!-- two even columns -->
<div class="columns-3">…</div>      <!-- three even columns -->

<div class="code-card" data-file="dijkstra.py">
```python
...
```
</div>

<div class="terminal" data-title="bash">
```console
$ make pdf
```
</div>

<div class="algo" data-name="Dijkstra(G, w, s)" data-cost="O(E log V)">

1. first step
2. second step

</div>

<span class="big-o">O(n log n)</span>

<div class="diagram">
  <div class="node">s</div><span class="arrow"></span><div class="node accent">u</div>
</div>
```

Callout flavors go on a blockquote: `<blockquote class="note">`, `.warn`, `.proof`.

### Code, math and diagrams

- **Syntax highlighting** is automatic (highlight.js, via Marp). Fenced blocks also
  get a small language badge.
- **Terminal transcripts**: use a ```` ```console ```` fence and prefix commands with
  `$ ` — highlight.js tags the prompt and the theme colors it gold, so commands
  separate from output with no extra markup.
- **Math** is MathJax, Marp's default engine. `$inline$` and `$$display$$` both work;
  display equations get a gold rule. A deck can opt into KaTeX with `math: katex`.
- **Diagrams** are plain HTML (`.diagram` / `.node` / `.arrow`) or hand-written inline
  `<svg>`, which inherits the theme palette when placed inside `.diagram` or `.fig`.

### Handouts

The dark theme is used for **every** output, including `.pptx`. For a light,
toner-friendly PDF:

```bash
make handout SRC=lecture.md      # → lecture-handout.pdf
```

This renders with `themes/akron-cs-handout.css`, which imports `akron-cs` and
restates only the color tokens.

> **Why a separate theme rather than `@media print`?** Marp renders PDF with
> `page.pdf()` (print media) *and* renders PPTX by screenshotting slides after an
> explicit `emulateMediaType('print')`. A print media query would therefore lighten
> the PowerPoint too, leaving the dark theme visible only in the live preview.

### Known limitations

- **No per-line highlighting.** Marp has no syntax for it; it needs a markdown-it
  plugin, which this template does not add. Split the listing or use a comment instead.
- **No Mermaid.** Marp does not render ```` ```mermaid ```` fences. Use the `.diagram`
  helpers or inline SVG.
- **A code slide holds roughly 24 lines.** Marp's auto-scaling fits code to the slide
  *width* only — nothing shrinks it vertically, so a longer listing will overflow.
  Split it across two slides.

## Brand colors

The theme uses The University of Akron's official palette
([brand guidelines](https://www.uakron.edu/im/resources/)):

| Name         | Hex       | Use                         |
| ------------ | --------- | --------------------------- |
| Buchtel Blue | `#070C72` | Primary — titles, headers   |
| Akron Gold   | `#9D9362` | Accent — rules, markers     |
| Athletics Navy | `#041E42` | Section dividers          |

Adjust any of these by editing the CSS variables at the top of `themes/akron.css`.

`akron-cs` keeps those three as anchors and adds an extended screen palette for
syntax and diagrams — teal, cyan, violet, magenta, amber, red and green, each
chosen to clear 4.5:1 against the dark ground. Buchtel Blue is too dark to read on
that ground, so it is used structurally (table headers, fills) while a lifted
`--akr-blue-lift` carries anything that has to be legible as text. Every color in
the theme is a CSS variable at the top of `themes/akron-cs.css`.

## Fonts

The base image ships none, so the devcontainer installs them:

| Package | Used by |
| --- | --- |
| `fonts-liberation`, `fonts-dejavu-core` | `akron` |
| `fonts-jetbrains-mono`, `fonts-inter` | `akron-cs` |

All four are `Architecture: all`, so they sit in the shared `apt-get install` list
rather than the architecture-specific branch below.

> **Rebuild required.** If you had a container before `akron-cs` was added, rebuild
> it (*Dev Containers: Rebuild Container*) or the CS theme will silently fall back to
> DejaVu and Liberation.

## How export works

Marp renders slides in a **headless browser** to produce PDF and PPTX. The
devcontainer installs one and points Marp at it via `CHROME_PATH`, running it
with `--no-sandbox` and `--disable-gpu`, so the build works out of the box. The
default `.pptx` embeds each slide as a full-slide image. For an *editable*
PowerPoint, add LibreOffice to the image and run
`marp --pptx --pptx-editable presentation.md`.

### Architecture: arm64 and amd64

The browser is chosen **per architecture** in `.devcontainer/Dockerfile`, because
neither option works everywhere:

| Arch | Browser | Why not the other one |
| --- | --- | --- |
| `arm64` (Apple Silicon) | Debian `chromium` | Google publishes no arm64 Chrome `.deb` for Linux |
| `amd64` | Google Chrome `.deb` | bookworm's chromium `150.0.7871.46` SIGTRAPs at launch in a container |

Both are symlinked to **`/usr/local/bin/marp-browser`**, so `CHROME_PATH`, the
`Makefile` and the VS Code settings never mention a specific browser.

Rules that keep this working:

- **If rendering breaks on one machine, change only that architecture's branch.**
  Swapping the browser for *both* is what caused the earlier fix / revert /
  re-fix loop — each change repaired one machine and broke the other.
- **Never add `--platform`, `runArgs: ["--platform=..."]`, or
  `DOCKER_DEFAULT_PLATFORM`.** That forces emulation, and headless browsers are
  among the workloads most likely to crash rather than merely run slowly.
- The last step of the install layer is a **launch smoke test**. A browser that
  cannot start fails the *build*, on the machine where it is broken, instead of
  dying later on the first `make pdf` — and a rebuild can never silently reuse a
  cached layer holding a broken browser.
