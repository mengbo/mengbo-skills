---
name: mcp-to-skill
description: Convert MCP server configuration to Claude/opencode Skill. Triggered when users mention "MCP to skill", "convert MCP service to skill", "generate MCP skill", "MCP conversion" or similar requests. Supports reading configuration from conversation context or file path.
---

## Workflow

### Step 1: Get MCP Configuration

- **Method A**: User pasted configuration in conversation → Use directly
- **Method B**: User provided configuration file path → Use that path
- If not provided, ask: "Please provide MCP configuration (paste JSON directly or provide file path)"

**Supported formats:**
- Stdio MCP (npx-based)
- HTTP MCP
- Direct format (without mcpServers wrapper)

### Step 2: Generate the Skill

**Determine output location:**
- Ask for skill name (or extract from config's `name` field)
- Output directory: `./skills/<skill-name>/`

**Execute conversion:**

```bash
# If configuration is in conversation (Method A):
cat > /tmp/mcp-config.json << 'EOF'
<configuration content>
EOF

npx -y mcp-to-skill generate \
  --mcp-config /tmp/mcp-config.json \
  --output-dir ./skills/<skill-name>

# If configuration is a file path (Method B):
npx -y mcp-to-skill generate \
  --mcp-config <configuration file path> \
  --output-dir ./skills/<skill-name>
```

**Generated structure:**
```
./skills/<skill-name>/
├── SKILL.md              # Instructions (~100 tokens)
└── mcp-config.json       # MCP server config
```

### Step 3: Add Script Support (REQUIRED)

The generated skill needs the environment variable handler script:

```bash
# Copy the helper script to the generated skill
mkdir -p ./skills/<skill-name>/scripts
cp $(dirname $0)/scripts/exec-with-env.sh ./skills/<skill-name>/scripts/
chmod +x ./skills/<skill-name>/scripts/exec-with-env.sh
```

**Result structure:**
```
./skills/<skill-name>/
├── SKILL.md
├── mcp-config.json
└── scripts/
    └── exec-with-env.sh  # Environment variable handler
```

### Step 4: Fix SKILL.md Execution Instructions (CRITICAL)

**The generated SKILL.md contains wrong instructions. You MUST fix them:**

❌ **REMOVE all instructions like:**
```bash
npx -y mcp-to-skill exec --config $SKILL_DIR/mcp-config.json --call '{...}'
```

✅ **REPLACE with script-based execution:**
```bash
$SKILL_DIR/scripts/exec-with-env.sh $SKILL_DIR/mcp-config.json <tool_name> '{"param": "value"}'
```

**Required changes to generated SKILL.md:**

1. **Add Commands/Usage section** showing script usage:
   ```markdown
   ## Commands
   
   **Execute tools:**
   ```bash
   $SKILL_DIR/scripts/exec-with-env.sh $SKILL_DIR/mcp-config.json tool_name '{"param": "value"}'
   ```
   
   **Examples:**
   ```bash
   # Example for tool1
   $SKILL_DIR/scripts/exec-with-env.sh $SKILL_DIR/mcp-config.json tool1 '{"query": "hello"}'
   
   # Example for tool2  
   $SKILL_DIR/scripts/exec-with-env.sh $SKILL_DIR/mcp-config.json tool2 '{"input": "test"}'
   ```
   ```

2. **Remove any "npx -y mcp-to-skill exec" references**

3. **Update description** to mention environment variable support

4. **Add Execution Strategy section** (before Usage Pattern or Error Handling):
   ```markdown
   ## Execution Strategy

   **Important: Execute directly, don't ask beforehand**

   When using this skill, **execute commands directly** without asking users to confirm environment variables are set.

   - Environment variable status is determined at execution time
   - If execution fails, the error message will clearly indicate missing configuration
   - Only then inform the user what needs to be configured
   - Follow "fail fast" principle to avoid unnecessary interactions

   ❌ **Don't do this:**
   - "Please confirm you have set the API_KEY environment variable"
   - "Before executing, please ensure you have configured..."

   ✅ **Do this:**
   - Execute the command directly
   - If it fails, inform the user based on the error message
   ```

### Step 5: Test the Skill

Create symlink for testing:
```bash
ln -s ../../skills/<skill-name> .agents/skills/<skill-name>
```

Or copy to Claude skills directory:
```bash
cp -r ./skills/<skill-name> ~/.claude/skills/
```

## Scripts

### exec-with-env.sh

Universal MCP Skill executor with environment variable support.

**Why needed:** MCP configs often contain `${VAR}` syntax for API keys. The `mcp-to-skill` tool doesn't resolve these. This script generates a temporary config with resolved values before execution.

**Location:** `scripts/exec-with-env.sh`

**Usage:**
```bash
scripts/exec-with-env.sh <mcp-config.json-path> <tool-name> [arguments-json]
```

**Examples:**
```bash
# Basic usage
scripts/exec-with-env.sh ./my-skill/mcp-config.json web_search \
  '{"query": "hello world"}'

# Config with default values:
# "API_HOST": "${API_HOST:-https://api.example.com}"
scripts/exec-with-env.sh ./mcp-config.json tool_name '{"input": "test"}'
```

**Supported syntax in mcp-config.json:**
- `$VAR` - Direct replacement
- `${VAR}` - Braced format
- `${VAR:-default}` - With default value

**Error handling:**
- Exits if env var not set and no default
- Validates generated JSON before execution

## Quick Reference

| Task | Command |
|------|---------|
| Generate skill | `npx -y mcp-to-skill generate --mcp-config <file> --output-dir ./skills/<name>` |
| Add script | `cp scripts/exec-with-env.sh ./skills/<name>/scripts/` |
| Execute tool | `$SKILL_DIR/scripts/exec-with-env.sh $SKILL_DIR/mcp-config.json <tool> '{"param": "val"}'` |

## Reference

- Original project: https://github.com/larkinwc/ts-mcp-to-skill
