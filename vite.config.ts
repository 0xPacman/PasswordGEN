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
  // Removed incorrect global Content-Type header; Vite sets proper per-resource MIME types
  },
  preview: {
    host: true,
    port: 4173,
  // Same as above; rely on default headers
  }
})