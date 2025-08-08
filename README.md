# Serverless_3_create_template

Plantilla base para proyectos **Serverless Framework v3** con:
- **Node.js 22**
- **TypeScript**
- **serverless-esbuild**
- **serverless-offline**
- **serverless-offline-scheduler** para probar eventos programados en local

## 🚀 Uso como template

### 1) Crear proyecto desde este template
```bash
npx degit TU_USUARIO/Serverless_3_create_template mi-proyecto
cd mi-proyecto
npm install
```

### 2) Ejecutar en local
```bash
npm run dev
```

**Prueba HTTP**
```bash
curl -X POST http://localhost:3000/hello     -H "content-type: application/json"     -d '{"name":"Omar"}'
```

**Scheduler**
- Deja corriendo `npm run dev` y verás logs cada 5 minutos.
- O ejecuta manualmente:
```bash
npm run invoke:local:scheduled
```

## 🧩 Notas
- Si tienes instalado Serverless v4 de forma global, usa los scripts con `npx serverless@3 ...` como ya viene en `package.json`.
- El runtime `nodejs22.x` funciona sin problema en v3.
