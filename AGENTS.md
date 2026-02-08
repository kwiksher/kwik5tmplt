# AGENTS.md

## Overview
- This repo contains sample books and tooling for Solar2D + Kwik.
- Primary runtime code is Lua under `Solar2D/`.
- There is an embedded TypeScript→Lua toolchain under `Solar2D/lua_modules/nanostores/`.

## Key directories
- `Solar2D/` — main Solar2D project (entrypoint, build settings, app content).
- `Solar2D/App/<BookName>/` — generated book content, components, assets, models.
- `Solar2D/custom/` — custom components used by Kwik (e.g., `custom/components`).
- `UXP/kwik-exporter/` — Photoshop exporter and base-proj artifacts.
- `Scripts/` — helper scripts and documentation.
- `Photoshop/` — sample PSD assets.

## Entrypoints and runtime configuration
- `Solar2D/main.lua` is a main entrypoint for Solar2D (sets `env.book`, `env.goPage`, `env.mode`) and bootstraps Kwik via `kwik.bootstrap`.
- `Solar2D/App/main.lua` is another entrypoint with similar environment setup (development/production modes).
- Runtime settings are in `Solar2D/build.settings` and display config in `Solar2D/config.lua` / `config.dev.lua` / `config.prod.lua`.

## Commands and scripts (observed)
### Run the application (macOS)
```bash
cd Solar2D
"/Applications/Corona/Corona Simulator.app/Contents/MacOS/Corona Simulator" -no-console YES -skin "KwikEditorLandscape" main.lua > ../tmp.log
```
- Keep the command running in the shell (it launches the GUI) and monitor logs separately via `tail -f ../tmp.log` in another terminal if needed.

### Create a book (from `Scripts/readme.md`)
- Windows:
  - `create_book.bat [destination] [book_name] [pages]`
- macOS:
  - `./create_book.command [destination] [book_name] [pages]`
- Example (from docs):
  - `create_book.bat Solar2D MyStory "page1 page2 page3"`

### Solar2D URL scheme (from `Scripts/readme.md`)
- Syntax:
  - `solar2d://open?url=file://<absolute-path-to-main.lua>&skin=<skin-name>`
- Example:
  - `solar2d://open?url=file://C:/Users/ymmtny/Documents/GitHub/kwik5-project-template/Solar2D/main.lua&skin=KwikEditorLandscape`

### Other helper scripts (names only)
- `.command` scripts exist at repo root and in `Scripts/`, `UXP/`, `Solar2D/` (e.g., `create_page.command`, `rename_layer.command`, `delete_pages.command`).
- Behavior and parameters for these are not documented in-tree beyond `Scripts/readme.md`.

## CI / release packaging (from `.github/workflows/*`)
- `release.yaml` packages zip artifacts for `Solar2D/` and `UXP/kwik-exporter` using `TheDoctor0/zip-release`, then publishes a GitHub release.
- `kwik-base-proj.yaml` copies Solar2D and Photoshop folders into `kwik5-project-template` and pushes to `kwiksher/kwik5-project-template`.

## Code organization patterns (observed)
- Page components use a model table and `controller.scene` constructor:
  - Example: `Solar2D/App/snowMan/components/page1/index.lua`.
- Layer definitions live under `Solar2D/App/<Book>/components/<page>/layers/` and are Lua modules with `M` metadata and properties:
  - Example: `Solar2D/App/snowMan/components/page1/layers/mytext_sync.lua`.
- Kwik custom modules are registered in `Solar2D/main.lua` and `Solar2D/App/main.lua` via `kwik.setCustomModule`.

## TypeScript→Lua module
- `Solar2D/lua_modules/package.json` defines build tooling and scripts for TypeScript→Lua conversion.

## Testing
- No repo-wide automated test runner was found.
- To enable unit tests in the app, set `env.unitTest = true` in `Solar2D/main.lua`.

## Gotchas / notes
- Multiple entrypoints (`Solar2D/main.lua` and `Solar2D/App/main.lua`) exist; ensure changes target the right one for your workflow.
- `env.mode` toggles behavior (development/debug/production/behaviorTree) in `Solar2D/main.lua`.
- Some workflows expect `UXP/copy_solar2d.command` and `UXP/copy_photoshop.command` to exist and be executable.
