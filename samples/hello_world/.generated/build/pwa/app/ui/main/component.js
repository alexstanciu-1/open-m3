import { createRuntime } from '../../runtime/descriptivejs/runtime.js';
import { createAdapter } from '../../runtime/adapters/pwa.js';
import ui from './ui.ir.js';

const adapter = createAdapter({
  actions: {
    'hello.ping': async () => ({
      ok: true,
      action: 'hello.ping',
      message: 'pong from the pwa adapter'
    })
  }
});

const runtime = createRuntime({ adapter, diagnostics: true });

const appNode = document.getElementById('app');
runtime.mount(appNode, ui);

runtime.dispatch('hello.ping', { source: 'startup-smoke' }).then(() => {
  appNode.dataset.dpSmoke = 'ok';
  document.documentElement.dataset.dpSmoke = 'ok';
});

globalThis.descriptiveHelloWorld = runtime;
