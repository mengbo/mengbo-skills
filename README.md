# MengBo Skills

个人 Agent Skills 仓库，配合 [vercel-labs/skills](https://github.com/vercel-labs/skills) 使用。

## 什么是 Agent Skills？

Agent Skills 是模块化技能包，让 AI 助手获得特定领域的能力。本仓库用于开发和版本控制个人定制的 skills。

## 可用的 Skills

| Skill | 功能 |
|-------|------|
| **pandoc-docx** | 使用 Pandoc 进行文档格式转换，支持 Markdown、HTML、PDF 等格式与 DOCX 互转 |
| **minimax-coding-plan** | MiniMax Coding Plan MCP - 提供 Web 搜索和图片理解工具 |
| **mcp-to-skill** | 将 MCP 服务器配置转换为 Agent Skill |

## 在其他项目中使用

```bash
# 安装本仓库的 skill 到项目
npx skills add https://github.com/mengbo/mengbo-skills --skill pandoc-docx

# 查看已安装到项目的 skills
npx skills ls

# 全局安装（推荐）
npx skills add https://github.com/mengbo/mengbo-skills --skill pandoc-docx -g

# 查看已全局安装的 skills
npx skills ls -g
```

## 开发新 Skill

### 准备工作

```bash
# 1. 全局安装 find-skills（技能发现工具）
npx skills add https://github.com/vercel-labs/add-skill \
  --skill find-skills -g -a opencode -a claude-code -y

# 2. 安装 skill-creator 开发工具
npx skills add https://github.com/vercel-labs/add-skill --skill skill-creator
```

### 创建新 Skill

安装好 skill-creator 后，直接告诉 AI 助手：

```
"创建一个名为 my-skill 的新 skill"
```

AI 会自动帮你完成创建流程。

### 手动开发流程

```bash
# 1. 在 skills/ 目录创建新 skill
mkdir -p skills/my-skill
cd skills/my-skill

# 2. 编写 SKILL.md（必需）和可选资源
# SKILL.md - YAML frontmatter + 使用说明
# scripts/   - 可执行脚本
# references/ - 参考文档
# assets/    - 模板/资源文件

# 3. 在项目根目录，创建软链接进行测试
ln -s ../../skills/my-skill .agents/skills/my-skill

# 4. 测试完成后，删除软链接
rm .agents/skills/my-skill
```

## 项目结构

```
mengbo-skills/
├── skills/                      # 自己开发的 skills（版本控制）
│   ├── pandoc-docx/             # 文档格式转换
│   ├── minimax-coding-plan/     # MiniMax Coding Plan MCP
│   └── mcp-to-skill/            # MCP 转 Skill 工具
├── .agents/skills/              # AI 助手使用目录（运行目录，被 gitignore 排除）
│   ├── pandoc-docx -> ../../skills/pandoc-docx  # 软链接（测试用）
│   ├── skill-creator/           # 外部安装的 skill
│   └── find-skills/             # 外部安装的 skill
├── README.md                    # 项目说明（本文件）
└── AGENTS.md                    # AI 助手配置（技术细节）
```

**目录说明：**

- `skills/`：开发目录，存放自己编写的 skills，会被版本控制
- `.agents/skills/`：运行目录，外部安装的 skills 和测试用软链接，**不会被提交**

## 设计原则

1. **简洁优先**：SKILL.md 保持精炼
2. **明确描述**：description 清晰说明何时使用
3. **渐进式披露**：核心内容在 SKILL.md，细节放入 references/
4. **经过验证**：scripts 必须测试

## License

Apache 2.0

## 相关资源

- [vercel-labs/skills](https://github.com/vercel-labs/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
- [Agent Skills 标准](https://agentskills.io)
