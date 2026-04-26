const CACHE_NAME='roenc-v3';
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(['/','manifest.json','/icon-192.png','/icon-512.png','/logo-32.png','/logo-40.png','/logo-64.png'])));self.skipWaiting();});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))));self.clients.claim();});
self.addEventListener('fetch',e=>{if(e.request.method!=='GET'||!e.request.url.startsWith('http'))return;e.respondWith(fetch(e.request).then(r=>{if(r.status===200){const c=r.clone();caches.open(CACHE_NAME).then(cache=>cache.put(e.request,c));}return r;}).catch(()=>caches.match(e.request).then(c=>c||caches.match('/'))));});
