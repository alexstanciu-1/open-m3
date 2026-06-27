export function createAdapter(options = {}) {
  const actions = options.actions ?? {};

  return {
    kind: 'pwa',

    getCapabilities() {
      return {
        target: 'pwa',
        engine: { mode: 'none', required: false },
        diagnostics: ['console', 'runtime-panel']
      };
    },

    async invoke(actionName, payload = {}) {
      if (actions[actionName]) {
        return actions[actionName](payload);
      }

      return {
        ok: false,
        action: actionName,
        payload,
        message: `No PWA action handler registered for ${actionName}`
      };
    },

    log(level, message, data = null) {
      const method = level === 'error' ? 'error' : level === 'warn' ? 'warn' : 'log';
      console[method]('[descriptivejs:pwa]', message, data ?? '');
    }
  };
}
