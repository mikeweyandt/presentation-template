# Marp Presentation Template — The University of Akron

A minimal [Marp](https://marp.app/) presentation template styled with The University
of Akron's brand colors. Edit one Markdown file, then export a **PDF** or **PowerPoint**
with a single `make` command — all inside a reproducible devcontainer.

```
.
├── presentation.md          # your deck (title + 6 content slides + close)
├── themes/akron.css         # the Akron theme (colors, layouts)
├── Makefile                 # make pdf / make pptx / make html / make watch
└── .devcontainer/           # Node + Chromium + Marp CLI, ready to go
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
| `make watch`  | Live preview + hot reload at http://localhost:8080  |
| `make clean`  | Remove generated files                              |

Build a different file with `make pdf SRC=mydeck.md`.

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

## Brand colors

The theme uses The University of Akron's official palette
([brand guidelines](https://www.uakron.edu/im/resources/)):

| Name         | Hex       | Use                         |
| ------------ | --------- | --------------------------- |
| Buchtel Blue | `#070C72` | Primary — titles, headers   |
| Akron Gold   | `#9D9362` | Accent — rules, markers     |
| Athletics Navy | `#041E42` | Section dividers          |

Adjust any of these by editing the CSS variables at the top of `themes/akron.css`.

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
