-- ══════════════════════════════════════════════
-- Rust — rustaceanvim + crates.nvim + neotest
-- ══════════════════════════════════════════════

return {
	-- ── rustaceanvim ─────────────────────────────
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				tools = {
					float_win_config = {
						border = "rounded",
						max_width = 100,
						auto_focus = true,
					},
					on_initialized = function()
						vim.api.nvim_create_autocmd({ "LspAttach" }, {
							callback = function(args)
								vim.lsp.codelens.enable(true, { bufnr = args.buf })
							end,
						})
					end,
				},

				server = {
					on_attach = function(client, bufnr)
						if vim.lsp.inlay_hint then
							vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						end
						if client.server_capabilities.documentSymbolProvider then
							require("nvim-navic").attach(client, bufnr)
						end
						vim.lsp.codelens.enable(true, { bufnr = bufnr })
					end,

					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							check = {
								command = "clippy",
								extraArgs = {
									"--",
									"-W",
									"clippy::pedantic",
									"-W",
									"clippy::nursery",
									"-A",
									"clippy::module_name_repetitions",
								},
								allFeatures = true,
							},
							diagnostics = {
								enable = true,
								experimental = { enable = true },
								styleLints = { enable = true },
							},
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 10 },
								closureReturnTypeHints = { enable = "with_block" },
								lifetimeElisionHints = {
									enable = "skip_trivial",
									useParameterNames = true,
								},
								maxLength = 35,
								parameterHints = { enable = true },
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
							lens = {
								enable = true,
								debug = { enable = true },
								implementations = { enable = true },
								run = { enable = true },
								test = { enable = true },
							},
							completion = {
								addCallArgumentSnippets = true,
								addCallParenthesis = true,
								postfix = { enable = true },
								autoimport = { enable = true },
								callable = { snippets = "fill_arguments" },
							},
							imports = {
								granularity = { group = "module" },
								prefix = "self",
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
							semanticHighlighting = { strings = { enable = "always" } },
							rustfmt = { extraArgs = { "+nightly" } },
							files = {
								excludeDirs = { ".direnv", ".git", "node_modules", "target" },
							},
						},
					},
				},

				dap = {
					adapter = (function()
						local ok, mason_registry = pcall(require, "mason-registry")
						if ok and mason_registry.is_installed("codelldb") then
							local codelldb = mason_registry.get_package("codelldb")
							local ext_path = codelldb:get_install_path() .. "/extension/"
							return require("rustaceanvim.config").get_codelldb_adapter(
								ext_path .. "adapter/codelldb",
								ext_path .. "lldb/lib/liblldb.so"
							)
						end
						return {
							type = "server",
							port = "${port}",
							executable = {
								command = "codelldb",
								args = { "--port", "${port}" },
							},
						}
					end)(),
				},
			}
		end,
	},

	-- ── crates.nvim ──────────────────────────────
	-- null_ls integration removed; uses only nvim-cmp source
	{
		"saecki/crates.nvim",
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				cmp = { enabled = true },
				-- coq disabled (not used)
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			popup = {
				border = "rounded",
				show_version_date = true,
				show_dependency_version = true,
				max_height = 30,
				min_width = 20,
				padding = 1,
			},
			notification_title = "crates.nvim",

			thousands_separator = ".",
			date_format = "%Y-%m-%d",
		},
	},

	-- ── neotest + Rust adapter ────────────────────
	{
		"nvim-neotest/neotest",
		event = "BufReadPost *.rs",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"mrcjkb/rustaceanvim",
		},
		opts = function()
			return {
				adapters = { require("rustaceanvim.neotest") },
				summary = {
					open = "botright vsplit | vertical resize 40",
				},
				output = { open_on_run = "short" },
				output_panel = { open = "botright split | resize 15" },
				quickfix = { open = false },
				status = { enabled = true, virtual_text = true, signs = true },
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "",
					running = "",
					skipped = "",
					unknown = "",
				},
				floating = { border = "rounded", max_height = 0.85, max_width = 0.85 },
			}
		end,
	},
}
