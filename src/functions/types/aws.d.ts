// src/types/aws.d.ts
// Extiende los tipos de Serverless para permitir nodejs22.x
import '@serverless/typescript';

declare module '@serverless/typescript' {
  // Añadimos nodejs22.x y un string abierto para futuros runtimes
  type AwsLambdaRuntime = 
    | 'nodejs14.x'
    | 'nodejs16.x'
    | 'nodejs18.x'
    | 'nodejs20.x'
    | 'nodejs22.x'
    | string;
}
