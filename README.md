# neovim-config

个人 neovim 配置：`lazy.nvim` 管理，开箱即得 LSP、补全、模糊搜索、格式化与语法高亮。

> 前置安装（nvim 本体与系统依赖）见 [dot-config/neovim/README.md](https://github.com/ZhizhenZhou/dot-config/blob/main/neovim/README.md)，
> 两个仓库的依赖要求保持一致。

## 目录结构

```
├── init.lua                  入口：按序加载 config/ 三件套
├── lua/config/
│   ├── lazy.lua              lazy.nvim 引导与全局设置（leader、rocks 关闭）
│   ├── remap.lua             基础快捷键 + WSL 剪贴板桥接
│   └── options.lua           编辑器选项（缩进/搜索/UI/netrw）
└── lua/plugins/              一插件一文件，按需增删
    ├── plugin-lsp.lua        LSP + mason + nvim-cmp 补全（最大的文件）
    ├── plugin-mason-tools.lua  声明式安装 mason 工具（stylua/shfmt/prettier）
    ├── plugin-telescope.lua  模糊搜索
    ├── plugin-nvim-treesitter.lua       语法高亮（nvim 0.12 main 分支用法）
    ├── plugin-nvim-treesitter-context.lua  顶部常驻函数上下文
    ├── plugin-format.lua     conform.nvim 保存时格式化
    ├── plugin-fugitive.lua   git 集成
    ├── plugin-comment.lua    gc 注释
    ├── plugin-undotree.lua   撤销历史树
    ├── plugin-lualine.lua    状态栏
    └── plugin-colorschemes.lua  tokyonight 主题
```

## 安装

```bash
git clone https://github.com/ZhizhenZhou/neovim-config.git ~/.config/nvim/
nvim   # 首次启动 lazy.nvim 自动安装全部插件
```

装完运行 `:checkhealth` 确认依赖；treesitter 解析器首次打开对应语言文件时自动编译。

## 快捷键

Leader 是 **空格**。以下全部可执行验证，来源文件见括号。

### 基础（`lua/config/remap.lua`）

| 按键 | 模式 | 作用 |
|---|---|---|
| `<leader>y` | n/v | 复制到**系统**剪贴板 |
| `<leader>Y` | n | 复制到行尾到系统剪贴板 |
| `<leader>p` | n | 粘贴系统剪贴板 |
| `<leader>p` | x | 粘贴选区但不覆盖寄存器（`_dP`） |
| `<leader>d` | n/v | 删除且不污染寄存器 |
| `<C-k>` / `<C-j>` | n | quickfix 下一条 / 上一条（并居中） |
| `<leader>k` / `<leader>j` | n | location list 下一条 / 上一条 |
| `<leader><leader>` | n | source 当前文件 |

> WSL 下剪贴板自动桥接到 Windows（复制走 `clip.exe`，粘贴走 PowerShell），无需手动配置。
> 粘贴命令必须把 `-Command` 的参数用**单引号整体包住**——否则 `$(...)` 会被 shell 当命令替换、
> `[Console]::Out.Write(...)` 的裸括号会直接引发 sh 语法错误（这个坑踩过一次）。

### LSP（`plugin-lsp.lua`，附着到已启动 LSP 的 buffer）

| 按键 | 模式 | 作用 |
|---|---|---|
| `gd` | n | 跳转定义 |
| `K` | n | 悬停文档 |
| `<leader>vws` | n | 全工作区符号搜索 |
| `<leader>vd` | n | 诊断浮窗 |
| `[d` / `]d` | n | 下一个 / 上一个诊断 |
| `<leader>vca` | n | code action |
| `<leader>vrr` | n | 查找引用 |
| `<leader>vrn` | n | 重命名 |
| `<C-h>` | i | 签名帮助 |

### 补全（插入模式，nvim-cmp）

| 按键 | 作用 |
|---|---|
| `<C-n>` / `<C-p>` | 选下一个 / 上一个候选 |
| `<C-y>` | 确认当前候选 |

补全源：`buffer`（当前缓冲区已出现的词）、`path`（文件路径）、`nvim_lsp`（语言服务器）。

> **代码片段（snippets）未启用**。仓库里没有 LuaSnip / friendly-snippets，
> 补全弹窗不会给出 `for i ... end` 这类片段展开。需要的话按 `plugin-lsp.lua` 里的注释加回。

### 模糊搜索（telescope）

| 按键 | 作用 |
|---|---|
| `<leader>ff` | 找文件 |
| `<leader>fg` | 全文搜索（依赖 ripgrep） |
| `<leader>fb` | 已打开 buffer |
| `<leader>fh` | 帮助标签 |

### Git（fugitive）

| 按键 | 作用 |
|---|---|
| `<leader>gs` | `:Git` 状态面板 |
| `<leader>p` / `<leader>P` | fugitive 面板内：push / pull --rebase |
| `<leader>t` | fugitive 面板内：`git push -u origin <branch>` |
| `gu` / `gh` | merge 冲突时取本地（//2）/ 对方（//3）一侧 |

### 其它

| 按键 | 作用 |
|---|---|
| `<leader>u` | 撤销历史树开关 |
| `gcc` / `gc{motion}` | 注释 / 取消注释（Comment.nvim） |

## LSP 与格式化覆盖范围

- **LSP**（mason 自动安装）：`bashls` `clangd` `ts_ls` `pyright` `dockerls` `lua_ls` `rust_analyzer`
- **保存时格式化**：lua→stylua，sh/zsh/bash→shfmt，js/ts/json/css/html/md→prettier
- **treesitter 解析器**：c/cpp/lua/vim/vimdoc/query/markdown/java/python/js/ts（首次打开文件时自动安装）

上述三类都是**声明在配置里、新机器首次启动自动装齐**，无需手动 `:Mason install`：

| 类别 | 声明位置 | 安装时机 |
|---|---|---|
| language server | `plugin-lsp.lua` 的 `ensure_installed` | nvim 启动时由 mason-lspconfig 自动 |
| 格式化器（stylua/shfmt/prettier） | `plugin-mason-tools.lua` 的 `tools` | 启动时检测到缺失才装；已装齐则不联网 |
| treesitter 解析器 | `plugin-nvim-treesitter.lua` 的 `ensure_installed` | 首次打开对应语言文件时 |

> `stylua` / `shfmt` / `prettier` 走 mason 而不是系统包管理，是为了和 LSP 共用一套安装机制。

## 设计取舍

- **插件全部滚动版本**：任何插件都不钉版本，新机器安装当日的最新 commit，本机 `lazy-lock.json` 不入库。代价是接受“上游 breaking change 偶尔需要修一下”的概率（实测可控）；换来的是仓库无版本快照噪音。
- **treesitter 用 main 分支**：0.12 起 treesitter 回归极简配置（`install()` + 原生 `vim.treesitter.start`），旧 `setup` API 已废弃。
- **netrw 做文件浏览**而非 nvim-tree：内置、零配置，`options.lua` 里已调优；砍掉了一个插件依赖。
- **mason 工具自己声明安装**：`ensure_installed` 只接受 lspconfig 注册过的 language server，装不了 stylua/shfmt 这类工具；与其引入 `mason-tool-installer` 这个胶水插件，不如直接调 mason 自带的 registry API（`is_installed` / `has_package` / `get_package` / `refresh`），十行代码解决，零新依赖。
- **已装齐时零开销**：工具声明先本地判重，全都在就直接返回，不联网、不刷 registry。
- **LSP 启用交给 mason-lspconfig v2**：`ensure_installed` 里的 server 会被自动 `vim.lsp.enable`，不再写 `handlers` 回调——该选项在 v2 已被移除，保留只会让人误以为它生效。
- **WSL 剪贴板桥接**写死在 `remap.lua`，非 WSL 环境自动跳过；粘贴命令的单引号包裹是必需项，见快捷键章节的说明。

## 排错

- `:checkhealth` —— 依赖体检（node/gcc/ripgrep 缺失会在这里暴露）
- `:Lazy` —— 插件状态与更新
- `:Mason` —— LSP server 与 mason 工具（stylua/shfmt/prettier）的安装状态
- 语法高亮异常 → `:TSUpdate` 重新编译解析器（需要 gcc/make）
