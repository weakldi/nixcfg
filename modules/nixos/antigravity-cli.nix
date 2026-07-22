{ config, lib, ... }: {
  options.nixos.modules.antigravity-cli = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Google Antigravity CLI configuration and MCP setup.";
  };

  config.nixos.modules.antigravity-cli = { config, lib, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.gemini-cli
      pkgs.mcp-nixos
      pkgs.nodejs
    ];

    system.activationScripts.antigravityCliMcpConfig = let
      mcpConfig = {
        mcpServers = {
          nixos = {
            command = "mcp-nixos";
            args = [];
          };
          excel = {
            command = "npx";
            args = [ "-y" "@negokaz/excel-mcp-server" ];
          };
        };
      };
      mcpConfigJson = builtins.toJSON mcpConfig;
    in ''
      # For each normal user on the system, create the directories and configuration files
      ${lib.concatMapStringsSep "\n" (user: ''
        USER_HOME="${user.home}"
        if [ -d "$USER_HOME" ]; then
          # 1. Config for modern CLI path ~/.gemini/config/mcp_config.json
          mkdir -p "$USER_HOME/.gemini/config"
          echo '${mcpConfigJson}' > "$USER_HOME/.gemini/config/mcp_config.json.tmp"
          if ! cmp -s "$USER_HOME/.gemini/config/mcp_config.json" "$USER_HOME/.gemini/config/mcp_config.json.tmp"; then
            mv "$USER_HOME/.gemini/config/mcp_config.json.tmp" "$USER_HOME/.gemini/config/mcp_config.json"
            chown -R ${user.name}:${user.group} "$USER_HOME/.gemini/config"
          else
            rm "$USER_HOME/.gemini/config/mcp_config.json.tmp"
          fi

          # 2. Config for legacy/alternative CLI path ~/.gemini/antigravity-cli/mcp_config.json
          mkdir -p "$USER_HOME/.gemini/antigravity-cli"
          echo '${mcpConfigJson}' > "$USER_HOME/.gemini/antigravity-cli/mcp_config.json.tmp"
          if ! cmp -s "$USER_HOME/.gemini/antigravity-cli/mcp_config.json" "$USER_HOME/.gemini/antigravity-cli/mcp_config.json.tmp"; then
            mv "$USER_HOME/.gemini/antigravity-cli/mcp_config.json.tmp" "$USER_HOME/.gemini/antigravity-cli/mcp_config.json"
            chown -R ${user.name}:${user.group} "$USER_HOME/.gemini/antigravity-cli"
          else
            rm "$USER_HOME/.gemini/antigravity-cli/mcp_config.json.tmp"
          fi
        fi
      '') (lib.filter (u: u.isNormalUser) (lib.attrValues config.users.users))}
    '';
  };
}
