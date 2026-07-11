// React/Next-oriented ESLint preset: extends the base with browser globals.
// Framework plugin rules (eslint-config-next) are composed in apps/web, which
// owns the Next.js dependency. Kept minimal for S1-1; expanded with the real
// frontend shell in S1-6.
import globals from 'globals';

import { base } from './base.mjs';

/** @type {import('typescript-eslint').ConfigArray} */
export const react = [
  ...base,
  {
    languageOptions: {
      globals: { ...globals.browser },
    },
  },
];

export default react;
