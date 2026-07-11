// Shared ESLint flat config for all CareerOS TypeScript workspaces.
// Framework-agnostic base: JS recommended + typescript-eslint (recommended +
// stylistic), with Prettier compatibility last so formatting is owned by Prettier.
// Type-checked rule sets are intentionally not enabled here; they can be layered
// in per package (with `parserOptions.projectService`) when needed.
import js from '@eslint/js';
import prettier from 'eslint-config-prettier';
import globals from 'globals';
import tseslint from 'typescript-eslint';

/** @type {import('typescript-eslint').ConfigArray} */
export const base = tseslint.config(
  {
    ignores: ['**/dist/**', '**/.next/**', '**/coverage/**', '**/node_modules/**'],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  ...tseslint.configs.stylistic,
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: { ...globals.node },
    },
    rules: {
      // Type safety is non-negotiable (docs 16 §8): no `any`, explicit boundaries.
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],
      'no-console': ['warn', { allow: ['warn', 'error'] }],
    },
  },
  prettier,
);

export default base;
