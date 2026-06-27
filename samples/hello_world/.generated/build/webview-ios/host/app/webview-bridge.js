export function sendWebviewMessage(message) {
  const payload = JSON.stringify(message);
  if (globalThis.simplecpp?.postMessage) {
    return globalThis.simplecpp.postMessage(payload);
  }
  if (globalThis.chrome?.webview?.postMessage) {
    return globalThis.chrome.webview.postMessage(payload);
  }
  console.warn('[descriptivejs:webview] no native bridge available', message);
  return null;
}
