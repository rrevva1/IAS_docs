import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';

const rootDir = path.resolve(__dirname, 'spa');
const outDir = path.resolve(__dirname, 'web/spa');

export default defineConfig({
  root: rootDir,
  plugins: [vue()],
  base: '/spa/',
  build: {
    outDir,
    emptyOutDir: true,
    manifest: true,
    rollupOptions: {
      input: path.resolve(rootDir, 'index.html'),
    },
  },
  server: {
    port: 5173,
    strictPort: true,
  },
});
