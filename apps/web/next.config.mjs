/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Linting runs as a dedicated monorepo task (`npm run lint` / CI); Next 16 no
  // longer runs ESLint during `next build`. Type errors still fail the build.
};

export default nextConfig;
