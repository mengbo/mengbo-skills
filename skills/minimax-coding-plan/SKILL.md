---
name: minimax-coding-plan
description: MiniMax Coding Plan MCP provides web search and image understanding capabilities for developers. Use when you need to search real-time information on the web or analyze/understand image content. Supports Claude Code, Cursor, OpenCode, and other MCP-compatible clients.
version: 1.0.0
---

# MiniMax Coding Plan

MiniMax Coding Plan MCP provides two specialized tools to help developers quickly retrieve information and understand image content during coding.

## Tools

### web_search

Performs web search based on a query and returns search results with related suggestions.

**Parameters:**

| Parameter | Type   | Required | Description     |
|:----------|:-------|:---------|:----------------|
| query     | string | Yes      | Search query string |

**Returns:** JSON object containing search results with organic results, related searches, and status.

### understand_image

Analyzes and interprets image content based on a prompt/question.

**Parameters:**

| Parameter  | Type   | Required | Description                                   |
|:-----------|:-------|:---------|:----------------------------------------------|
| prompt     | string | Yes      | Question or analysis requirement for the image |
| image_url  | string | Yes      | Image source - HTTP/HTTPS URL or local file path |

**Supported formats:** JPEG, PNG, GIF, WebP (max 20MB)

**Returns:** Text description of the image analysis result.

## Prerequisites

### 1. Get API Key

Visit the [Coding Plan subscription page](https://platform.minimaxi.com/subscribe/coding-plan) to subscribe and get your API Key.

### 2. Install uvx

**macOS / Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows:**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

For other installation methods, see the [uv repository](https://github.com/astral-sh/uv).

### 3. Verify Installation

```bash
which uvx
```

If installed correctly, it will show the path (e.g., `/usr/local/bin/uvx`).

## Configuration

### Claude Code

**Quick Install:**
```bash
claude mcp add -s user MiniMax --env MINIMAX_API_KEY=your_api_key --env MINIMAX_API_HOST=https://api.minimaxi.com -- uvx minimax-coding-plan-mcp -y
```

**Manual Configuration:**

Edit `~/.claude.json`:
```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-coding-plan-mcp", "-y"],
      "env": {
        "MINIMAX_API_KEY": "your_api_key",
        "MINIMAX_API_HOST": "https://api.minimaxi.com"
      }
    }
  }
}
```

### Cursor

Go to `Cursor -> Preferences -> Cursor Settings -> Tools & Integrations -> MCP -> Add Custom MCP`

Add to `mcp.json`:
```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-coding-plan-mcp"],
      "env": {
        "MINIMAX_API_KEY": "your_api_key",
        "MINIMAX_API_HOST": "https://api.minimaxi.com"
      }
    }
  }
}
```

**Optional environment variables:**
- `MINIMAX_MCP_BASE_PATH`: Local output directory path (must exist with write permissions)
- `MINIMAX_API_RESOURCE_MODE`: Resource mode - `url` or `local` (default: `url`)

### OpenCode

Edit `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "MiniMax": {
      "type": "local",
      "command": ["uvx", "minimax-coding-plan-mcp", "-y"],
      "environment": {
        "MINIMAX_API_KEY": "your_api_key",
        "MINIMAX_API_HOST": "https://api.minimaxi.com"
      },
      "enabled": true
    }
  }
}
```

### Generic MCP Configuration

For other MCP-compatible clients:

```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-coding-plan-mcp", "-y"],
      "env": {
        "MINIMAX_API_KEY": "your_api_key",
        "MINIMAX_API_HOST": "https://api.minimaxi.com"
      }
    }
  }
}
```

## Environment Variables

| Variable                    | Required | Default                  | Description                                           |
|:----------------------------|:---------|:-------------------------|:------------------------------------------------------|
| `MINIMAX_API_KEY`           | Yes      | -                        | Your MiniMax API Key from the subscription page       |
| `MINIMAX_API_HOST`          | No       | `https://api.minimaxi.com` | API endpoint host                                    |
| `MINIMAX_MCP_BASE_PATH`     | No       | -                        | Local output directory for temporary files            |
| `MINIMAX_API_RESOURCE_MODE` | No       | `url`                    | Resource mode: `url` or `local`                       |

## Use Cases

- **Web Search:** Use when you need current information, news, facts, or data beyond your knowledge cutoff
- **Image Understanding:** Use when you need to analyze, describe, or extract information from images provided by users

## Troubleshooting

**Error: spawn uvx ENOENT**
- uvx is not in your PATH. Either:
  - Add uvx to your system PATH
  - Use the absolute path to uvx in the configuration

**Configuration not working**
- Verify your API Key is correct and active
- Check that uvx is installed: `uvx --version`
- Ensure the MCP configuration syntax matches your client

## Reference

- [MiniMax Platform](https://platform.minimaxi.com/)
- [Coding Plan Subscription](https://platform.minimaxi.com/subscribe/coding-plan)
- [uv Documentation](https://docs.astral.sh/uv/)
