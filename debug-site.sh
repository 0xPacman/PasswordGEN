#!/bin/bash

echo "🔍 Debugging password.0xpacman.com"
echo "=================================="
echo ""

SITE_URL="https://password.0xpacman.com"

echo "1. Testing main page response..."
echo "--------------------------------"
curl -s -I "$SITE_URL" | head -10
echo ""

echo "2. Testing JavaScript file MIME type..."
echo "----------------------------------------"
# First, let's get the actual JS filename from the HTML
JS_FILE=$(curl -s "$SITE_URL" | grep -o 'src="/assets/[^"]*\.js"' | head -1 | sed 's/src="//g' | sed 's/"//g')
echo "Found JS file: $JS_FILE"

if [ ! -z "$JS_FILE" ]; then
    echo "Testing MIME type for: $SITE_URL$JS_FILE"
    curl -s -I "$SITE_URL$JS_FILE" | grep -i "content-type"
    echo ""
    
    echo "3. Testing if .htaccess is working..."
    echo "-------------------------------------"
    # Test if .htaccess security headers are present
    echo "Checking for security headers..."
    curl -s -I "$SITE_URL" | grep -i "x-frame-options\|x-content-type-options\|x-xss-protection"
    echo ""
else
    echo "❌ Could not find JavaScript file in HTML"
fi

echo "4. Testing if TypeScript files are accessible (should be blocked)..."
echo "--------------------------------------------------------------------"
curl -s -I "$SITE_URL/src/main.ts" | head -5
echo ""

echo "5. Testing .htaccess file accessibility..."
echo "------------------------------------------"
curl -s -I "$SITE_URL/.htaccess" | head -5
echo ""

echo "6. Full page download test..."
echo "-----------------------------"
PAGE_SIZE=$(curl -s "$SITE_URL" | wc -c)
echo "Page size: $PAGE_SIZE bytes"
if [ "$PAGE_SIZE" -lt 1000 ]; then
    echo "⚠️  WARNING: Page seems too small, might be an error page"
    echo "First 500 chars of response:"
    curl -s "$SITE_URL" | head -c 500
fi
echo ""
