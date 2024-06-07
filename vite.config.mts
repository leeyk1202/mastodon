/// <reference types="vitest" />

import fs from 'fs';
import path from 'path';

import { optimizeLodashImports } from '@optimize-lodash/rollup-plugin';
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import { analyzer } from 'vite-bundle-analyzer';
import RailsPlugin from 'vite-plugin-rails';
import svgr from 'vite-plugin-svgr';
import { configDefaults } from 'vitest/config';
import GithubActionsReporter from 'vitest-github-actions-reporter';

const sourceCodeDir = 'app/javascript';
const items = fs.readdirSync(sourceCodeDir);
const directories = items.filter((item) =>
  fs.lstatSync(path.join(sourceCodeDir, item)).isDirectory(),
);
const aliasesFromJavascriptRoot: Record<string, string> = {};
directories.forEach((directory) => {
  aliasesFromJavascriptRoot[directory] = path.resolve(
    __dirname,
    sourceCodeDir,
    directory,
  );
});

export default defineConfig({
  build: {
    commonjsOptions: { transformMixedEsModules: true },
    rollupOptions: {
      output: {
        chunkFileNames: (chunkInfo) => {
          if (
            chunkInfo.facadeModuleId?.match(
              /mastodon\/locales\/[a-zA-Z-]+\.json/,
            )
          ) {
            // put all locale files in `intl/`
            return `intl/[name]-[hash].js`;
          } else if (
            chunkInfo.facadeModuleId?.match(/node_modules\/@formatjs\//)
          ) {
            // use a custom name for formatjs polyfill files
            const name = chunkInfo.facadeModuleId.match(
              /node_modules\/@formatjs\/([^/]+)\//,
            );

            if (name?.[1]) return `intl/[name]-${name[1]}-[hash].js`;
          } else if (chunkInfo.name === 'index' && chunkInfo.facadeModuleId) {
            // Use a custom name for chunks, to avoid having too many of them called "index"
            const parts = chunkInfo.facadeModuleId.split('/');

            const parent = parts.at(-2);

            if (parent) return `${parent}-[name]-[hash].js`;
          }
          return `[name]-[hash].js`;
        },
      },
    },
  },
  resolve: {
    alias: {
      ...aliasesFromJavascriptRoot,
      // images: path.resolve(__dirname, './app/javascript/images'),
    },
  },
  plugins: [
    RailsPlugin(),
    react({
      include: ['**/*.jsx', '**/*.tsx'],
      babel: {
        plugins: [
          //  ['@babel/proposal-decorators', { legacy: true }],
          'formatjs',
          'preval',
          'transform-react-remove-prop-types',
        ],
      },
    }),
    svgr(),
    // @ts-expect-error the types for the plugin are not up-to-date
    optimizeLodashImports(),
    !!process.env.ANALYZE_BUNDLE_SIZE && analyzer({ analyzerMode: 'static' }),
  ],
  test: {
    environment: 'jsdom',
    include: [
      ...configDefaults.include,
      '**/__tests__/**/*.{js,mjs,cjs,ts,mts,cts,jsx,tsx}',
    ],
    exclude: [
      ...configDefaults.exclude,
      '**/node_modules/**',
      'vendor/**',
      'config/**',
      'log/**',
      'public/**',
      'tmp/**',
    ],
    reporters: process.env.GITHUB_ACTIONS
      ? ['default', new GithubActionsReporter()]
      : 'default',
    globals: true,
  },
});
