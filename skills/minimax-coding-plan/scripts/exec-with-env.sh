#!/bin/bash
#
# Universal MCP Skill executor with environment variable support
#
# Usage:
#   exec-with-env.sh <mcp-config.json-path> <tool-name> '[arguments-json]'
#
# Example:
#   exec-with-env.sh ./my-skill/mcp-config.json web_search \
#     '{"query": "hello world"}'
#
# Supported environment variable syntax:
#   ${VAR}         - Direct replacement with env var value
#   ${VAR:-default} - Use value if set, otherwise use default
#
# Note:
#   Exits with error if env var is not set and no default is provided

set -e

# Check arguments
if [ $# -lt 2 ]; then
    echo "Error: Insufficient arguments" >&2
    echo "Usage: $0 <mcp-config.json-path> <tool-name> [arguments-json]" >&2
    echo "Example: $0 ./mcp-config.json web_search '{\"query\": \"hello\"}'" >&2
    exit 1
fi

CONFIG_FILE="$1"
TOOL_NAME="$2"

# Handle 3rd argument (JSON arguments)
# bash may perform brace expansion on {}, resulting in extra }
ARGS_JSON="${3:-{}}"
if [[ "$ARGS_JSON" == *}} ]]; then
    ARGS_JSON="${ARGS_JSON%\}}"
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file does not exist: $CONFIG_FILE" >&2
    exit 1
fi

# Parse environment variables in config file
# Supports $VAR, ${VAR}, ${VAR:-default} syntax
parse_env_vars() {
    local file="$1"
    local content=$(cat "$file")
    
    # Handle ${VAR:-default} syntax (with default value)
    while [[ "$content" =~ \$\{([^}:]+):-([^}]*)\} ]]; do
        local var_name="${BASH_REMATCH[1]}"
        local default_val="${BASH_REMATCH[2]}"
        local full_match="${BASH_REMATCH[0]}"
        
        local var_value="${!var_name:-$default_val}"
        content="${content//$full_match/$var_value}"
    done
    
    # Handle ${VAR} syntax (braced, no default)
    while [[ "$content" =~ \$\{([^}]+)\} ]]; do
        local var_name="${BASH_REMATCH[1]}"
        local full_match="${BASH_REMATCH[0]}"
        
        if [ -z "${!var_name+x}" ]; then
            echo "Error: Environment variable $var_name is not set and has no default" >&2
            exit 1
        fi
        
        local var_value="${!var_name}"
        content="${content//$full_match/$var_value}"
    done
    
    # Handle $VAR syntax (no braces)
    # Note: This may accidentally match other content, so placed last and only matches typical variable names
    while [[ "$content" =~ \$([A-Za-z_][A-Za-z0-9_]*) ]]; do
        local var_name="${BASH_REMATCH[1]}"
        local full_match="${BASH_REMATCH[0]}"
        
        if [ -z "${!var_name+x}" ]; then
            echo "Error: Environment variable $var_name is not set" >&2
            exit 1
        fi
        
        local var_value="${!var_name}"
        content="${content//$full_match/$var_value}"
    done
    
    echo "$content"
}

# Create temporary config file
TEMP_CONFIG=$(mktemp)
trap "rm -f '$TEMP_CONFIG'" EXIT

# Parse and write to temporary config file
parse_env_vars "$CONFIG_FILE" > "$TEMP_CONFIG"

# Validate generated JSON
if ! jq empty "$TEMP_CONFIG" 2>/dev/null; then
    echo "Error: Generated config file is not valid JSON" >&2
    echo "Generated content:" >&2
    cat "$TEMP_CONFIG" >&2
    exit 1
fi

# Build call JSON
CALL_JSON=$(jq -n \
    --arg tool "$TOOL_NAME" \
    --argjson args "$ARGS_JSON" \
    '{tool: $tool, arguments: $args}')

# Execute tool
exec npx -y mcp-to-skill@0.2.2 exec --config "$TEMP_CONFIG" --call "$CALL_JSON"
