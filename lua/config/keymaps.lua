-- ══════════════════════════════════════════════
-- Keymaps
-- ══════════════════════════════════════════════

local k = vim.keymap.set
local function d(desc)
	return { desc = desc, noremap = true, silent = true }
end

-- ── Basics ───────────────────────────────────
k("n", "<Esc>", "<cmd>nohlsearch<cr>", d("Clear search highlight"))
k("n", "x", '"_x', d("Delete char (no yank)"))
k("n", "U", "<C-r>", d("Redo"))
k({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", d("Save file"))
k("n", "<leader>q", "<cmd>q<cr>", d("Quit"))
k("n", "<leader>Q", "<cmd>qa!<cr>", d("Force quit all"))

-- ── Move lines (Alt+j/k) ─────────────────────
k("n", "<A-j>", "<cmd>m .+1<cr>==", d("Move line down"))
k("n", "<A-k>", "<cmd>m .-2<cr>==", d("Move line up"))
k("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", d("Move line down"))
k("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", d("Move line up"))
k("v", "<A-j>", ":m '>+1<cr>gv=gv", d("Move selection down"))
k("v", "<A-k>", ":m '<-2<cr>gv=gv", d("Move selection up"))

-- ── Window navigation ─────────────────────────
k("n", "<C-h>", "<C-w>h", d("Focus left"))
k("n", "<C-j>", "<C-w>j", d("Focus down"))
k("n", "<C-k>", "<C-w>k", d("Focus up"))
k("n", "<C-l>", "<C-w>l", d("Focus right"))

-- ── Resize splits ────────────────────────────
k("n", "<C-Up>", "<cmd>resize +2<cr>", d("Increase height"))
k("n", "<C-Down>", "<cmd>resize -2<cr>", d("Decrease height"))
k("n", "<C-Left>", "<cmd>vertical resize -2<cr>", d("Decrease width"))
k("n", "<C-Right>", "<cmd>vertical resize +2<cr>", d("Increase width"))

-- ── Buffers ──────────────────────────────────
k("n", "<S-l>", "<cmd>bnext<cr>", d("Next buffer"))
k("n", "<S-h>", "<cmd>bprevious<cr>", d("Prev buffer"))
k("n", "<leader>bd", "<cmd>bdelete<cr>", d("Delete buffer"))
k(
	"n",
	"<leader>bo",
	"<cmd>%bdelete|edit#|bdelete#<cr>",
	d("Delete other buffers")
)

-- ── Tabs ─────────────────────────────────────
k("n", "<leader><tab>n", "<cmd>tabnew<cr>", d("New tab"))
k("n", "<leader><tab>c", "<cmd>tabclose<cr>", d("Close tab"))
k("n", "<leader><tab>]", "<cmd>tabnext<cr>", d("Next tab"))
k("n", "<leader><tab>[", "<cmd>tabprevious<cr>", d("Prev tab"))

-- ── Indenting ────────────────────────────────
k("v", "<", "<gv")
k("v", ">", ">gv")

-- ── Telescope ────────────────────────────────
k("n", "<leader>ff", "<cmd>Telescope find_files<cr>", d("Find files"))
k("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", d("Live grep"))
k("n", "<leader>fb", "<cmd>Telescope buffers<cr>", d("Buffers"))
k("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", d("Help tags"))
k("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", d("Recent files"))
k(
	"n",
	"<leader>fs",
	"<cmd>Telescope lsp_document_symbols<cr>",
	d("Document symbols")
)
k(
	"n",
	"<leader>fS",
	"<cmd>Telescope lsp_workspace_symbols<cr>",
	d("Workspace symbols")
)
k("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", d("Diagnostics"))
k("n", "<leader>fc", "<cmd>Telescope commands<cr>", d("Commands"))
k("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", d("Keymaps"))
k("n", "<C-p>", "<cmd>Telescope find_files<cr>", d("Find files"))

-- ── LSP ──────────────────────────────────────
k("n", "gd", "<cmd>Telescope lsp_definitions<cr>", d("Go to definition"))
k("n", "gD", vim.lsp.buf.declaration, d("Go to declaration"))
k("n", "gr", "<cmd>Telescope lsp_references<cr>", d("References"))
k("n", "gi", "<cmd>Telescope lsp_implementations<cr>", d("Implementations"))
k("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", d("Type definition"))
k("n", "K", vim.lsp.buf.hover, d("Hover docs"))
k("n", "<leader>ca", vim.lsp.buf.code_action, d("Code action"))
k("v", "<leader>ca", vim.lsp.buf.code_action, d("Code action (range)"))
k("n", "<leader>rn", vim.lsp.buf.rename, d("Rename symbol"))
k("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, d("Format"))
k("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, d("Prev diagnostic"))

k("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, d("Next diagnostic"))
k("n", "<leader>e", vim.diagnostic.open_float, d("Diagnostic float"))

-- ── Rust ─────────────────────────────────────
k("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", d("Rust runnables"))
k("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", d("Rust debuggables"))
k("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", d("Expand macro"))
k("n", "<leader>rm", "<cmd>RustLsp parentModule<cr>", d("Parent module"))
k("n", "<leader>rj", "<cmd>RustLsp joinLines<cr>", d("Join lines"))
k("n", "<leader>rh", "<cmd>RustLsp hover actions<cr>", d("Hover actions"))
k("n", "<leader>ra", "<cmd>RustLsp codeAction<cr>", d("Code action"))
k("n", "<leader>ro", "<cmd>RustLsp openDocs<cr>", d("Open docs.rs"))
k(
	"n",
	"<leader>rp",
	"<cmd>RustLsp rebuildProcMacros<cr>",
	d("Rebuild proc macros")
)
k("n", "<leader>rg", "<cmd>RustLsp crateGraph<cr>", d("Crate graph"))

-- ── Cargo ────────────────────────────────────
k("n", "<leader>cb", "<cmd>terminal cargo build<cr>", d("Cargo build"))
k("n", "<leader>ct", "<cmd>terminal cargo test<cr>", d("Cargo test"))
k("n", "<leader>cc", "<cmd>terminal cargo check<cr>", d("Cargo check"))
k(
	"n",
	"<leader>cl",
	"<cmd>terminal cargo clippy -- -D warnings<cr>",
	d("Cargo clippy")
)

-- ── Crates.nvim ──────────────────────────────
k("n", "<leader>Cv", function()
	require("crates").show_versions_popup()
end, d("Crate versions"))
k("n", "<leader>Cf", function()
	require("crates").show_features_popup()
end, d("Crate features"))
k("n", "<leader>Cd", function()
	require("crates").show_dependencies_popup()
end, d("Crate deps"))
k("n", "<leader>Cu", function()
	require("crates").update_crate()
end, d("Update crate"))
k("n", "<leader>CU", function()
	require("crates").upgrade_crate()
end, d("Upgrade crate"))
k("n", "<leader>Ca", function()
	require("crates").update_all_crates()
end, d("Update all crates"))

-- ── Trouble ──────────────────────────────────
k("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", d("Diagnostics"))
k(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	d("Buffer diagnostics")
)
k("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", d("Symbols"))
k("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", d("Location list"))
k("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", d("Quickfix"))

-- ── Tests ────────────────────────────────────
k("n", "<leader>tn", function()
	require("neotest").run.run()
end, d("Run nearest test"))
k("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, d("Run file tests"))
k("n", "<leader>ta", function()
	require("neotest").run.run(vim.fn.getcwd())
end, d("Run all tests"))
k("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, d("Test summary"))
k("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, d("Test output"))
k("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, d("Debug test"))

-- ── DAP ──────────────────────────────────────
k("n", "<F5>", function()
	require("dap").continue()
end, d("Debug continue"))
k("n", "<F10>", function()
	require("dap").step_over()
end, d("Step over"))
k("n", "<F11>", function()
	require("dap").step_into()
end, d("Step into"))
k("n", "<F12>", function()
	require("dap").step_out()
end, d("Step out"))
k("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, d("Toggle breakpoint"))
k("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, d("Conditional breakpoint"))
k("n", "<leader>du", function()
	require("dapui").toggle()
end, d("DAP UI"))
k("n", "<leader>de", function()
	require("dapui").eval()
end, d("DAP eval"))
k("v", "<leader>de", function()
	require("dapui").eval()
end, d("DAP eval selection"))

-- ── Git ──────────────────────────────────────
k("n", "]g", function()
	require("gitsigns").next_hunk()
end, d("Next hunk"))
k("n", "[g", function()
	require("gitsigns").prev_hunk()
end, d("Prev hunk"))
k("n", "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, d("Stage hunk"))
k("n", "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, d("Reset hunk"))
k("n", "<leader>gS", function()
	require("gitsigns").stage_buffer()
end, d("Stage buffer"))
k("n", "<leader>gR", function()
	require("gitsigns").reset_buffer()
end, d("Reset buffer"))
k("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, d("Preview hunk"))
k("n", "<leader>gb", function()
	require("gitsigns").blame_line({ full = true })
end, d("Blame line"))
k("n", "<leader>gd", function()
	require("gitsigns").diffthis()
end, d("Diff this"))

-- ── Terminal ─────────────────────────────────
k("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", d("Float terminal"))
k(
	"n",
	"<leader>th",
	"<cmd>ToggleTerm direction=horizontal<cr>",
	d("Horizontal terminal")
)
k(
	"n",
	"<leader>tv",
	"<cmd>ToggleTerm direction=vertical<cr>",
	d("Vertical terminal")
)
k("t", "<Esc><Esc>", "<C-\\><C-n>", d("Terminal normal mode"))
k("t", "<C-h>", "<cmd>wincmd h<cr>", d("Window left"))
k("t", "<C-j>", "<cmd>wincmd j<cr>", d("Window down"))
k("t", "<C-k>", "<cmd>wincmd k<cr>", d("Window up"))
k("t", "<C-l>", "<cmd>wincmd l<cr>", d("Window right"))

-- ── File explorer ─────────────────────────────
k("n", "<leader>fe", "<cmd>Oil<cr>", d("File explorer"))
k("n", "-", "<cmd>Oil<cr>", d("Open parent dir"))

-- ── Inlay hints toggle ────────────────────────
k("n", "<leader>ih", function()
	if vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(
			not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
			{ bufnr = 0 }
		)
	end
end, d("Toggle inlay hints"))

-- ── Session ───────────────────────────────────
k("n", "<leader>Sr", "<cmd>SessionRestore<cr>", d("Restore session"))
k("n", "<leader>Ss", "<cmd>SessionSave<cr>", d("Save session"))

-- ── Misc ──────────────────────────────────────
k("n", "<leader>z", "<cmd>ZenMode<cr>", d("Zen mode"))
k("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
end, d("Toggle wrap"))
k("n", "<leader>uL", function()
	vim.opt.relativenumber = not vim.o.relativenumber
end, d("Toggle relnum"))
k("n", "<leader>uD", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, d("Toggle diagnostics"))
