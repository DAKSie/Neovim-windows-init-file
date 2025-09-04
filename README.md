# Unified Neovim Config (init.vim) - Java / C# / WebDev

This repository contains a **unified Neovim configuration** designed for
**Java, C#, and Web Development (JavaScript, TypeScript, HTML, CSS)**.\
It includes support for **LSP, autocompletion, snippets, Treesitter
syntax highlighting, debugging, formatting, file navigation, themes, and
transparency**.

------------------------------------------------------------------------

## ✨ Features

-   **General Settings**
    -   Relative line numbers, indentation, clipboard integration, mouse
        support.
    -   Leader key set to `<Space>`.
-   **Plugins Managed by
    [vim-plug](https://github.com/junegunn/vim-plug)**
    -   **UI & Themes**: Gruvbox, Tokyonight, Everforest, Lualine,
        Icons.
    -   **Navigation**: Nvim-tree, Telescope.
    -   **Syntax**: Treesitter (with selective disabling for C#).
    -   **Completion**: nvim-cmp + LuaSnip + LSPkind.
    -   **Autopairs**: Auto-pairs & nvim-autopairs.
    -   **LSP**: Mason, Mason-LSPconfig, nvim-lspconfig.
    -   **Debugging**: nvim-dap, dap-ui, mason-nvim-dap (with netcoredbg
        for C#).
    -   **Formatting**: null-ls, vim-prettier (with auto-format on
        save).
-   **Languages Supported**
    -   Java (via `jdtls`).
    -   C# (via `OmniSharp`).
    -   JavaScript/TypeScript (`ts_ls`).
    -   HTML, CSS.
-   **UI Enhancements**
    -   Transparent background support.
    -   Statusline with `lualine`.

------------------------------------------------------------------------

## 🚀 Installation

1.  Install **Neovim** (≥ 0.8 recommended).

2.  Install [vim-plug](https://github.com/junegunn/vim-plug):

    ``` sh
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```

3.  Copy `init.vim` to your Neovim config folder:

    ``` sh
    mkdir -p ~/.config/nvim
    cp init.vim ~/.config/nvim/
    ```

4.  Open Neovim and install plugins:

    ``` vim
    :PlugInstall
    ```

------------------------------------------------------------------------

## ⚙️ Language Server Setup

### Java

-   Uses `jdtls`.\
-   Installed automatically with Mason.

### C

-   Requires
    [OmniSharp](https://github.com/OmniSharp/omnisharp-roslyn).\
-   Path is set to `C:/tools/omnisharp-win-x64/OmniSharp.exe`.\
-   Make sure OmniSharp is installed there or adjust the path.

### Web Development

-   TypeScript / JavaScript: `ts_ls` (via Mason).\
-   HTML & CSS: Installed via Mason.

------------------------------------------------------------------------

## 🛠️ Keybindings

  Shortcut                 Action
  ------------------------ ----------------------------------
  `<Leader>s`              Save file
  `<Leader>e` / `Ctrl+n`   Toggle file explorer (nvim-tree)
  `Ctrl+p`                 Find files (Telescope)
  `Ctrl+f`                 Live grep (Telescope)
  `gd`                     Go to definition (LSP)
  `K`                      Hover docs (LSP)
  `<Leader>rn`             Rename (LSP)
  `<Leader>ca`             Code actions (LSP)
  `gr`                     Find references (LSP)
  `<Leader>f`              Format file (LSP)

------------------------------------------------------------------------

## 🎨 Themes

Available themes: - **Gruvbox** - **Tokyonight** - **Everforest**
(default)

To switch themes, edit this section in `init.vim`:

``` vim
"colorscheme gruvbox
"colorscheme tokyonight
colorscheme everforest
```

------------------------------------------------------------------------

## 🐞 Debugging

-   Uses `nvim-dap` and `nvim-dap-ui`.\

-   Configured for **.NET debugging** with `netcoredbg`.\

-   Install debugger via Mason:

    ``` vim
    :MasonInstall netcoredbg
    ```

------------------------------------------------------------------------

## 🖼️ Transparency

This config makes Neovim use your **terminal background** instead of
theme background colors.

------------------------------------------------------------------------

## 📦 Dependencies

-   [Neovim](https://neovim.io/) (≥ 0.8)
-   [vim-plug](https://github.com/junegunn/vim-plug)
-   Node.js (for Prettier)
-   Java JDK (for `jdtls`)
-   .NET SDK (for OmniSharp + debugging)
-   C compiler (for Treesitter parsers)

------------------------------------------------------------------------

## 🔧 Recommended Setup

-   Terminal with **true colors** support.\

-   Fonts with **Nerd Fonts** icons for `nvim-web-devicons`.\

-   Install Treesitter parsers:

    ``` vim
    :TSInstall javascript typescript html css lua json c_sharp
    ```

------------------------------------------------------------------------

## 📄 License

This configuration is free to use and modify.\
Enjoy hacking with Neovim 🚀

