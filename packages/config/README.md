# @careeros/config

Shared engineering configuration for the CareerOS monorepo. Centralizes ESLint so
every TypeScript workspace lints identically (DRY).

## Exports

| Import                          | Purpose                                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------------------- |
| `@careeros/config/eslint/base`  | Framework-agnostic flat config (JS + typescript-eslint strict/stylistic + Prettier compat). |
| `@careeros/config/eslint/react` | Base + browser globals for React/Next apps.                                                 |

## Usage

```js
// eslint.config.mjs in a package
import { base } from '@careeros/config/eslint/base';
export default base;
```

Prettier is configured once at the repo root (`.prettierrc.json`); TypeScript extends
the repo root `tsconfig.base.json`. This package intentionally owns **ESLint only**.
