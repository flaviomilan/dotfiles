#!/bin/bash

# Script to clean Java LSP environment and restart fresh

echo "🧹 Cleaning Java LSP environment..."

# Stop any running Neovim processes
echo "Stopping Neovim processes..."
pkill -f nvim 2>/dev/null || true

# Clean JDTLS workspace and caches
echo "Cleaning JDTLS workspace..."
rm -rf ~/.local/share/nvim/site/java/workspace-root/
rm -rf ~/.cache/jdtls/
rm -rf ~/.cache/nvim/

# Clean LSP logs
echo "Cleaning LSP logs..."
rm -f ~/.local/share/nvim/lsp.log*

# Clean lazy.nvim state
echo "Cleaning Lazy plugin state..."
rm -rf ~/.local/share/nvim/lazy/nvim-java/
rm -rf ~/.local/share/nvim/lazy/spring-boot.nvim/ 2>/dev/null || true

echo "✅ Cleanup complete!"
echo ""
echo "📝 To test the fixes:"
echo "1. Start Neovim: nvim"
echo "2. Run: :Lazy sync"
echo "3. Open a Java file in a Spring Boot project"
echo "4. Check LSP status: :LspInfo"
echo "5. Check health: :checkhealth nvim-java"
echo ""
echo "🔍 If issues persist, check logs with: :LspLog"