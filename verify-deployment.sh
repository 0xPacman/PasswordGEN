#!/bin/bash

echo "🔍 PasswordGEN Deployment Verification"
echo "======================================"
echo ""

# Check if dist directory exists
if [ ! -d "dist" ]; then
    echo "❌ ERROR: dist directory not found!"
    echo "   Run 'npm run build' first."
    exit 1
fi

echo "✅ dist directory found"

# Check for required files
required_files=("dist/index.html" "dist/.htaccess" "dist/assets")
for file in "${required_files[@]}"; do
    if [ -e "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ MISSING: $file"
    fi
done

echo ""
echo "📁 Files to upload to password.0xpacman.com:"
echo "---------------------------------------------"
ls -la dist/
echo ""

echo "🚨 IMPORTANT DEPLOYMENT STEPS:"
echo "1. Upload ALL contents of the 'dist' folder to your web root"
echo "2. Make sure .htaccess file is uploaded (it's hidden!)"
echo "3. Verify the server serves .js files as 'application/javascript'"
echo "4. Clear browser cache completely before testing"
echo ""

echo "🔧 If still getting MIME type errors:"
echo "- Check if .htaccess is actually uploaded and working"
echo "- Verify your hosting supports .htaccess files"
echo "- Contact your hosting provider about MIME type configuration"
