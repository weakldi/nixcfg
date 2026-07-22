{ config, lib, ... }: {
  options.nixos.modules.antigravity = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Google Antigravity IDE configuration and MCP setup.";
  };

  config.nixos.modules.antigravity = { config, lib, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.antigravity
      pkgs.mcp-nixos
      pkgs.nodejs
    ];

    system.activationScripts.antigravityMcpConfig = let
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
      # For each normal user on the system, create the directory and configuration file
      ${lib.concatMapStringsSep "\n" (user: ''
        USER_HOME="${user.home}"
        if [ -d "$USER_HOME" ]; then
          mkdir -p "$USER_HOME/.gemini/antigravity"
          # Write the config file only if it's different or doesn't exist
          echo '${mcpConfigJson}' > "$USER_HOME/.gemini/antigravity/mcp_config.json.tmp"
          if ! cmp -s "$USER_HOME/.gemini/antigravity/mcp_config.json" "$USER_HOME/.gemini/antigravity/mcp_config.json.tmp"; then
            mv "$USER_HOME/.gemini/antigravity/mcp_config.json.tmp" "$USER_HOME/.gemini/antigravity/mcp_config.json"
            chown -R ${user.name}:${user.group} "$USER_HOME/.gemini/antigravity"
          else
            rm "$USER_HOME/.gemini/antigravity/mcp_config.json.tmp"
          fi
        fi
      '') (lib.filter (u: u.isNormalUser) (lib.attrValues config.users.users))}
    '';
  };
}
