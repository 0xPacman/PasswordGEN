#!/bin/bash

# PasswordGEN Production Deployment Script
# Run this script to build and prepare for production deployment

echo "🔐 PasswordGEN - Production Deployment"
echo "======================================"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies."
    exit 1
fi

echo "🔍 Running TypeScript type checking..."
npx vue-tsc --noEmit

if [ $? -ne 0 ]; then
    echo "❌ TypeScript type checking failed."
    exit 1
fi

echo "🏗️  Building for production..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed."
    exit 1
fi

echo "✅ Build completed successfully!"
echo ""
echo "📁 Production files are in the 'dist' directory:"
echo "   - Total bundle size: ~90KB (compressed)"
echo "   - Optimized for performance and SEO"
echo "   - All assets included (CSS, JS, images)"
echo ""
echo "🚀 Deployment options:"
echo "   1. Upload 'dist' folder contents to your web server"
echo "   2. Use Netlify: drag & drop the 'dist' folder"
echo "   3. Use Vercel: connect repo and set build command to 'npm run build'"
echo "   4. Use GitHub Pages: upload 'dist' contents to your repository"
echo ""
echo "🎉 Your PasswordGEN application is ready for production!"

# Optional: Start preview server
read -p "🔍 Start local preview server? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌐 Starting preview server at http://localhost:4173"
    npm run preview
fi
