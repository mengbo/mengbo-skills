# MengBo Skills

Personal Agent Skills repository, designed to work with [vercel-labs/skills](https://github.com/vercel-labs/skills).

## What are Agent Skills?

Agent Skills are modular capability packages that extend AI assistants with domain-specific abilities. This repository is used for developing and version-controlling custom skills.

## Available Skills

### pandoc-docx

**Universal document conversion using Pandoc with focus on DOCX format.**

Convert documents between various formats including Markdown, HTML, PDF, and DOCX. Supports:
- Converting Markdown, HTML, reStructuredText to DOCX
- Converting DOCX back to other formats
- Custom DOCX templates and styling
- Batch document processing
- Chinese document templates with title numbering

**Key Features:**
- Uses Pandoc for reliable format conversion
- Includes pre-configured Chinese templates
- Supports custom reference documents for styling
- Batch processing capabilities for multiple files

### minimax-coding-plan

**MiniMax Coding Plan MCP - Web search and image understanding tools for developers.**

Provides two specialized tools to help developers quickly retrieve information and understand image content during coding:

- **web_search**: Performs web search based on queries with related suggestions
- **understand_image**: Analyzes and interprets image content from local files or URLs

**Key Features:**
- Real-time web search for current information
- Image analysis and content extraction
- JSON-formatted search results
- Support for JPEG, PNG, and WebP formats (up to 20MB)

**Environment Variables:**
- `MINIMAX_API_KEY` (required): Get from https://platform.minimaxi.com/subscribe/coding-plan
- Optional: `MINIMAX_API_HOST`, `MINIMAX_MCP_BASE_PATH`

### mcp-to-skill

**Convert MCP server configuration to Agent Skill.**

Transforms MCP (Model Context Protocol) server configurations into reusable Agent Skills. Automatically generates:
- SKILL.md with tool descriptions and usage instructions
- mcp-config.json for server configuration
- exec-with-env.sh script for environment variable handling

**Key Features:**
- Supports Stdio MCP (npx-based) and HTTP MCP
- Handles environment variable substitution
- Generates ready-to-use skill packages
- Includes execution strategy guidance

**Workflow:**
1. Get MCP configuration from user or file
2. Generate skill structure using `npx -y mcp-to-skill generate`
3. Add environment variable handler script
4. Fix execution instructions in generated SKILL.md
5. Test with symlink

## Using Skills in Other Projects

```bash
# Install a skill from this repository to your project
npx skills add https://github.com/mengbo/mengbo-skills --skill <skill-name>

# List installed project skills
npx skills ls

# Global installation (recommended)
npx skills add https://github.com/mengbo/mengbo-skills --skill <skill-name> -g

# List globally installed skills
npx skills ls -g
```

## Developing New Skills

### Prerequisites

```bash
# 1. Install find-skills globally (skill discovery tool)
npx skills add https://github.com/vercel-labs/add-skill \
  --skill find-skills -g -a opencode -a claude-code -y

# 2. Install skill-creator development tool
npx skills add https://github.com/vercel-labs/add-skill --skill skill-creator
```

### Creating a New Skill

After installing skill-creator, simply tell your AI assistant:

```
"Create a new skill called my-skill"
```

The AI will automatically handle the creation process.

### Manual Development Process

```bash
# 1. Create new skill in skills/ directory
mkdir -p skills/my-skill
cd skills/my-skill

# 2. Write SKILL.md (required) and optional resources
# SKILL.md    - YAML frontmatter + usage instructions
# scripts/    - Executable scripts
# references/ - Reference documentation
# assets/     - Templates/resource files

# 3. Create symlink for testing in project root
ln -s ../../skills/my-skill .agents/skills/my-skill

# 4. After testing, remove the symlink
rm .agents/skills/my-skill
```

## Project Structure

```
mengbo-skills/
├── skills/                      # Development directory (version controlled)
│   ├── pandoc-docx/             # Document format conversion
│   ├── minimax-coding-plan/     # MiniMax Coding Plan MCP
│   └── mcp-to-skill/            # MCP to Skill converter
├── .agents/skills/              # AI assistant runtime directory (gitignored)
│   ├── pandoc-docx -> ../../skills/pandoc-docx  # Symlink (for testing)
│   ├── skill-creator/           # Externally installed skill
│   └── find-skills/             # Externally installed skill
├── README.md                    # Project documentation (this file)
└── AGENTS.md                    # AI assistant configuration (technical details)
```

**Directory Explanation:**

- `skills/`: Development directory containing custom skills, version controlled
- `.agents/skills/`: Runtime directory for external skills and test symlinks, **not committed**

## Design Principles

1. **Simplicity First**: Keep SKILL.md concise and focused
2. **Clear Descriptions**: description clearly indicates when to use
3. **Progressive Disclosure**: Core content in SKILL.md, details in references/
4. **Battle-Tested**: Scripts must be tested before inclusion

## License

Apache 2.0

## Related Resources

- [vercel-labs/skills](https://github.com/vercel-labs/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
- [Agent Skills Standard](https://agentskills.io)
