# РОЭНЦ — Республиканское Общество Целителей

## Быстрый старт

```bash
npm install
npm run dev
```

## Деплой на Vercel

```bash
git init
git add .
git commit -m "ROENC app with Supabase"
git remote add origin https://github.com/seliteliseliteli-ops/YOUR-REPO.git
git branch -M main
git push -u origin main
```

В Vercel: Import → выбрать репо → Deploy.

## Supabase

Проект подключён к Supabase. Перед первым запуском выполните SQL скрипт `supabase-schema.sql` в Supabase → SQL Editor.
