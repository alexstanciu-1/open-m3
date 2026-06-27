export function createRuntime(options = {}) {
  const adapter = options.adapter ?? createNoopAdapter();
  const diagnosticsEnabled = options.diagnostics === true;
  const diagnostics = [];
  const bindings = new Map();
  let rootNode = null;
  let state = { lastAction: null };

  function record(level, message, data = null) {
    const entry = {
      level,
      message,
      data,
      time: new Date().toISOString()
    };
    diagnostics.push(entry);
    if (adapter.log) {
      adapter.log(level, message, data);
    }
    renderDiagnostics();
  }

  function mount(domNode, uiIr) {
    if (!domNode) {
      throw new Error('runtime.mount requires a DOM node.');
    }
    unmount();
    rootNode = domNode;
    rootNode.replaceChildren(renderNode(uiIr.root));
    if (diagnosticsEnabled) {
      rootNode.firstElementChild.appendChild(renderDiagnosticsPanel());
    }
    updateBindings();
    record('info', 'Mounted UI', { ui: uiIr.ui, adapter: adapter.kind });
  }

  function unmount() {
    bindings.clear();
    if (rootNode) {
      rootNode.replaceChildren();
    }
  }

  async function dispatch(actionName, payload = {}) {
    record('info', 'Dispatch action', { action: actionName, payload });
    const response = await adapter.invoke(actionName, payload);
    state = {
      ...state,
      lastAction: response
    };
    updateBindings();
    record('info', 'Action completed', response);
    return response;
  }

  function getState() {
    return structuredCloneSafe(state);
  }

  function setState(patch) {
    state = deepMerge(state, patch ?? {});
    updateBindings();
    record('info', 'State updated', patch ?? {});
  }

  function getDiagnostics() {
    return diagnostics.slice();
  }

  function renderNode(node) {
    if (!node || typeof node !== 'object') {
      throw new Error('Invalid UI node.');
    }

    if (node.type === 'view') {
      const element = document.createElement('section');
      element.className = `dp-view dp-layout-${node.layout ?? 'stack'}`;
      setNodeId(element, node);
      for (const child of node.children ?? []) {
        element.appendChild(renderNode(child));
      }
      return element;
    }

    if (node.type === 'text') {
      const element = document.createElement(node.variant === 'title' ? 'h1' : 'p');
      element.className = node.variant === 'title' ? 'dp-text dp-text-title' : 'dp-text';
      setNodeId(element, node);
      if (node.bind) {
        element.classList.add('dp-bound-text');
        bindings.set(node.id, { element, path: node.bind, placeholder: node.placeholder ?? '' });
      }
      element.textContent = node.value ?? node.placeholder ?? '';
      return element;
    }

    if (node.type === 'button') {
      const element = document.createElement('button');
      element.type = 'button';
      element.className = 'dp-button';
      setNodeId(element, node);
      element.textContent = node.label ?? node.action ?? 'Action';
      element.addEventListener('click', () => dispatch(node.action, { source: node.id }));
      return element;
    }

    throw new Error(`Unsupported UI node type: ${node.type}`);
  }

  function setNodeId(element, node) {
    if (node.id) {
      element.dataset.dpId = node.id;
    }
  }

  function updateBindings() {
    for (const binding of bindings.values()) {
      const value = readPath(state, binding.path);
      binding.element.textContent = value ?? binding.placeholder;
    }
  }

  function renderDiagnosticsPanel() {
    const details = document.createElement('details');
    details.className = 'dp-diagnostics';
    const summary = document.createElement('summary');
    summary.textContent = 'Runtime diagnostics';
    const pre = document.createElement('pre');
    pre.dataset.dpDiagnostics = 'log';
    details.append(summary, pre);
    return details;
  }

  function renderDiagnostics() {
    if (!rootNode) {
      return;
    }
    const pre = rootNode.querySelector('[data-dp-diagnostics="log"]');
    if (pre) {
      pre.textContent = JSON.stringify(diagnostics, null, 2);
    }
  }

  return {
    mount,
    unmount,
    dispatch,
    getState,
    setState,
    getDiagnostics
  };
}

function createNoopAdapter() {
  return {
    kind: 'noop',
    getCapabilities: () => ({}),
    invoke: async (actionName, payload) => ({ ok: true, action: actionName, payload }),
    log: () => {}
  };
}

function readPath(source, path) {
  const parts = String(path ?? '').split('.').filter(Boolean);
  let value = source;
  for (const part of parts) {
    if (value == null) {
      return null;
    }
    value = value[part];
  }
  return value;
}

function deepMerge(base, patch) {
  const result = Array.isArray(base) ? base.slice() : { ...base };
  for (const [key, value] of Object.entries(patch)) {
    if (value && typeof value === 'object' && !Array.isArray(value)) {
      result[key] = deepMerge(result[key] ?? {}, value);
    } else {
      result[key] = value;
    }
  }
  return result;
}

function structuredCloneSafe(value) {
  if (typeof structuredClone === 'function') {
    return structuredClone(value);
  }
  return JSON.parse(JSON.stringify(value));
}
