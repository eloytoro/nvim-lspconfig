local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'spectral_ls'
local bin_name = 'spectral-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'yaml', 'json', 'yml' },
    root_dir = util.root_pattern('.spectral.yaml', '.spectral.yml'),
    single_file_support = true,
    settings = {
      enable = true,
      run = 'onType',
      validateLanguages = { 'yaml', 'json', 'yml' },
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/stoplightio/vscode-spectral/master/package.json',
    description = [[
https://github.com/luizcorreia/spectral-language-server
 `A flexible JSON/YAML linter for creating automated style guides, with baked in support for OpenAPI v2 & v3.`

`spectral-language-server` can be installed via `npm`:
```sh
npm i -g spectral-language-server
```
See [vscode-spectral](https://github.com/stoplightio/vscode-spectral#extension-settings) for configuration options.
]],
  },
}
