# dot-rename.nvim

A Neovim plugin for renaming occurrences of a word with a repeatable, dot-command-friendly workflow.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'zmunk/dot-rename.nvim',
  opts = {
    mappings = {
      visual = "<leader>r",  -- rename visual selection as word
      normal = "<leader>rw", -- rename word
    }
  },
}
```

## Usage

### Rename selected word

1. Visually select a word (`viw`)
2. Type the mapping you set for visual mode (e.g. `<leader>r`)
3. Change/modify the word in the command line (e.g. `:RenameTo my_updated_var_name`)
4. Press enter to change the current occurrence
5. Press n to navigate to the next occurrence
6. Press `.` to apply the rename to this occurrence
7. Repeat `n.` as many times as desired

### Rename word under the cursor

1. Place the cursor is on the word you'd like to rename
2. Type the mapping you set for normal mode (e.g. `<leader>rw`)
3. Change/modify the word in the command line (e.g. `:RenameTo my_updated_var_name`)
4. Press enter to change the current occurrence
5. Press n to navigate to the next occurrence
6. Press `.` to apply the rename to this occurrence
7. Repeat `n.` as many times as desired

## Configuration

### Mappings

The plugin requires you to specify the desired mappings.
Set the mappings to whatever you want. For example:

```lua
require('dot-rename').setup({
  mappings = {
    visual = "<leader>r",  -- rename visual selection as word
    normal = "<leader>rw", -- rename word
  }
})
```

## Tips

- **Skip occurrences**: Press `n` to skip and move to the next match
- **Go backwards**: Use `N` to search in reverse
- **Undo**: Press `u` to undo the last change
- **Search highlighting**: The plugin automatically enables search highlighting (`hlsearch`)

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.
