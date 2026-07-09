# dot-rename.nvim

A small Neovim plugin for pattern-based renames with `cgn` and `.` repeat.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'zmunk/dot-rename.nvim',
  opts = {
    mappings = {
      visual = '<leader>r',
      normal = '<leader>rw',
    },
  },
}
```

## What changed

The plugin now starts renames with `:RenamePattern` / `:rename` and applies the
first replacement immediately with `cgn`.

- no separate resume mapping
- works from a pattern/replacement pair
- uses whatever delimiter you put first

## Usage

### Command

You can start a rename in any of these forms:

```vim
:RenamePattern /from/to
:rename /from/to
:rename/from/to
```

Rules:

- the first character is the delimiter
- `from` is a Vim search pattern
- `to` is inserted as plain replacement text
- escape the delimiter inside either side, e.g. `:rename /foo\/bar/baz/`

If the pattern is found, the plugin:

1. stores it in the search register
2. enables search highlighting
3. runs `cgn` with the replacement on the current match
4. lets you continue with `n` + `.`

### Rename the word under the cursor

With the normal mapping:

1. place the cursor on a word
2. trigger your mapping (for example `<leader>rw`)
3. edit the command line
4. press `<CR>`
5. use `n` and `.` to keep renaming matches

The mapping pre-fills this command shape:

```vim
:RenamePattern/\<word\>/word
```

So normal-mode rename matches whole words only.

### Rename a visual selection

With the visual mapping:

1. select text
2. trigger your mapping (for example `<leader>r`)
3. edit the command line
4. press `<CR>`
5. use `n` and `.` to keep renaming matches

The visual mapping pre-fills the selected text as both pattern and replacement,
so you can quickly change the replacement or both sides.

## Configuration

```lua
require('dot-rename').setup({
  mappings = {
    visual = '<leader>r',
    normal = '<leader>rw',
  },
})
```

`mappings.visual` and `mappings.normal` are optional.

## Tips

- `n` jumps to the next match
- `N` jumps to the previous match
- `.` repeats the last rename on the current match
- `:noh` clears highlight when you are done

## License

MIT. See [LICENSE](LICENSE).
