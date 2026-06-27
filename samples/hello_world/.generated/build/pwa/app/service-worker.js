const CACHE_NAME = 'openm3-hello_world-v1';
const STATIC_ASSETS = [
  './',
  './index.html',
  './ui/main/styles.css',
  './ui/main/component.js',
  './ui/main/ui.ir.json',
  './ui/main/ui.ir.js',
  './runtime/descriptivejs/runtime.js',
  './runtime/adapters/pwa.js'
];

self.addEventListener('install', (event) => {
  event.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS)));
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))))
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  event.respondWith(caches.match(event.request).then((response) => response || fetch(event.request)));
});
