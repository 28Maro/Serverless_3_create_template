import type { Handler } from 'aws-lambda';

export const handler: Handler = async () => {
  const now = new Date().toISOString();
  console.log(`⏰ scheduledExample ejecutada ${now}`);
  return { statusCode: 200, body: JSON.stringify({ ok: true, at: now }) };
};
