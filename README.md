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

> WSL 下剪贴板自动桥接到 Windows（`clip.exe` / PowerShell），无需手动配置。

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
- **保存时格式化**：lua→stylua，python→ruff_format，sh/zsh/bash→shfmt，js/ts/json/css/html/md→prettier
- **treesitter 解析器**：c/cpp/lua/vim/vimdoc/query/markdown/java/python/js/ts（首次打开文件时自动安装）

## 设计取舍

- **telescope 钉在 `0.1.8`**：0.1.x 后 API 变动频繁，锁定版本避免升级即坏；其余插件采用**滚动版本**，新机器安装当日的最新版，本机 `lazy-lock.json` 不入库。
- **treesitter 用 main 分支**：0.12 起 treesitter 回归极简配置（`install()` + 原生 `vim.treesitter.start`），旧 `setup` API 已废弃。
- **netrw 做文件浏览**而非 nvim-tree：内置、零配置，`options.lua` 里已调优；砍掉了一个插件依赖。
- **WSL 剪贴板桥接**写死在 `remap.lua`，非 WSL 环境自动跳过。

## 排错

- `:checkhealth` —— 依赖体检（node/gcc/ripgrep 缺失会在这里暴露）
- `:Lazy` —— 插件状态与更新
- `:Mason` —— LSP server 安装状态
- 语法高亮异常 → `:TSUpdate` 重新编译解析器（需要 gcc/make）
