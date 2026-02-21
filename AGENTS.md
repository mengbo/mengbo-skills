# AGENTS

This file is for AI assistants, containing technical implementation details and constraint rules.

## Directory Structure

```
mengbo-skills/
├── skills/                      # Development directory (version controlled)
│   └── pandoc-docx/             # Custom skill source code
├── .agents/skills/              # Runtime directory (AI lookup)
│   ├── pandoc-docx -> ../../skills/pandoc-docx  # Symlink (for testing)
│   ├── skill-creator/           # Externally installed skill (via find-skills)
│   └── find-skills/             # Externally installed skill
└── AGENTS.md                    # This file
```

| Directory | Purpose | Version Controlled | Contents |
|-----------|---------|-------------------|----------|
| `skills/` | Development | Yes | Custom skill source code |
| `.agents/skills/` | Runtime | No | External skills + symlinks |

**Important:** `.agents/` is excluded by `.gitignore`, externally installed skills will not be committed.

## Creating New Skills

Users need to install development tools first:

```bash
# Install find-skills globally
npx skills add https://github.com/vercel-labs/add-skill \
  --skill find-skills -g -a opencode -a claude-code -y

# Install skill-creator using find-skills
npx skills add https://github.com/vercel-labs/add-skill --skill skill-creator
```

After installing skill-creator, users will tell the AI:

```
"Create a new skill called my-skill"
```

The AI will automatically load skill-creator and execute the creation workflow.

## Progressive Disclosure Principle

Skills use a three-tier loading system:

1. **Metadata** (name + description): Always in context (~100 words)
2. **SKILL.md body**: Loaded after skill triggers (<5k words)
3. **Bundled resources**: Loaded on demand (scripts can be executed directly)

## Testing Commands

```bash
# Create symlink for testing in project root
ln -s ../../skills/my-skill .agents/skills/my-skill

# Remove symlink in project root
rm .agents/skills/my-skill

# List all skills in project root
ls -la .agents/skills/

# View symlink targets in project root
ls -la skills/
```

## Installing External Skills

```bash
# Install to project
npx skills add https://github.com/vercel-labs/add-skill --skill find-skills
```

## Constraint Rules

**Write in English:**
Skills are project outputs intended for global users, not just Chinese speakers. Use English to ensure worldwide usability.
- SKILL.md body must be in English
- Comments and documentation must be in English
- Output messages and error messages must be in English

**Don't create additional documentation files:**
- ❌ README.md
- ❌ INSTALLATION_GUIDE.md
- ❌ QUICK_REFERENCE.md
- ❌ CHANGELOG.md

Skills should only contain content essential for AI to complete tasks, no supplementary documentation.

**Don't commit externally installed skills:**
`.agents/` is gitignored, external skills won't be committed. Each developer needs to install them separately.

**Maintain platform independence:**
Skills are general Agent capability extensions, descriptions should avoid binding to specific AI tools or platforms.
- Don't mention specific AI assistant names (like Claude, GPT, opencode, etc.) in descriptions
- Use generic terms like "AI assistant" or "Agent" instead of specific product names
- Focus on functionality itself, let users decide where to use it

## Related Resources

- [skill-creator](.agents/skills/skill-creator/SKILL.md) - Complete guide for creating skills (install first)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Agent Skills Standard](https://agentskills.io)
