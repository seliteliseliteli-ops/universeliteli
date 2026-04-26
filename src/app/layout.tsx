import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'РОЭНЦ — Общество Целителей Казахстана',
  description: 'Республиканское Общество Народных и Энергетических Целителей Казахстана',
  manifest: '/manifest.json',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ru" suppressHydrationWarning>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, viewport-fit=cover" />
        <meta name="theme-color" content="#B8860B" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="РОЭНЦ" />
        <link rel="apple-touch-icon" href="/icon-192.png" />
      </head>
      <body suppressHydrationWarning>{children}</body>
    </html>
  );
}
