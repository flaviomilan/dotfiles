# Configuração Completa do Neovim para Desenvolvimento Java/Kotlin

Este documento explica como configurar seu Neovim para ter uma experiência de desenvolvimento Java/Kotlin similar ao IntelliJ IDEA da JetBrains.

## Pré-requisitos

### 1. Instalar Java Development Kit (JDK)

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk openjdk-11-jdk

# Verificar instalação
java --version
javac --version
```

### 2. Instalar Ferramentas de Build

```bash
# Maven
sudo apt install maven

# Gradle (opcional - geralmente vem com o projeto)
wget https://services.gradle.org/distributions/gradle-8.5-bin.zip
sudo unzip -d /opt/gradle gradle-8.5-bin.zip
export PATH=$PATH:/opt/gradle/gradle-8.5/bin
```

### 3. Instalar Kotlin (se necessário)

```bash
# Via SDKMAN (recomendado)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install kotlin
```

### 4. Instalar Ferramentas de Formatação

```bash
# Instalar ferramentas via Mason (será feito automaticamente)
# Ou instalar manualmente:

# Google Java Format
wget https://github.com/google/google-java-format/releases/download/v1.19.2/google-java-format-1.19.2-all-deps.jar
sudo mv google-java-format-1.19.2-all-deps.jar /usr/local/bin/google-java-format.jar

# KtLint para Kotlin
curl -sSLO https://github.com/pinterest/ktlint/releases/download/1.0.1/ktlint && chmod a+x ktlint && sudo mv ktlint /usr/local/bin/

# npm-groovy-lint para Groovy (via npm)
npm install -g npm-groovy-lint
```

## Recursos Configurados

### 🔧 Language Server Protocol (LSP)
- **Eclipse JDT Language Server** - Análise de código Java completa
- **Kotlin Language Server** - Suporte nativo ao Kotlin
- **Groovy Language Server** - Suporte completo ao Groovy e Gradle DSL
- **Gradle Language Server** - Suporte aos scripts de build Gradle
- **XML Language Server** - Para arquivos Maven pom.xml

### 🐛 Debugging (DAP - Debug Adapter Protocol)
- **Java Debug Adapter** - Debugging completo para Java
- **Breakpoints condicionais** - Similar ao IntelliJ
- **Hot code replace** - Mudanças de código em tempo real
- **Interface visual** - Painel de debugging com scopes, variables, etc.

### 🧪 Testing Framework
- **Neotest** - Execução e visualização de testes
- **Test Coverage** - Visualização de cobertura de código
- **JUnit Integration** - Suporte completo ao JUnit
- **Test Runner** - Execute testes individuais ou em classes

### 🔍 Navigation & Search (Similar ao IntelliJ Navigate)
- **Telescope** - Busca fuzzy de arquivos, símbolos, referências
- **Aerial** - Estrutura do arquivo (Structure View do IntelliJ)
- **Trouble** - Lista de problemas/erros (Problems View)
- **Symbol Navigation** - Go to Declaration, Implementation, etc.

### ♻️ Refactoring
- **Extract Method/Variable** - Refatorações automáticas
- **Inline Variable** - Inline refactoring
- **Rename Symbol** - Renomeação inteligente
- **Structural Search & Replace** - Similar ao SSR do IntelliJ

### 🎨 Code Formatting
- **Google Java Format** - Formatação automática Java
- **KtLint** - Formatação e linting Kotlin
- **npm-groovy-lint** - Formatação e linting Groovy
- **Format on Save** - Formatação automática ao salvar

### 🔮 AI-Powered Completion
- **Intelligent Code Completion** - Baseado em contexto
- **Snippets** - Snippets pré-configurados para Java/Kotlin
- **GitHub Copilot** - IA para geração de código
- **LSP-based suggestions** - Sugestões do language server

## Keymaps Principais

### Navigation (Similar ao IntelliJ)
- `<leader>ff` - Buscar arquivos (Ctrl+Shift+N no IntelliJ)
- `<leader>fg` - Buscar no projeto (Ctrl+Shift+F)
- `<leader>fs` - Símbolos do documento (Ctrl+F12)
- `<leader>fw` - Símbolos do workspace (Ctrl+Alt+Shift+N)
- `gd` - Go to Definition (Ctrl+B)
- `gi` - Go to Implementation (Ctrl+Alt+B)
- `gr` - Find Usages (Alt+F7)

### Debugging
- `<F5>` - Start/Continue Debug
- `<F10>` - Step Over
- `<F11>` - Step Into
- `<F12>` - Step Out
- `<leader>b` - Toggle Breakpoint
- `<leader>B` - Conditional Breakpoint

### Testing
- `<leader>tn` - Run Nearest Test
- `<leader>tf` - Run File Tests
- `<leader>ta` - Run All Tests
- `<leader>td` - Debug Nearest Test
- `<leader>ts` - Test Summary
- `<leader>to` - Test Output

### Refactoring
- `<leader>rn` - Rename Symbol (Shift+F6)
- `<leader>re` - Extract Function (Ctrl+Alt+M)
- `<leader>rv` - Extract Variable (Ctrl+Alt+V)
- `<leader>ri` - Inline Variable (Ctrl+Alt+N)
- `<leader>sr` - Structural Search & Replace

### Code Actions
- `<space>ca` - Code Actions (Alt+Enter)
- `<space>f` - Format Document (Ctrl+Alt+L)
- `<leader>oi` - Organize Imports (Ctrl+Alt+O)

### Error Navigation
- `<leader>xx` - Toggle Problems View
- `<leader>xd` - Document Diagnostics
- `<leader>xw` - Workspace Diagnostics

## Estrutura de Arquivos

```
~/.config/nvim/
├── init.lua                          # Configuração principal
├── lua/
│   ├── custom/plugins/
│   │   ├── init.lua                  # Manifest dos plugins
│   │   ├── java.lua                  # Configuração Java + JDTLS
│   │   ├── kotlin.lua                # Configuração Kotlin
│   │   ├── mason.lua                 # Gerenciador de LSP/DAP
│   │   ├── nvim-lspconfig.lua        # Configuração LSP
│   │   ├── project-navigation.lua    # Telescope + Trouble + Aerial  
│   │   ├── testing.lua               # Neotest + Coverage
│   │   ├── refactoring.lua           # Refactoring tools
│   │   ├── ai-completion.lua         # Completion + Snippets
│   │   ├── spring.lua                # Spring Boot support
│   │   └── schemastore.lua           # JSON/YAML schemas
│   └── kickstart/                    # Configurações base
├── lazy-lock.json                    # Lock file dos plugins
└── JVM_DEVELOPMENT_SETUP.md          # Este arquivo
```

## Primeiro Uso

1. **Instalar Plugins**: Ao abrir o Neovim, os plugins serão instalados automaticamente via Lazy.nvim

2. **Instalar Language Servers**: Execute `:Mason` e instale os servers necessários:
   - jdtls (Java)
   - kotlin_language_server
   - groovyls (Groovy)
   - gradle_ls
   - lemminx (XML)
   - google-java-format
   - ktlint
   - npm-groovy-lint

3. **Verificar Health**: Execute `:checkhealth` para verificar se tudo está funcionando

4. **Configurar Java Home**: Se necessário, ajuste o caminho do Java em `java.lua`:
   ```lua
   runtimes = {
     {
       name = 'JavaSE-17',
       path = '/usr/lib/jvm/java-17-openjdk/', -- Ajustar se necessário
     },
   }
   ```

## Troubleshooting

### JDTLS não inicia
- Verifique se o Java está instalado: `java --version`
- Verifique se o JDTLS está instalado via Mason: `:Mason`
- Veja os logs: `:LspLog`

### Groovy LSP não funciona
- Certifique-se que está em um projeto Git: `git init` se necessário
- Verifique se tem `build.gradle` ou `Jenkinsfile` no projeto
- Execute `:LspInfo` para verificar se o groovyls está anexado
- Verifique se o language server está instalado: `:Mason`

### Formatação não funciona
- Instale os formatadores via Mason
- Para Groovy: `npm install -g npm-groovy-lint`
- Verifique se estão no PATH
- Execute `:ConformInfo` para debug

### Testes não são reconhecidos
- Certifique-se que o projeto usa JUnit 5 ou TestNG
- Verifique se o projeto tem arquivos de build (pom.xml ou build.gradle)

## Comparação com IntelliJ IDEA

| Recurso IntelliJ | Equivalente Neovim | Plugin |
|---|---|---|
| Project View | Neo-tree / Oil | neo-tree.nvim |
| Navigate → Class | `<leader>ff` | telescope.nvim |
| Navigate → Symbol | `<leader>fs` | telescope.nvim |
| Find Usages | `gr` | telescope.nvim |
| Problems View | `<leader>xx` | trouble.nvim |
| Structure View | `<leader>a` | aerial.nvim |
| Debug Tool Window | Auto-opens | nvim-dap-ui |
| Test Runner | `<leader>tn/tf/ta` | neotest |
| Refactor → Rename | `<leader>rn` | inc-rename.nvim |
| Refactor → Extract | `<leader>re/rv` | refactoring.nvim |
| Code Generation | Snippets | LuaSnip |
| Smart Completion | LSP + nvim-cmp | nvim-cmp |
| Format Code | `<space>f` | conform.nvim |
| Organize Imports | `<leader>oi` | nvim-jdtls |

Este setup fornece uma experiência de desenvolvimento Java/Kotlin muito próxima ao IntelliJ IDEA, com todas as funcionalidades principais disponíveis!