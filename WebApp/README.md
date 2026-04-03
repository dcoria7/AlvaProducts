# ClickLocal – Web App

Plataforma para descubrir negocios locales, a puerta cerrada y ambulantes cerca de ti.

## Stack

- **Next.js 16** (App Router, TypeScript)
- **Tailwind CSS**
- **Firebase** — Auth, Firestore, Storage (`clicklocal-app`)

## Setup local

1. Copia las variables de entorno:
   ```bash
   cp .env.example .env.local
   ```
2. Llena los valores de Firebase en `.env.local`
3. Instala dependencias:
   ```bash
   npm install
   ```
4. Corre el servidor de desarrollo:
   ```bash
   npm run dev
   ```

## Estructura

```
src/
├── app/          — rutas y páginas (Next.js App Router)
├── components/   — componentes reutilizables
├── hooks/        — useAuth, useGeolocation
├── lib/          — cliente Firebase
├── services/     — lógica de Firestore (venues, auth)
└── types/        — tipos TypeScript del modelo de datos
```

## Firebase

Proyecto: `clicklocal-app`

Aplicar reglas de Firestore:
- Copiar el contenido de `firestore.rules` en Firebase Console → Firestore → Reglas
