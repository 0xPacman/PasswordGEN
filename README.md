<p align="center">
  <img src="https://github.com/0xPacman/PasswordGEN/blob/main/PsGEN.png" width="80%" height="80%" alt="PasswordGEN logo">
</p>

> "Stay safe, internet is not as localhost boi".

# PasswordGEN

GigaChad Password Generator - Now available as both a shell script and a modern web application!

## 🌐 Web Application

A modern, responsive Vue.js password generator with a beautiful dark theme and real-time password strength indicators.

### Features:
- 🔒 **100% Client-Side Security** - All passwords are generated locally in your browser
- 🎨 **Modern Dark UI** - Beautiful gradient design with smooth animations
- ⚡ **Real-time Generation** - Instant password creation with customizable options
- 💪 **Strength Indicator** - Visual feedback on password security level
- 📋 **One-Click Copy** - Easy clipboard integration
- 📱 **Fully Responsive** - Works perfectly on desktop and mobile
- ⚙️ **Customizable Options**:
  - Password length (8-128 characters)
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special symbols (!@#$%^&*)

### Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Production Deployment

1. **Build the application:**
   ```bash
   npm run build
   ```

2. **Deploy the `dist/` folder** to any static hosting service:
   - **Netlify**: Drag and drop the `dist` folder
   - **Vercel**: Connect your repo and set build command to `npm run build`
   - **GitHub Pages**: Upload `dist` contents to your repository
   - **Any web server**: Copy `dist` contents to your web root

### Technology Stack
- Vue.js 3 with Composition API
- TypeScript for type safety
- Tailwind CSS for styling
- Vite for fast builds and development

## 🔥 Shell Script Version

### Prerequisites 
- pbcopy (MacOS)
- xclip (Linux/BSD)
- curl

### Usage: 
You can run it using `curl`:  
`bash -c "$(curl -fsSL https://raw.githubusercontent.com/0xPacman/PasswordGEN/main/PasswordGEN.sh)"`

### Features: 
- this GigaChad password will never generate a weak password, only strong and secure ones
- the password will be copied to your clipboard directly to make life easier for you.
