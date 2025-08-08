import type { AWS } from '@serverless/typescript';

const config: AWS = {
  service: 'sls-v3-node22-ts',
  frameworkVersion: '3',
  plugins: [
    'serverless-esbuild',
    'serverless-offline',
    'serverless-offline-scheduler'
  ],
  provider: {
    name: 'aws',
    runtime: 'nodejs22.x',
    architecture: 'arm64',
    region: 'us-east-1',
    stage: '${opt:stage, "dev"}',
    memorySize: 1024,
    timeout: 30,
    logRetentionInDays: 14,
    environment: {
      AWS_NODEJS_CONNECTION_REUSE_ENABLED: '1',
      NODE_OPTIONS: '--enable-source-maps --stack-trace-limit=1000',
      STAGE: '${self:provider.stage}'
    }
  },
  package: { individually: true, excludeDevDependencies: true },
  custom: {
    esbuild: {
      bundle: true,
      minify: false,
      sourcemap: true,
      platform: 'node',
      target: 'node22',
      external: ['@aws-sdk/*']
    },
    'serverless-offline': { httpPort: 3000 },
    'serverless-offline-scheduler': { enabled: true }
  },
  functions: {
    hello: {
      handler: 'src/functions/hello.handler',
      events: [{ httpApi: { path: '/hello', method: 'post' } }]
    },
    scheduledExample: {
      handler: 'src/functions/scheduled.handler',
      events: [
        {
          schedule: {
            rate: ['rate(5 minutes)'],
            enabled: true,
            name: '${self:service}-${self:provider.stage}-scheduledExample',
            description: 'Cada 5 minutos'
          }
        }
      ]
    }
  }
};

module.exports = config;
