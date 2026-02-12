#!/bin/bash

# OpenClaw Agent Model Manager
# 用于轻松管理不同 Agent 的 model 和 API Key

set -e

# 配置路径
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"
AGENTS_DIR="$HOME/.openclaw/agents"
BACKUP_DIR="$HOME/.openclaw/backups"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查 jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    echo "Install with: brew install jq"
    exit 1
fi

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份函数
backup_config() {
    local file="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local basename=$(basename "$file")
    cp "$file" "$BACKUP_DIR/${basename}.${timestamp}"
    echo -e "${BLUE}Backed up: $file → $BACKUP_DIR/${basename}.${timestamp}${NC}"
}

# 列出所有 Agent
list_agents() {
    echo -e "\n${GREEN}=== OpenClaw Agents ===${NC}\n"
    jq -r '.agents.list[] | "\(.id)\t\(.name // "Unnamed")\t\(.workspace)"' "$OPENCLAW_CONFIG" | \
        awk -F'\t' 'BEGIN {printf "%-15s %-20s %s\n", "ID", "Name", "Workspace"; printf "%-15s %-20s %s\n", "-", "----", "---------"} {printf "%-15s %-20s %s\n", $1, $2, $3}'
    echo ""
}

# 显示 Agent 的模型配置
show_agent_model() {
    local agent_id="$1"
    local agent_config=$(jq -r ".agents.list[] | select(.id == \"$agent_id\")" "$OPENCLAW_CONFIG")

    if [[ -z "$agent_config" ]]; then
        echo -e "${RED}Agent '$agent_id' not found${NC}"
        exit 1
    fi

    echo -e "\n${GREEN}=== Agent: $agent_id ===${NC}\n"

    # 显示 primary 和 fallbacks
    local primary=$(echo "$agent_config" | jq -r '.model.primary // "Not set (use default)"')
    local fallbacks=$(echo "$agent_config" | jq -r '.model.fallbacks // [] | join(", ")' 2>/dev/null || echo "Not set")

    echo "Primary Model:   ${YELLOW}$primary${NC}"
    echo "Fallbacks:       ${YELLOW}$fallbacks${NC}"

    # 显示默认配置
    local default_primary=$(jq -r '.agents.defaults.model.primary' "$OPENCLAW_CONFIG")
    local default_fallbacks=$(jq -r '.agents.defaults.model.fallbacks | join(", ")' "$OPENCLAW_CONFIG")

    if [[ "$primary" == "null" ]] || [[ "$primary" == "" ]]; then
        echo ""
        echo -e "${BLUE}(Using default: primary=$default_primary, fallbacks=$default_fallbacks)${NC}"
    fi

    # 显示可用的 providers
    echo ""
    echo -e "${BLUE}Available Providers:${NC}"
    jq -r '.models.providers | to_entries[] | "  \(.key): \(.value.apiKey[0:20])..."' "$OPENCLAW_CONFIG"

    # 显示 agent 专属 providers
    local agent_models_file="$AGENTS_DIR/$agent_id/agent/models.json"
    if [[ -f "$agent_models_file" ]]; then
        echo ""
        echo -e "${BLUE}Agent-Specific Providers:${NC}"
        jq -r '.providers | to_entries[] | "  \(.key): \(.value.apiKey[0:20])..."' "$agent_models_file"
    fi

    echo ""
}

# 设置 Agent 的 primary 模型
set_agent_model() {
    local agent_id="$1"
    local model="$2"

    # 备份
    backup_config "$OPENCLAW_CONFIG"

    # 解析 provider 和 model
    local provider=$(echo "$model" | cut -d'/' -f1)
    local model_id=$(echo "$model" | cut -d'/' -f2)

    if [[ -z "$model_id" ]]; then
        echo -e "${RED}Invalid model format. Use: <provider>/<model-id> (e.g., zai/glm-4.7)${NC}"
        exit 1
    fi

    # 检查 provider 是否存在
    local provider_exists=$(jq -r ".models.providers | has(\"$provider\")" "$OPENCLAW_CONFIG")
    if [[ "$provider_exists" != "true" ]]; then
        echo -e "${RED}Provider '$provider' not found${NC}"
        exit 1
    fi

    # 设置 model
    if jq -e ".agents.list[] | select(.id == \"$agent_id\")" "$OPENCLAW_CONFIG" > /dev/null; then
        # Agent 存在，更新
        local updated=$(jq --arg agent_id "$agent_id" --arg model "$model" \
            '(.agents.list[] | select(.id == $agent_id) | .model.primary) = $model' \
            "$OPENCLAW_CONFIG")
        echo "$updated" > "$OPENCLAW_CONFIG"
    else
        echo -e "${RED}Agent '$agent_id' not found${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Updated: Agent '$agent_id' primary model → $model${NC}"
    echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
}

# 添加 fallback 模型
add_fallback() {
    local agent_id="$1"
    local model="$2"

    # 备份
    backup_config "$OPENCLAW_CONFIG"

    local updated=$(jq --arg agent_id "$agent_id" --arg model "$model" \
        '(.agents.list[] | select(.id == $agent_id) | .model.fallbacks) += [$model] | unique' \
        "$OPENCLAW_CONFIG")
    echo "$updated" > "$OPENCLAW_CONFIG"

    echo -e "${GREEN}✓ Added fallback: Agent '$agent_id' → $model${NC}"
    echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
}

# 移除 fallback 模型
remove_fallback() {
    local agent_id="$1"
    local model="$2"

    # 备份
    backup_config "$OPENCLAW_CONFIG"

    local updated=$(jq --arg agent_id "$agent_id" --arg model "$model" \
        '(.agents.list[] | select(.id == $agent_id) | .model.fallbacks) -= [$model]' \
        "$OPENCLAW_CONFIG")
    echo "$updated" > "$OPENCLAW_CONFIG"

    echo -e "${GREEN}✓ Removed fallback: Agent '$agent_id' → $model${NC}"
    echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
}

# 更新 provider 的 API Key
update_provider_key() {
    local provider="$1"
    local api_key="$2"

    # 备份
    backup_config "$OPENCLAW_CONFIG"

    # 检查 provider 是否存在
    local provider_exists=$(jq -r ".models.providers | has(\"$provider\")" "$OPENCLAW_CONFIG")
    if [[ "$provider_exists" == "true" ]]; then
        # 更新全局配置
        local updated=$(jq --arg provider "$provider" --arg api_key "$api_key" \
            ".models.providers.$provider.apiKey = \$api_key" \
            "$OPENCLAW_CONFIG")
        echo "$updated" > "$OPENCLAW_CONFIG"
    else
        echo -e "${RED}Provider '$provider' not found in openclaw.json${NC}"
        echo -e "${YELLOW}Checking agent-specific configs...${NC}"

        # 检查所有 agent 的 models.json
        local found=false
        for agent_dir in "$AGENTS_DIR"/*/; do
            local agent_models="$agent_dir/agent/models.json"
            if [[ -f "$agent_models" ]]; then
                local provider_exists=$(jq -r ".providers | has(\"$provider\")" "$agent_models")
                if [[ "$provider_exists" == "true" ]]; then
                    local updated=$(jq --arg provider "$provider" --arg api_key "$api_key" \
                        ".providers.$provider.apiKey = \$api_key" \
                        "$agent_models")
                    echo "$updated" > "$agent_models"
                    echo -e "${GREEN}✓ Updated: Provider '$provider' in $(basename "$agent_dir")${NC}"
                    found=true
                fi
            fi
        done

        if [[ "$found" != "true" ]]; then
            echo -e "${RED}Provider '$provider' not found${NC}"
            exit 1
        fi

        echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
        return
    fi

    echo -e "${GREEN}✓ Updated: Provider '$provider' API key${NC}"
    echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
}

# 显示所有 providers
show_providers() {
    echo -e "\n${GREEN}=== Providers ===${NC}\n"
    echo -e "${BLUE}Global (openclaw.json):${NC}"
    jq -r '.models.providers | to_entries[] | "\(.key): \(.value.baseUrl)\n       API Key: \(.value.apiKey[0:20])..."' "$OPENCLAW_CONFIG"

    echo ""
    echo -e "${BLUE}Agent-Specific:${NC}"
    for agent_dir in "$AGENTS_DIR"/*/; do
        local agent_id=$(basename "$agent_dir")
        local agent_models="$agent_dir/agent/models.json"
        if [[ -f "$agent_models" ]]; then
            local providers=$(jq -r '.providers | keys[]' "$agent_models" 2>/dev/null)
            if [[ -n "$providers" ]]; then
                echo "$agent_id:"
                jq -r '.providers | to_entries[] | "  \(.key): \(.value.apiKey[0:20])..."' "$agent_models"
            fi
        fi
    done
    echo ""
}

# 添加新 provider
add_provider() {
    local provider_id="$1"
    local base_url="$2"
    local api_key="$3"
    local model_id="$4"

    if [[ -z "$provider_id" ]] || [[ -z "$base_url" ]] || [[ -z "$api_key" ]]; then
        echo -e "${RED}Usage: add-provider <provider-id> <base-url> <api-key> [model-id]${NC}"
        exit 1
    fi

    # 备份
    backup_config "$OPENCLAW_CONFIG"

    # 构建 provider 配置
    local provider_json="{
      \"baseUrl\": \"$base_url\",
      \"apiKey\": \"$api_key\",
      \"api\": \"openai-completions\",
      \"models\": []
    }"

    if [[ -n "$model_id" ]]; then
        provider_json=$(jq --arg model_id "$model_id" \
            '.models[0] = {"id": $model_id, "name": $model_id, "contextWindow": 128000, "maxTokens": 16000}' \
            <<< "$provider_json")
    fi

    # 添加到配置
    local updated=$(jq --arg provider_id "$provider_id" \
        ".models.providers.$provider_id = $provider_json" \
        "$OPENCLAW_CONFIG")
    echo "$updated" > "$OPENCLAW_CONFIG"

    echo -e "${GREEN}✓ Added provider: $provider_id${NC}"
    echo -e "${YELLOW}Run: openclaw gateway restart${NC}"
}

# 帮助信息
show_help() {
    cat << EOF
${GREEN}OpenClaw Agent Model Manager${NC}

Usage: $0 <command> [args]

Commands:
  list                        List all agents
  show <agent-id>             Show model configuration for an agent
  set-model <agent-id> <model>    Set primary model for agent
  add-fallback <agent-id> <model>  Add fallback model for agent
  remove-fallback <agent-id> <model>  Remove fallback model
  update-key <provider> <api-key>  Update API key for a provider
  providers                   Show all providers
  add-provider <id> <url> <key> [model]  Add new provider
  help                        Show this help

Examples:
  $0 list
  $0 show main
  $0 set-model main zai/glm-4.7
  $0 add-fallback main anthropic/claude-sonnet-4-5
  $0 update-key zai new-api-key-here
  $0 add-provider zai-emma https://api.example.com your-api-key glm-4.7

Model format: <provider>/<model-id>
  Examples: zai/glm-4.7, anthropic/claude-opus-4-5

EOF
}

# 主函数
main() {
    local command="$1"

    case "$command" in
        list)
            list_agents
            ;;
        show)
            show_agent_model "$2"
            ;;
        set-model)
            set_agent_model "$2" "$3"
            ;;
        add-fallback)
            add_fallback "$2" "$3"
            ;;
        remove-fallback)
            remove_fallback "$2" "$3"
            ;;
        update-key)
            update_provider_key "$2" "$3"
            ;;
        providers)
            show_providers
            ;;
        add-provider)
            add_provider "$2" "$3" "$4" "$5"
            ;;
        help|--help|-h|"")
            show_help
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
