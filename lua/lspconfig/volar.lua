local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js'))
    or ''
end

local server_name = 'volar'
local bin_name = 'volar-server'

-- https://github.com/johnsoncodehk/volar/blob/master/packages/shared/src/types.ts
local volar_init_options = {
  typescript = {
    serverPath = '',
  },
  languageFeatures = {
    -- not supported - https://github.com/neovim/neovim/pull/14122
    semanticTokens = false,
    references = true,
    definition = true,
    typeDefinition = true,
    callHierarchy = true,
    hover = true,
    rename = true,
    renameFileRefactoring = true,
    signatureHelp = true,
    codeAction = true,
    completion = {
      defaultTagNameCase = 'both',
      defaultAttrNameCase = 'kebabCase',
    },
    schemaRequestService = true,
    documentHighlight = true,
    documentLink = true,
    codeLens = true,
    diagnostics = true,
  },
  documentFeatures = {
    -- not supported - https://github.com/neovim/neovim/pull/13654
    documentColor = false,
    selectionRange = true,
    foldingRange = true,
    linkedEditingRange = true,
    documentSymbol = true,
    documentFormatting = {
      defaultPrintWidth = 100,
    },
  },
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'vue' },
    root_dir = util.root_pattern 'package.json',
    init_options = volar_init_options,
    on_new_config = function(new_config, new_root_dir)
      if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.serverPath == ''
      then
        new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/johnsoncodehk/volar/tree/master/packages/server

Volar language server for Vue

Volar can be installed via npm:

```sh
npm install -g @volar/server
```

Volar by default supports Vue 3 projects. Vue 2 projects need [additional configuration](https://github.com/johnsoncodehk/volar/blob/master/extensions/vscode-vue-language-features/README.md?plain=1#L28-L63).

**Take Over Mode**
Volar can serve as a language server for both Vue and TypeScript via [Take Over Mode](https://github.com/johnsoncodehk/volar/discussions/471).

To enable Take Over Mode, override the default filetypes in `setup{}` as follows:

```lua
require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
```

**Overriding the default TypeScript Server used by Volar**
The default config looks for TS in the local node_modules. The alternatives are:

- use a global TypeScript Server installation

```lua
require'lspconfig'.volar.setup{
  init_options = {
    typescript = {
      serverPath = '/path/to/.npm/lib/node_modules/typescript/lib/tsserverlib.js'
    }
  }
}
```

- use a global TypeScript Server installation if a local server is not found

```lua
local util = require 'lspconfig/util'

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)

  local local_tsserverlib = project_root ~= nil and util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js')
  local global_tsserverlib = '/home/[yourusernamehere]/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js'

  if local_tsserverlib and util.path.exists(local_tsserverlib) then
    return local_tsserverlib
  else
    return global_tsserverlib
  end
end

require'lspconfig'.volar.setup{
  config = {
    on_new_config = function(new_config, new_root_dir)
      new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
    end,
  }
}
```
    ]],
  },
}
