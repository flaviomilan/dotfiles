#!/bin/bash

echo "🧪 Testing Neovim Java configuration..."

# Test basic configuration loading
echo "Testing basic configuration loading..."
if nvim --headless -c "lua print('Config test passed')" -c "qall" 2>/dev/null; then
    echo "✅ Basic configuration loads successfully"
else
    echo "❌ Configuration loading failed"
    exit 1
fi

# Test Java utilities loading
echo "Testing Java utilities..."
if nvim --headless -c "lua require('custom.utils.java21-config'); print('Java21 config OK')" -c "qall" 2>/dev/null; then
    echo "✅ Java 21 configuration loads successfully"
else
    echo "❌ Java 21 configuration failed to load"
fi

if nvim --headless -c "lua require('custom.utils.java-handlers'); print('Java handlers OK')" -c "qall" 2>/dev/null; then
    echo "✅ Java handlers load successfully"
else
    echo "❌ Java handlers failed to load"
fi

echo ""
echo "🎯 Next steps:"
echo "1. Start Neovim: nvim"
echo "2. Run: :Lazy sync"
echo "3. Open a Java file to test LSP functionality"
echo ""
echo "Test completed!"