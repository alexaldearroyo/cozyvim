return { -- 🌈 THEME
{
    "ellisonleao/gruvbox.nvim",
    priority = 1000
}, {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        local theme = "gruvbox"

        if vim.fn.has("mac") == 1 then
            local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
            local result = handle:read("*a")
            handle:close()
            if result:match("Dark") then
                vim.o.background = "dark"
                vim.g.tokyonight_style = "moon"
                theme = "tokyonight"
            else
                vim.o.background = "light"
                theme = "gruvbox"
            end
        end

        vim.cmd.colorscheme(theme)
    end
}, -- 📁 EXPLORER
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    config = function()
        require("neo-tree").setup({
            window = {
                position = "left",
                width = 25,
                mappings = {
                    ["l"] = function(state)
                        local node = state.tree:get_node()
                        if node:has_children() then
                            require("neo-tree.ui.renderer").toggle_node(state, node)
                        else
                            require("neo-tree.sources.filesystem.commands").open(state)
                        end
                    end,
                    ["h"] = "close_node", -- pliega la carpeta
                    ["P"] = {
                        "toggle_preview",
                        config = {
                            use_float = false,
                            use_image_nvim = false
                        }
                    }, -- Vista previa (normal)
                    ["O"] = function(state)
                        local node = state.tree:get_node()
                        if node.type == "file" then
                            vim.cmd("tabnew " .. node.path)
                        end
                    end -- abrir en nueva pestaña
                }
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false
                },
                follow_current_file = {
                    enabled = true -- Activar para seguir el archivo actual
                },
                use_libuv_file_watcher = true, -- Detecta cambios en el sistema de archivos
                hijack_netrw_behavior = "open_current" -- Toma control de Netrw
            }
        })

        -- Asignación de tecla para abrir NeoTree
        vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
            desc = "Alternar NeoTree"
        })

        -- Forzar la actualización de NeoTree cada vez que se abre un archivo
        -- vim.api.nvim_create_autocmd("BufRead", {
        --     pattern = "*",
        --     callback = function()
        --         -- Forzar que NeoTree se actualice
        --         vim.cmd("Neotree refresh")
        --     end
        -- })

    end
}, -- ⌨️ WHICH-KEY
{
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup()
    end,
    keys = {{
        "<leader>e",
        "<cmd>Neotree toggle<CR>",
        desc = "Explorer"
    }}
}, -- ⚡ AUTOCOMPLETION
{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip",
                    "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"},
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({
                    select = true
                }),
                ["<C-Space>"] = cmp.mapping.complete()
            }),
            sources = cmp.config.sources({{
                name = "nvim_lsp"
            }, {
                name = "luasnip"
            }, {
                name = "buffer"
            }, {
                name = "path"
            }})
        })
    end
}, -- ⚙️ LSP BASE
{
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")

        -- Languages
        lspconfig.lua_ls.setup({})
        lspconfig.ts_ls.setup({})
        lspconfig.pyright.setup({})
        lspconfig.solargraph.setup({})
        lspconfig.jsonls.setup({})
        lspconfig.cssls.setup({})
        lspconfig.sourcekit.setup({})
    end
}, -- Mason + LSPs autoinstall
{
    "williamboman/mason.nvim",
    config = true
}, {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {"williamboman/mason.nvim"},
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", -- "tsserver",
            "pyright", "solargraph", "jsonls", "cssls"}
        })

        local lspconfig = require("lspconfig")
        local mason_lsp = require("mason-lspconfig")

        mason_lsp.setup_handlers({function(server_name)
            lspconfig[server_name].setup({})
        end})
    end
}, -- conform
{
    "stevearc/conform.nvim",
    opts = {
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 1500,
            notify = true
        },
        formatters_by_ft = {
            javascript = {"prettier"},
            typescript = {"prettier"},
            json = {"prettier"},
            css = {"prettier"},
            lua = {"stylua"},
            python = {"black"},
            ruby = {"rubocop"}
        }
    }
}, -- 🎨 BOTTOM LINE
{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local function show_whichkey_hint()
            if package.loaded["which-key"] then
                return "?: press ␣"
            end
            return ""
        end
        vim.opt.laststatus = 3
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = ""
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch"},
                lualine_c = {"filename", show_whichkey_hint},
                lualine_x = {"encoding", "filetype"},
                lualine_y = {"diagnostics", "progress"},
                lualine_z = {"location"}
            }
        })
    end
}, -- 🔭 TELESCOPE
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                layout_config = {
                    prompt_position = "top"
                },
                sorting_strategy = "ascending",
                winblend = 10
            }
        })

        -- Keymaps
        local keymap = vim.keymap.set
        keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
            desc = "Find Files"
        })
        keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
            desc = "Live Grep"
        })
        keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
            desc = "Buffers"
        })
        keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
            desc = "Help Tags"
        })
    end
}, -- ✍️ SYNTAX HIGHLIGHTING
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "vim", "vimdoc", "javascript", "typescript", "python", "ruby", "json", "css",
                                "html", "tsx", "bash", "markdown"},
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },
            auto_install = true,
            fold = {
                enable = true
            }
        })
    end
}, -- 📝 SPECIAL COMMENTS
{
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end,
    keys = {{
        "gc",
        mode = {"n", "v"},
        desc = "Toggle comment"
    }, {
        "gcc",
        mode = "n",
        desc = "Toggle line comment"
    }}
}, {
    "nvim-tree/nvim-web-devicons",
    lazy = true
}, {
    "folke/todo-comments.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require("todo-comments").setup()
    end,
    keys = {{
        "<leader>td",
        "<cmd>TodoTelescope<CR>",
        desc = "Search TODOs (Telescope)"
    }, {
        "<leader>tx",
        "<cmd>TodoTrouble<CR>",
        desc = "Search TODOs (Trouble)"
    }}
}, {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        vim.opt.termguicolors = true
        require("bufferline").setup()
        -- Navegación con tab
        vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {
            desc = "Next buffer"
        })
        vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {
            desc = "Prev buffer"
        })
    end
}, -- 🩺 DIAGNOSTICS
{
    "folke/trouble.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    opts = {},
    keys = {{
        "<leader>rx",
        function()
            require("trouble").toggle("diagnostics")
        end,
        desc = "Toggle Trouble"
    }, {
        "<leader>rw",
        function()
            require("trouble").toggle("diagnostics")
        end,
        desc = "Diagnostics (all)"
    }, {
        "<leader>rl",
        function()
            require("trouble").toggle("loclist")
        end,
        desc = "Location List"
    }, {
        "<leader>rq",
        function()
            require("trouble").toggle("quickfix")
        end,
        desc = "Quickfix List"
    }, {
        "<leader>rt",
        function()
            require("trouble").toggle("todo")
        end,
        desc = "TODOs"
    }}
}, {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end
}, -- 🔔 NOTIFICATIONS
{
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
    config = function()
        require("noice").setup({
            lsp = {
                progress = {
                    enabled = true
                },
                signature = {
                    enabled = true
                },
                hover = {
                    enabled = true
                }
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "50%", -- Centra verticalmente
                        col = "50%" -- Centra horizontalmente
                    },
                    size = {
                        width = 60, -- Ancho de la ventana emergente
                        height = "auto" -- Altura automática según el contenido
                    }
                }
            }
        })

        vim.notify = require("notify")
        require("notify").setup({
            stages = "fade_in_slide_out",
            timeout = 3000,
            background_colour = "#000000",
            render = "default"
        })
    end
}, -- 🏠 DASHBOARD
{
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local user = os.getenv("USER") or "user"

        require("dashboard").setup({
            vim.api.nvim_set_hl(0, "DashboardHeader", {
                fg = "#FAB387",
                bold = true
            }),
            vim.api.nvim_set_hl(0, "DashboardFooter", {
                fg = "#FAB387",
                bold = true
            }),
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dashboard",
                callback = function()
                    vim.cmd("IBLDisable")
                end
            }),

            theme = "hyper",
            shortcut_type = "number",
            config = {
                header = {"  ~ C o z y ~", "",
                          "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                          "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                          "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                          "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                          "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                          "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                          "", ""},
                shortcut = {{
                    icon = " ",
                    desc = "New file ",
                    group = "@property",
                    action = "ene | startinsert",
                    key = "n"
                }, {
                    icon = "󰱼 ",
                    desc = "Find files ",
                    group = "@property",
                    action = "Telescope find_files",
                    key = "f"
                }, {
                    icon = " ",
                    desc = "Update plugins ",
                    group = "@property",
                    action = "Lazy update",
                    key = "u"
                }, {
                    icon = "󰗼 ",
                    desc = "Quit ",
                    group = "@property",
                    action = "q",
                    key = "q"
                }},
                project = {
                    enable = true,
                    limit = 5,
                    icon = " ",
                    label = "Recent projects",
                    action = function(path)
                        vim.cmd('lcd ' .. path)
                        vim.cmd("tabenew")

                        require('neo-tree.command').execute({
                            source = "filesystem",
                            position = "left",
                            action = "focus",
                            dir = path
                        })
                        require('telescope.builtin').find_files({
                            cwd = path
                        })

                    end
                },
                mru = {
                    limit = 5,
                    icon = " ",
                    label = "Recent files",
                    cwd_only = false
                },
                packages = {
                    enable = false
                }, -- Deactivate plugins info
                week_header = {
                    enable = false
                },
                footer = {"", "", "Sharp tools make good work."}
            }
        })
    end
}, {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = {
            char = "│"
        },
        scope = {
            enabled = true
        }
    }
}, -- 🚀 NAVIGATION
{
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {{
        "s",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump()
        end,
        desc = "Flash"
    }, {
        "S",
        mode = {"n", "x", "o"},
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter"
    }, {
        "r",
        mode = "o",
        function()
            require("flash").remote()
        end,
        desc = "Remote Flash"
    }, {
        "R",
        mode = {"o", "x"},
        function()
            require("flash").treesitter_search()
        end,
        desc = "Treesitter Search"
    }, {
        "<c-s>",
        mode = {"c"},
        function()
            require("flash").toggle()
        end,
        desc = "Toggle Flash Search"
    }}
}, -- 🖥️ GRAPHICS
{
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        scroll = {}
    }
}}
