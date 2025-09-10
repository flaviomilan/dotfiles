#!/bin/bash

echo "🔄 Killing all JDTLS processes..."

# Kill all JDTLS related processes
pkill -f "org.eclipse.jdt.ls.core" 2>/dev/null
pkill -f "jdtls" 2>/dev/null  
pkill -f "java.*eclipse.*equinox.launcher" 2>/dev/null
pkill -f "spring-boot" 2>/dev/null

# Wait a moment for processes to terminate
sleep 2

# Check if any JDTLS processes are still running
if ps aux | grep -i "jdt\|eclipse.*launcher" | grep -v grep > /dev/null; then
    echo "⚠️  Some JDTLS processes may still be running:"
    ps aux | grep -i "jdt\|eclipse.*launcher" | grep -v grep
    echo ""
    echo "Attempting forceful termination..."
    pkill -9 -f "org.eclipse.jdt.ls.core" 2>/dev/null
    pkill -9 -f "java.*eclipse.*equinox.launcher" 2>/dev/null
    sleep 1
fi

# Final check
if ps aux | grep -i "jdt\|eclipse.*launcher" | grep -v grep > /dev/null; then
    echo "❌ Some JDTLS processes are still running. You may need to restart your terminal."
    ps aux | grep -i "jdt\|eclipse.*launcher" | grep -v grep
else
    echo "✅ All JDTLS processes have been terminated."
fi

echo ""
echo "🧹 Cleaning workspace and cache..."
rm -rf ~/.local/share/nvim/site/java/workspace-root/
rm -rf ~/.cache/jdtls/

echo "✅ Cleanup complete! You can now restart Neovim."