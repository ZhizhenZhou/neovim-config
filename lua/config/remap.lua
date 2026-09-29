-- WSL：剪贴板桥接到 Windows
-- 粘贴命令的写法坑：nvim 会把这段字符串交给 shell 执行，所以
--   1. 必须用单引号把 -Command 的参数整体包住，否则 $(...) 会被 shell 当命令替换、
--      [Console]::Out.Write(...) 的裸括号直接引发 sh 语法错误；
--   2. 去掉 PowerShell 里的行尾 CR（\r 用正则写，避开反引号转义与多层引号嵌套）。
if vim.fn.has("wsl") == 1 then
    local ps_paste = "powershell.exe -NoProfile -Command '[Console]::Out.Write(((Get-Clipboard -Raw) -replace \"\\r\", \"\"))'"
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = ps_paste,
            ['*'] = ps_paste,
        },
        cache_enabled = 0, -- 每次实时读，不缓存
    }
end

-- mapleader 在 lua/config/lazy.lua 里设置（必须早于 lazy.setup，否则插件键位绑定错）
-- vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)


vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>p", [["+p]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
