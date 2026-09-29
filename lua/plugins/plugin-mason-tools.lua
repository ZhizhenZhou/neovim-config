-- 声明式安装 mason 工具（格式化器等非 language server 的包）
--
-- 背景：mason-lspconfig 的 ensure_installed 只接受 lspconfig 注册过的
-- language server，stylua / shfmt / prettier 这类工具塞不进去。
-- 这里直接调用 mason 自带的 registry API，把工具清单声明在配置里，
-- 新机器首次启动时自动补齐，无需手动 :Mason install。
--
-- 幂等：已安装的工具在启动时不做任何事（不联网、不查 registry）。

return {
    {
        "williamboman/mason.nvim",
        lazy = false, -- 工具安装与 LSP 无关，声明本身需要尽早执行
        config = function()
            -- 需要自动安装的 mason 工具（与 plugin-format.lua 的 formatter 列表对应）
            local tools = { "stylua", "shfmt", "prettier" }

            local registry = require("mason-registry")
            local missing = vim.tbl_filter(function(tool)
                return not registry.is_installed(tool)
            end, tools)

            if #missing == 0 then
                return
            end

            vim.notify("mason: 安装缺失工具 -> " .. table.concat(missing, ", "), vim.log.levels.INFO)

            -- registry 索引首次使用时可能还没下载，先刷新再装
            registry.refresh(function()
                for _, tool in ipairs(missing) do
                    if registry.has_package(tool) then
                        registry.get_package(tool):install()
                    else
                        -- get_package 对未知包名是抛错而非返回 nil，先 has_package 把关
                        vim.notify(
                            "mason: 清单里的 '" .. tool .. "' 不在 registry 中，请检查拼写",
                            vim.log.levels.WARN
                        )
                    end
                end
            end)
        end,
    },
}
