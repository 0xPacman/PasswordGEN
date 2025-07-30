import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: '/',
  build: {
    // Optimize for production
    minify: 'terser',
    sourcemap: false,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue']
        }
      }
    }
  },
  // PWA-like optimization
  server: {
    host: true,
    port: 5173,
    headers: {
      'Content-Type': 'application/javascript'
    }
  },
  preview: {
    host: true,
    port: 4173,
    headers: {
      'Content-Type': 'application/javascript'
    }
  }
})