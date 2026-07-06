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

Marp renders slides in a headless **Chromium** to produce PDF and PPTX. The
devcontainer installs Chromium and points Marp at it via `CHROME_PATH`; Marp
detects the container and runs Chromium with `--no-sandbox` automatically, so the
build works out of the box. The default `.pptx` embeds each slide as a full-slide
image. For an *editable* PowerPoint, add LibreOffice to the image and run
`marp --pptx --pptx-editable presentation.md`.
