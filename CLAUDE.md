# Domus Instrumentum - Claude Instructions

## Project Overview

Modular Neovim configuration with embedded Antora documentation.

## Structure

```
domus-instrumentum/
├── lua/domus/           # Neovim config (namespace: domus)
│   ├── config/          # Options, keymaps, autocmds
│   ├── core/            # lazy.nvim bootstrap
│   ├── plugins/
│   │   ├── specs/       # Plugin declarations (what to load)
│   │   └── config/      # Plugin configs (how to configure)
│   └── features/        # Custom features (MOTD, etc.)
├── ftplugin/            # Native filetype settings
├── docs/                # Antora documentation
│   ├── antora.yml       # Component descriptor
│   ├── antora-playbook.yml
│   ├── modules/ROOT/    # Content
│   └── supplemental-ui/ # Custom theme overrides
└── Makefile             # Build commands
```

## Key Commands

```bash
# Neovim
v                        # Launch (alias for NVIM_APPNAME=nvim-domus nvim)

# Documentation
make docs                # Build Antora site
make docs-open           # Build and open in browser
make docs-serve          # Build and serve on localhost:8000
```

## Antora Docs Rules

- Use attributes from `docs/antora.yml` - never hardcode values
- CSS in `docs/supplemental-ui/css/extra.css` - keep external, not inline
- Partials in `docs/supplemental-ui/partials/` override default UI
- Dark theme uses Catppuccin Mocha colors

## Plugin Architecture

- **Specs** (`plugins/specs/*.lua`): Lazy.nvim plugin declarations
- **Configs** (`plugins/config/*.lua`): Setup functions called by specs
- Separation allows clean organization and lazy loading

## Primary Colorscheme

Catppuccin Mocha with custom refinements in `plugins/config/colorscheme.lua`
