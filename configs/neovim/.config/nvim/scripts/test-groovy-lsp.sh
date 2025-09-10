#!/bin/bash

echo "🧪 Testing LSP client fixes configuration..."

# Test emergency LSP fixes loading
echo "Testing emergency LSP fixes loading..."
if nvim --headless -c "lua require('custom.utils.lsp-emergency-fix'); print('Emergency LSP fixes OK')" -c "qall" 2>/dev/null; then
    echo "✅ Emergency LSP fixes load successfully"
else
    echo "❌ Emergency LSP fixes failed to load"
    exit 1
fi

# Test universal LSP client fixes loading
echo "Testing universal LSP client fixes loading..."
if nvim --headless -c "lua require('custom.utils.lsp-client-fix'); print('LSP client fixes OK')" -c "qall" 2>/dev/null; then
    echo "✅ LSP client fixes load successfully"
else
    echo "❌ LSP client fixes failed to load"
    exit 1
fi

# Create a test Groovy file
echo "Creating test Groovy file..."
cat > /tmp/test.groovy << 'EOF'
class TestClass {
    String name
    
    def sayHello() {
        println "Hello, ${name}!"
    }
    
    static void main(String[] args) {
        def test = new TestClass(name: "World")
        test.sayHello()
    }
}
EOF

echo "✅ Test Groovy file created at /tmp/test.groovy"

echo ""
echo "🎯 Manual testing steps:"
echo "1. Open Neovim: nvim /tmp/test.groovy"
echo "2. Check LSP status: :LspInfo"
echo "3. Run diagnostics: :LspDiagnose"
echo "4. Test features: hover over 'String', 'println', etc."
echo "5. If issues occur, run: :GroovyLspRestart or :LspClientRestart"
echo "6. Check logs: :LspLog"
echo ""
echo "💡 Expected behavior:"
echo "- No 'attempt to call field request (a nil value)' errors"
echo "- LSP clients should attach without crashes"
echo "- Emergency fixes should prevent any LSP-related crashes"
echo "- Basic syntax highlighting and validation should work"
echo ""
echo "Test preparation completed!"