# WindUI (self-hosted copy)

Self-hosted, editable copy of [Footagesus/WindUI](https://github.com/Footagesus/WindUI) v1.6.66 (MIT, see `LICENSE`).
Everything the library needs lives in this repo, including the icon packs, so it does not depend on the upstream repo at runtime.

## Use it

```luau
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/D3f4ultscript/WindUI/main/dist/main.lua"))()
```

Full demo of every element and window feature:

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/D3f4ultscript/WindUI/main/Example.lua"))()
```

## Layout

| Path | What it is |
| --- | --- |
| `src/` | Library source (edit here) |
| `dist/main.lua` | Built single file that scripts load |
| `Icons/` | Icon packs (lucide, solar, craft, geist, sfsymbols, gravity) and loader |
| `Example.lua` | Example script using every element |
| `build/` | Build config (DarkLua) and header |
| `tests/` | Small test scripts |
| `.github/workflows/build.yml` | Rebuilds `dist/main.lua` on every push to `main` |

## Change it and rebuild

1. Edit files in `src/`.
2. Install the tools once: `aftman install` (needs [Aftman](https://github.com/LPGhatguy/aftman)), plus Node.js 18.
3. Run `npm install` then `npm run build`. This writes `dist/main.lua`.
4. Push. The workflow also rebuilds `dist/main.lua` for you.

Live development against a running executor: `npm run live-build` (serves on port 8642).

## Moving to your own repo name

Icon links point to `D3f4ultscript/WindUI` in `src/modules/Creator.lua`, `src/server/Icons.server.lua`, `Icons/Main-v2.lua`, `Icons/Main.lua` and `dist/main.lua`. If you rename the repo or user, replace `D3f4ultscript/WindUI` in these files, then rebuild.

## Notes

- The `Video` element is disabled upstream, so it is not in the example.
- Credit: WindUI by Footagesus. Icons by Lucide, Craft, Geist, Solar and SF Symbols (see `Icons/README.md`).
