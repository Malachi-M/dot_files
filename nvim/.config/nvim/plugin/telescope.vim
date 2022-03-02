lua << END
local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        prompt_prefix = '>',
        color_devicons = true,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
      fzf = {
        fuzzy = true,  -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,  -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                                  -- the default case_mode is "smart_case"
      },
        frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('frecency')
END

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
noremap <leader>fh <cmd>Telescope help_tags<cr>
noremap <leader>fr <cmd>Telescope frecency<cr>
