import { react } from '@careeros/config/eslint/react';

// Next.js plugin rules (eslint-config-next) are added alongside the real frontend
// shell in Story S1-6; the shared React preset is sufficient for the S1-1 scaffold.
export default [
  ...react,
  {
    ignores: ['.next/**', 'next-env.d.ts'],
  },
];
