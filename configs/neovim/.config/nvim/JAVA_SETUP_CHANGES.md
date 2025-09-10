# Java Development Setup Changes

## Alterações Implementadas

### 1. Substituído spring-boot.nvim por nvim-java
- **Arquivo alterado**: `lua/custom/plugins/spring.lua` → `lua/custom/plugins/nvim-java.lua`
- **Motivo**: nvim-java oferece melhor integração com Spring Boot tools e resolve problemas automaticamente
- **Dependências adicionadas**:
  - nvim-java/lua-async-await
  - nvim-java/nvim-java-refactor
  - nvim-java/nvim-java-core
  - nvim-java/nvim-java-test
  - nvim-java/nvim-java-dap

### 2. Configuração Java original desabilitada
- **Arquivo alterado**: `lua/custom/plugins/init.lua`
- **Motivo**: Evitar conflitos entre nvim-jdtls manual e nvim-java
- A configuração original foi mantida como backup em `java.lua.backup`

### 3. Melhorias para Multi-module Maven
- **Detecção de root directory aprimorada**: Agora procura por `.project`, `settings.xml` e pom.xml pai
- **Configurações adicionadas**:
  - Import automático para Maven e Gradle
  - Exclusões para diretórios desnecessários
  - Referências para JARs de dependências

### 4. Limpeza de workspace
- Removido `~/.local/share/nvim/site/java/workspace-root/`
- Removido `~/.cache/jdtls/`

## Próximos Passos

### Para aplicar as mudanças:

1. **Reiniciar Neovim completamente**
   ```bash
   # Feche todas as instâncias do Neovim
   pkill nvim
   ```

2. **Instalar novos plugins**
   ```vim
   :Lazy sync
   ```

3. **Verificar instalação**
   ```vim
   :checkhealth nvim-java
   ```

4. **Teste com projeto Spring Boot**
   - Abra um arquivo .java em um projeto Spring Boot
   - Verifique se o LSP inicia corretamente
   - Teste auto-complete e navegação

### Comandos úteis:

- `:JavaProfile` - Ver perfil Java ativo
- `:JavaTestCurrentClass` - Executar testes da classe atual
- `:JavaDebugCurrentClass` - Debug da classe atual

## Problemas Conhecidos e Soluções

### Se o LSP não iniciar:
1. Verificar logs: `:LspLog`
2. Reinstalar JDTLS: `:Mason` → `jdtls` → `X` → `i`
3. Limpar cache: `rm -rf ~/.cache/nvim/`

### Para projetos multi-module:
- Certifique-se de abrir o Neovim na raiz do projeto (onde está o pom.xml principal)
- Use `:LspRestart` se mudou entre módulos

### Se Spring Boot tools não funcionar:
- Verifique se está disponível: `:Mason`
- Alternativamente, use as funcionalidades básicas do JDTLS

## Correções de Erros LSP Implementadas (2025-09-10)

### Erros Corrigidos:

#### 1. **Warnings do Java 21+ sobre métodos deprecated**
- **Arquivo criado**: `lua/custom/java21-config.lua`
- **Solução**: Adicionadas flags JVM específicas:
  - `--add-opens=java.base/java.lang=ALL-UNNAMED`
  - `--enable-native-access=ALL-UNNAMED`
  - `-XX:+IgnoreUnrecognizedVMOptions`

#### 2. **Problemas de bundle loading do Spring Boot Tools**
- **Arquivo atualizado**: `lua/custom/plugins/nvim-java.lua`
- **Solução**: Configuração inteligente de bundles que verifica disponibilidade
- **Bundles filtrados**: Excluídos JARs problemáticos (jacocoagent, com.microsoft.java.test.runner-jar-with-dependencies)

#### 3. **Comando `_java.reloadBundles.command` não suportado**
- **Arquivo criado**: `lua/custom/plugins/java-handlers.lua`
- **Solução**: Handlers customizados para comandos não suportados
- **Capabilities**: Desabilitadas capacidades que causam warnings desnecessários

#### 4. **Configurações Java 21+ compatibility**
- **Otimizações de performance**: G1GC, StringDeduplication
- **Variáveis de ambiente**: JAVA_HOME e JAVA_TOOL_OPTIONS configuradas automaticamente
- **Configuração de LSP**: Log level ajustado para ERROR para reduzir ruído

### Arquivos Criados/Modificados:

- ✅ `lua/custom/plugins/nvim-java.lua` - Configuração principal atualizada
- ✅ `lua/custom/utils/java-handlers.lua` - Handlers customizados para LSP
- ✅ `lua/custom/utils/java21-config.lua` - Configurações específicas Java 21+
- ✅ `lua/custom/utils/java.lua.backup` - Backup da configuração original
- ✅ `lua/custom/utils/lsp-emergency-fix.lua` - Correção de emergência para LSP
- ✅ `lua/custom/utils/lsp-client-fix.lua` - Correções universais para clientes LSP
- ✅ `scripts/java-cleanup.sh` - Script de limpeza do ambiente
- ✅ `scripts/test-config.sh` - Script de teste da configuração
- ✅ `scripts/test-groovy-lsp.sh` - Script de teste específico para Groovy LSP

### Scripts Disponíveis:

**Limpeza completa do ambiente:**
```bash
./scripts/java-cleanup.sh
```

**Teste da configuração:**
```bash
./scripts/test-config.sh
```

**Limpar processos JDTLS duplicados:**
```bash
./scripts/kill-jdtls.sh
```

**Teste específico para correções LSP:**
```bash
./scripts/test-groovy-lsp.sh
```

#### Comandos adicionais disponíveis no Neovim:
- `:LspDiagnose` - Diagnóstico detalhado de todos os clientes LSP
- `:LspClientRestart` - Reinicia todos os clientes LSP
- `:GroovyLspRestart` - Reinicia especificamente o LSP Groovy

### Correção do Erro "Invalid plugin spec" (2025-09-10):

#### Problema Identificado:
- O Lazy.nvim interpretava arquivos utilitários como especificações de plugin
- Causava erro: `Invalid plugin spec { get_capabilities = <function 1>, setup = <function 2> }`

#### Solução Implementada:
- ✅ Movidos arquivos utilitários para `lua/custom/utils/`
- ✅ Separados arquivos de plugin de arquivos utilitários
- ✅ Atualizadas todas as referências nos imports
- ✅ Criado script de teste para verificar configuração

### Correção de Múltiplos Servidores JDTLS (2025-09-10):

#### Problema Identificado:
- Erro: `Multiple LSP clients found that support vscode.java.checkProjectSettings`
- Conflito entre nvim-java (que gerencia JDTLS automaticamente) e configuração manual lspconfig.jdtls
- Dois processos JDTLS executando simultaneamente

#### Solução Implementada:
- ✅ Removida configuração redundante do `require('lspconfig').jdtls.setup()`
- ✅ Mantida apenas configuração através do nvim-java
- ✅ Migradas configurações JDTLS para dentro da configuração nvim-java
- ✅ Criado script `scripts/kill-jdtls.sh` para limpar processos duplicados
- ✅ Todos os settings mantidos (maven, gradle, multi-module, etc.)

### Correção de Erro LSP Groovy (2025-09-10):

#### Problema Identificado:
- Erro: `[lspconfig] unhandled error: attempt to call field 'request' (a nil value)`
- Cliente LSP Groovy não inicializava corretamente
- Falhas ao acessar métodos do cliente LSP em arquivos .groovy

#### Solução Implementada:
- ✅ **Correção de Emergência**: `lua/custom/utils/lsp-emergency-fix.lua` - Intercepta erros na raiz
- ✅ **Correção Universal**: `lua/custom/utils/lsp-client-fix.lua` - Wrapper seguro para todos os clientes LSP
- ✅ **Error Handler Global**: Intercepta especificamente erro `client.lua:544`
- ✅ **Monkey Patching**: Override de funções core do vim.lsp para prevenir crashes
- ✅ **Proteção de vim.lsp.buf**: Todas as funções protegidas com pcall
- ✅ **Validação de Cliente**: Verificações robustas antes de qualquer chamada LSP
- ✅ **Configuração melhorada do groovyls** com Java 21+ flags
- ✅ **Comandos úteis**: `:GroovyLspRestart`, `:LspClientRestart`, `:LspDiagnose`
- ✅ **Detecção prioritária** de projetos Gradle sobre Maven

## Reverter Mudanças

Se precisar voltar à configuração anterior:

1. Restaurar configuração original:
   ```bash
   cp lua/custom/plugins/java.lua.backup lua/custom/plugins/java.lua
   ```

2. Remover novos arquivos:
   ```bash
   rm lua/custom/plugins/java-handlers.lua
   rm lua/custom/java21-config.lua
   ```

3. Editar `lua/custom/plugins/init.lua`:
   - Descomentar `require('custom.plugins.java')`
   - Comentar `require('custom.plugins.nvim-java')`

4. Reiniciar Neovim e executar `:Lazy sync`