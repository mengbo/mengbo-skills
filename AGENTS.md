# AGENTS

## 目录结构

本仓库采用分离式目录管理：

```
mengbo-skills/
├── skills/                      # 开发目录（版本控制）
│   └── pandoc-docx/             # 自己开发的 skill 源代码
├── .agents/skills/              # 运行目录（AI 查找）
│   ├── pandoc-docx -> ../../skills/pandoc-docx  # 软链接（测试用）
│   ├── skill-creator/           # 外部安装的 skill（通过 find-skills）
│   └── find-skills/             # 外部安装的 skill
└── AGENTS.md                    # 本文件
```

| 目录 | 用途 | 版本控制 | 存放内容 |
|------|------|----------|----------|
| `skills/` | 开发目录 | 是 | 自己开发的 skill 源代码 |
| `.agents/skills/` | 运行目录 | 否 | 外部安装的 skills + 软链接 |

**重要**：`.agents/` 被 `.gitignore` 排除，外部安装的 skills 不会被提交。

## 创建新 Skill

### 准备工作

用户需要先安装开发工具：

```bash
# 安装 find-skills
npx skills add https://github.com/vercel-labs/add-skill \
  --skill find-skills -g -a opencode -a claude-code -y

# 使用 find-skills 安装 skill-creator
npx skills add https://github.com/vercel-labs/add-skill --skill skill-creator
```

### 使用 skill-creator（推荐）

安装好 skill-creator 后，用户可以告诉 AI：

```
"创建一个名为 my-skill 的新 skill"
```

AI 会自动加载 skill-creator 并执行创建流程。

### 手动流程

```bash
# 1. 在 skills/ 创建目录
mkdir -p skills/my-skill
cd skills/my-skill

# 2. 创建 SKILL.md 模板
cat > SKILL.md << 'EOF'
---
name: my-skill
description: 清晰描述这个 skill 的功能和何时使用它
---

# My Skill

## 使用示例

- 示例 1
- 示例 2
EOF

# 3. 可选：创建资源目录
mkdir -p scripts references assets

# 4. 链接到 .agents/skills/ 测试
ln -s ../../skills/my-skill ../../.agents/skills/my-skill

# 5. 删除链接（测试完成后）
rm ../../.agents/skills/my-skill
```

## Skill 目录规范

### 必需文件

```
skill-name/
└── SKILL.md              # YAML frontmatter + 指令
```

**SKILL.md 格式**：
- **Frontmatter**（必须）：
  - `name`: skill 名称
  - `description`: 描述功能和触发条件（这是触发 skill 的关键）
- **Body**: 使用指南和最佳实践

**重要**：`name` 和 `description` 是唯一会注入初始上下文的字段，description 必须清晰说明何时使用。

### 可选资源

```
skill-name/
├── scripts/              # 可执行代码（Python/Bash）
│   └── script.py
├── references/           # 参考文档（按需加载）
│   └── api-docs.md
└── assets/               # 输出资源（模板、图标等）
    └── template.docx
```

**资源类型说明**：
- **scripts/**：需要确定性可靠性的任务，可执行不读取到上下文
- **references/**：详细文档，在需要时读取（大文件 >10k 字需注明 grep 搜索方式）
- **assets/**：输出使用的文件，不加载到上下文

## 渐进式披露原则

Skills 使用三级加载系统：

1. **Metadata** (name + description)：始终在上下文 (~100 词)
2. **SKILL.md body**：skill 触发后加载 (<5k 词)
3. **Bundled resources**：按需加载（scripts 可直接执行）

**保持 SKILL.md 精简**：
- 推荐 <500 行
- 核心工作流在 SKILL.md
- 变体/细节移到 references/

**组织模式**：
```markdown
# Skill Name

## 核心功能
[基础用法]

## 高级特性
- **功能 A**: 见 [A.md](A.md)
- **功能 B**: 见 [B.md](B.md)
```

## 测试命令

```bash
# 创建软链接进行测试
ln -s ../../skills/my-skill .agents/skills/my-skill

# 删除软链接
rm .agents/skills/my-skill

# 查看所有 skills
ls -la .agents/skills/

# 查看软链接目标
ls -la skills/
```

## 安装外部 Skills

```bash
# 安装到项目
npx skills add https://github.com/vercel-labs/add-skill --skill find-skills

# 全局安装
npx skills add https://github.com/vercel-labs/add-skill --skill find-skills -g
```

## 不要做的事

**不要创建额外文档文件**：
- ❌ README.md
- ❌ INSTALLATION_GUIDE.md
- ❌ QUICK_REFERENCE.md
- ❌ CHANGELOG.md

Skill 只包含 AI 完成任务必需的内容，不要包含辅助性文档。

**不要提交外部安装的 skills**：
`.agents/` 被 gitignore 排除，外部 skills 不会被提交。每个开发者需要自己安装。

## 相关资源

- [skill-creator](skill-creator/SKILL.md) - 创建 skills 的完整指南（需先安装）
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Agent Skills 标准](https://agentskills.io)
