# MengBo Skills

个人 Agent Skills 仓库，用于管理和版本控制个人定制的 skills，配合 [openskills](https://github.com/numman-ali/openskills) 实现按项目定制的渐进式技能管理。

## 核心理念

**渐进式披露（Progressive Disclosure）**

- **初始上下文**：仅加载技能名称和描述（AGENTS.md 中的 `<available_skills>` 部分）
- **按需加载**：完整指令仅在调用时通过 `openskills read <skill-name>` 注入
- **优势**：减少初始 token 消耗，让 Agent 专注于真正相关的技能

### 对比传统方式

| 方式 | 上下文占用 | 灵活性 | 适用场景 |
|------|-----------|---------|---------|
| **传统方式** | 一次性注入所有 skills 的完整指令 | 低 | 技能数量少且通用性强 |
| **渐进式披露** | 仅注入技能元数据，按需加载完整指令 | 高 | 技能数量多、按项目定制 |

主流 AI 编程助手通常会将所有 skills 的元数据一次性注入到上下文，这会造成不必要的 token 消耗。而通过 `openskills sync` 在 AGENTS.md 中添加项目相关的 skill，能够实现按项目定制的精细化披露，大幅减少初始上下文占用。

## 快速开始

### 在本仓库中使用

```bash
# 克隆仓库
git clone https://github.com/mengbo/mengbo-skills.git
cd mengbo-skills

# 安装 openskills（如未安装）
npm install -g openskills

# 设置软链接
mkdir -p .agent && ln -s ../skills .agent/skills
# 软链接作用：.agent/skills 是 openskills 默认查找 skills 的位置
# 软链接指向 skills/ 目录，当访问 .agent/skills/your-skill-name/ 时，实际访问的是 skills/your-skill-name/
# 这样 openskills 和 AI 就能读取到 skills/your-skill-name/ 下的 SKILL.md、scripts/、references/、assets/ 文件

# 同步到 AGENTS.md
openskills sync
```

### 在其他项目中使用

```bash
openskills install mengbo/mengbo-skills --universal
openskills sync
```

## 开发新 Skill

创建新 skill 使用 AI 编程助手（如 opencode、Claude Code），配合 anthropics/skills 的 skill-creator 指导：

```bash
# 1. 安装 anthropics/skills（universal 模式）
openskills install anthropics/skills --universal

# 2. 同步到 AGENTS.md，确保 skill-creator 可用
openskills sync

# 3. 使用 AI 编程助手创建新 skill
# 在 opencode 中输入：创建一个名为 your-skill-name 的新 skill
# AI 会自动读取 skill-creator 指导并帮你完成

# 4. 测试新 skill
openskills sync

# 5. 提交到 GitHub
git add skills/your-skill-name
git commit -m "Add your-skill-name"
git push
```

## 项目结构

```
mengbo-skills/
├── README.md         # 项目说明
├── AGENTS.md         # Agent 配置文件
├── .gitignore
├── .agent/
│   └── skills -> ../skills   # 软链接：指向 skills/ 目录
└── skills/          # Skills 源代码（主目录，版本控制）
    └── your-skill-name/
        ├── SKILL.md
        ├── assets/
        ├── references/
        └── scripts/
```

**软链接作用**：
- `.agent/skills` 是 openskills 默认查找 skills 的位置
- 软链接指向 `skills/` 目录，当访问 `.agent/skills/your-skill-name/` 时，实际访问的是 `skills/your-skill-name/`
- 软链接指向整个 `skills/` 目录，在 `skills/` 目录下创建新 skill 后，新 skill 自动可以通过软链接访问，无需重新配置
- 克隆仓库后需手动创建：`ln -s ../skills .agent/skills`

## License

Apache 2.0

## 相关资源

- [openskills](https://github.com/numman-ali/openskills) - Universal skills loader
- [anthropics/skills](https://github.com/anthropics/skills) - Anthropic's official skills
- [Agent Skills 标准](https://agentskills.io)
