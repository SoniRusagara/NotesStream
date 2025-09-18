import { BedrockRuntimeClient, InvokeModelCommand } from "@aws-sdk/client-bedrock-runtime";

const REGION = process.env.BEDROCK_REGION || "eu-north-1";
const MODEL_ID = process.env.MODEL_ID || "anthropic.claude-3-5-sonnet-20240620-v1:0";
const DEV_TOKEN = process.env.DEV_TOKEN || "dev-token-123";

const br = new BedrockRuntimeClient({ region: REGION });

export const handler = async (event) => {
  try {
    // simple dev auth like your other routes
    const token = event.headers?.["x-access-token"] || event.headers?.["X-Access-Token"];
    if (token !== DEV_TOKEN) {
      return { statusCode: 401, body: JSON.stringify({ error: "unauthorized" }) };
    }

    const body = typeof event.body === "string" ? JSON.parse(event.body || "{}") : (event.body || {});
    const text = (body.text || "").toString().trim();
    if (!text) {
      return { statusCode: 400, body: JSON.stringify({ error: "missing text" }) };
    }

    // Anthropic "messages" format request
    const payload = {
      messages: [
        { role: "user", content: [{ type: "text", text: `Summarize this note in 1-3 concise sentences:\n\n${text}` }] }
      ],
      max_tokens: 200
    };

    const resp = await br.send(new InvokeModelCommand({
      modelId: MODEL_ID,
      contentType: "application/json",
      accept: "application/json",
      body: JSON.stringify(payload)
    }));

    const out = JSON.parse(new TextDecoder().decode(resp.body));
    const summary = out?.content?.[0]?.text ?? "";

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ summary })
    };
  } catch (e) {
    console.error("Summarize error:", e);
    return { statusCode: 500, body: JSON.stringify({ error: "internal" }) };
  }
};
