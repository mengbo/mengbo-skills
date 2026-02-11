# AGENTS

本文件面向 AI 助手，包含技术实现细节和约束规则。

## 目录结构

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

用户需要先安装开发工具：

```bash
# 全局安装 find-skills
npx skills add https://github.com/vercel-labs/add-skill \
  --skill find-skills -g -a opencode -a claude-code -y

# 使用 find-skills 为项目安装 skill-creator
npx skills add https://github.com/vercel-labs/add-skill --skill skill-creator
```

安装好 skill-creator 后，用户会告诉 AI：

```
"创建一个名为 my-skill 的新 skill"
```

AI 会自动加载 skill-creator 并执行创建流程。

## 渐进式披露原则

Skills 使用三级加载系统：

1. **Metadata** (name + description)：始终在上下文 (~100 词)
2. **SKILL.md body**：skill 触发后加载 (<5k 词)
3. **Bundled resources**：按需加载（scripts 可直接执行）

## 测试命令

```bash
# 在项目根目录，创建软链接进行测试
ln -s ../../skills/my-skill .agents/skills/my-skill

# 在项目根目录，执行如下命令删除软链接
rm .agents/skills/my-skill

# 在项目根目录，查看所有 skills
ls -la .agents/skills/

# 在项目根目录查看软链接目标
ls -la skills/
```

## 安装外部 Skills

```bash
# 安装到项目
npx skills add https://github.com/vercel-labs/add-skill --skill find-skills
```

## 约束规则

**不要创建额外文档文件**：
- ❌ README.md
- ❌ INSTALLATION_GUIDE.md
- ❌ QUICK_REFERENCE.md
- ❌ CHANGELOG.md

Skill 只包含 AI 完成任务必需的内容，不要包含辅助性文档。

**不要提交外部安装的 skills**：
`.agents/` 被 gitignore 排除，外部 skills 不会被提交。每个开发者需要自己安装。

## 相关资源

- [skill-creator](.agents/skills/skill-creator/SKILL.md) - 创建 skills 的完整指南（需先安装）
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Agent Skills 标准](https://agentskills.io)
