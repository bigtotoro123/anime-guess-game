import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0', // 允许局域网访问
    port: 5173,
    allowedHosts: [
      'frp-man.com']  // 添加你的公网域名
     // 保留本地访问
    
  }
})
