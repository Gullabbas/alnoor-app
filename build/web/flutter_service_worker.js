'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".vercel/anonymous.json": "b1dab025a4efe1274e2975f723ccb8ea",
".vercel/output/builds.json": "885d70d1e8600e923b413ef1e96b5f52",
".vercel/output/config.json": "bba9c38e7f2d7fbd3b720fb9debcc661",
".vercel/output/diagnostics/cli_traces.json": "084ed8e75fd1d5bf1d12739af3739641",
".vercel/output/diagnostics/deploy-manifest.json": "0f636a2b80d78799854485ba3be3a102",
".vercel/output/diagnostics/project-manifest.json": "f722a0f556715c764d12779a2c995546",
".vercel/output/static/assets/AssetManifest.bin": "59613b09b52197f128f2b57f86cf7910",
".vercel/output/static/assets/AssetManifest.bin.json": "ac17d1aba98df32d59debd471611f263",
".vercel/output/static/assets/AssetManifest.json": "1b29c1066521a204011ecbfdfa934378",
".vercel/output/static/assets/assets/branding/logo-alnoor.png": "8be8c910333a33465238061a5951d2fb",
".vercel/output/static/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
".vercel/output/static/assets/fonts/MaterialIcons-Regular.otf": "3e6570a82b128f07778eb8be12b8ba9d",
".vercel/output/static/assets/NOTICES": "7dbe72f7d22a620f3eff7871fb788acc",
".vercel/output/static/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
".vercel/output/static/assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
".vercel/output/static/canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
".vercel/output/static/canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
".vercel/output/static/canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
".vercel/output/static/canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
".vercel/output/static/canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
".vercel/output/static/canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
".vercel/output/static/canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
".vercel/output/static/canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
".vercel/output/static/canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
".vercel/output/static/canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
".vercel/output/static/canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
".vercel/output/static/canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
".vercel/output/static/favicon.png": "5dcef449791fa27946b3d35ad8803796",
".vercel/output/static/flutter.js": "888483df48293866f9f41d3d9274a779",
".vercel/output/static/flutter_bootstrap.js": "a2ae2f65abbf6ad649d39b4f18b94dee",
".vercel/output/static/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
".vercel/output/static/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
".vercel/output/static/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
".vercel/output/static/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
".vercel/output/static/index.html": "2dbfb5496a4cac3a4330ea46fd517aea",
".vercel/output/static/main.dart.js": "bc1529e53dec23405e82cf0e18b8387b",
".vercel/output/static/manifest.json": "8bcb1ef7f69762052ce4aa388a953876",
".vercel/output/static/version.json": "b52a36b4ad412b0441181dff14a44459",
"assets/AssetManifest.bin": "59613b09b52197f128f2b57f86cf7910",
"assets/AssetManifest.bin.json": "ac17d1aba98df32d59debd471611f263",
"assets/AssetManifest.json": "1b29c1066521a204011ecbfdfa934378",
"assets/assets/branding/logo-alnoor.png": "8be8c910333a33465238061a5951d2fb",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "3e6570a82b128f07778eb8be12b8ba9d",
"assets/NOTICES": "7dbe72f7d22a620f3eff7871fb788acc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "a2ae2f65abbf6ad649d39b4f18b94dee",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2dbfb5496a4cac3a4330ea46fd517aea",
"/": "2dbfb5496a4cac3a4330ea46fd517aea",
"main.dart.js": "dd7d22af39990e4e8ef0ea9ef010bbc7",
"manifest.json": "8bcb1ef7f69762052ce4aa388a953876",
"vercel.json": "d433c9e2796f37715565b34dbcb62b2c",
"version.json": "b52a36b4ad412b0441181dff14a44459"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
