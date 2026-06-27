import { sendWebviewMessage } from '../../webview-bridge.js';

export function createAdapter(options = {}) {
  const actions = options.actions ?? {};

  return {
    kind: 'simplecpp-webview',

    getCapabilities() {
      return {
        target: 'webview-win',
        engine: { mode: 'local', required: false },
        diagnostics: ['console', 'runtime-panel', 'host']
      };
    },

    async invoke(actionName, payload = {}) {
      if (actions[actionName]) {
        return actions[actionName](payload);
      }

      sendWebviewMessage({ type: 'runtime.action', action: actionName, payload });
      return {
        ok: true,
        action: actionName,
        payload,
        message: `sent ${actionName} to Simple C++ webview host`
      };
    },

    log(level, message, data = null) {
      const method = level === 'error' ? 'error' : level === 'warn' ? 'warn' : 'log';
      console[method]('[descriptivejs:simplecpp-webview]', message, data ?? '');
      sendWebviewMessage({ type: 'diagnostic', level, message, data });
    }
  };
}
