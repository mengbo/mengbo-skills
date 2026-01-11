# AGENTS

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: Bash("openskills read <skill-name>")
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>skill-creator</name>
<description>Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.</description>
<location>global</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

---

**注意**：上方 `<skills_system>` 标记内的内容由 `openskills` 自动维护，AI 编程助手不需要修改此部分。

## Skill 工作原理

### 渐进式披露机制

- **初始上下文**：仅加载技能名称和描述（本文件的 `<available_skills>` 部分）
- **按需加载**：完整指令仅在调用时通过 `openskills read <skill-name>` 注入
- **优势**：减少初始 token 消耗，让 Agent 专注于真正相关的技能

### 使用流程

1. **同步 skills**：运行 `openskills sync` 更新本文件的 `<available_skills>` 部分
2. **加载 skill**：运行 `openskills read <skill-name>` 注入完整指令
3. **执行任务**：Agent 按照指令完成任务
4. **资源解析**：通过 base directory 解析 references/、scripts/、assets/ 路径

### Skills 目录说明

本仓库使用软链接方式管理 skills：
- `.agent/skills` 是 openskills 默认查找 skills 的位置（软链接）
- 通过软链接指向 `skills/` 源代码目录
- 实际的 skill 文件（SKILL.md、scripts/、references/、assets/）位于 `skills/your-skill-name/` 子目录下
- 通过软链接，Agent 可以使用 `.agent/skills/your-skill-name/` 路径访问 skill 文件
- 软链接指向整个 `skills/` 目录，在 `skills/` 目录下创建新 skill 后，新 skill 自动可以通过软链接访问，无需重新配置

注意：如果软链接不存在，需要手动创建：`ln -s ../skills .agent/skills`

### 目录结构规范

每个 skill 应包含：

```
your-skill-name/
├── SKILL.md          # 必需：YAML frontmatter + 指令
├── scripts/          # 可选：可执行脚本
├── references/       # 可选：参考文档
└── assets/           # 可选：模板/资源文件
```

**SKILL.md 格式**：

```markdown
---
name: your-skill-name
description: 清晰描述这个 skill 的功能和何时使用它
---

# Skill Name

当用户请求 X 时，遵循这些步骤...

## 使用示例

- 示例 1
- 示例 2

## 最佳实践

- 原则 1
- 原则 2
```

**注意事项**：
- `name` 和 `description` 是唯一会被注入到初始上下文的字段
- `description` 必须清晰说明 skill 的功能和触发条件
- 详细的指令和使用指南放在 markdown body 部分
- 保持 SKILL.md 简洁（推荐 <500 行），将详细内容放到 `references/` 目录

### 资源类型说明

- **scripts/**：可执行代码（Python、Bash 等），用于需要确定性可靠性的任务
- **references/**：参考文档，包含 API 文档、模式、业务逻辑等详细文档
- **assets/**：输出资源文件，如模板、图标、样板代码等，不会加载到上下文

### 相关资源

- [OpenSkills 文档](https://github.com/numman-ali/openskills)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Agent Skills 标准](https://agentskills.io)
