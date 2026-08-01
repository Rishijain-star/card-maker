/**
 * TripMates — Leaflet maps (static routes; no live GPS simulation).
 * Origin = blue, destination = green (map + route line hand-off).
 */
(function () {
  const SW_ROUTE = [
    [60.1478, 15.2544],
    [60.22, 15.62],
    [60.38, 16.35],
    [60.52, 16.85],
    [60.6749, 17.1413],
  ];

  const C = {
    blue: "#2563eb",
    green: "#16a34a",
  };

  let detailMap, previewMap, liveMap;

  function originIcon() {
    return L.divIcon({
      className: "tm-map-marker",
      html:
        '<div class="tm-gm-pin tm-gm-pin--origin" title="Start" aria-hidden="true">' +
        '<svg width="36" height="44" viewBox="0 0 36 44" fill="none" xmlns="http://www.w3.org/2000/svg">' +
        '<path fill="' +
        C.blue +
        '" d="M18 44c8-11 15-18 15-26C33 8 26 2 18 2S3 8 3 18c0 8 7 15 15 26z"/>' +
        '<circle cx="18" cy="17" r="6" fill="#fff"/></svg></div>',
      iconSize: [36, 44],
      iconAnchor: [18, 44],
      popupAnchor: [0, -40],
    });
  }

  function destinationIcon() {
    return L.divIcon({
      className: "tm-map-marker",
      html:
        '<div class="tm-gm-pin tm-gm-pin--destination" title="Destination" aria-hidden="true">' +
        '<svg width="36" height="44" viewBox="0 0 36 44" fill="none" xmlns="http://www.w3.org/2000/svg">' +
        '<path fill="' +
        C.green +
        '" d="M18 44c8-11 15-18 15-26C33 8 26 2 18 2S3 8 3 18c0 8 7 15 15 26z"/>' +
        '<circle cx="18" cy="17" r="6" fill="#fff"/></svg></div>',
      iconSize: [36, 44],
      iconAnchor: [18, 44],
      popupAnchor: [0, -40],
    });
  }

  function addSplitRoute(map, route) {
    const last = route.length - 1;
    const mid = Math.max(1, Math.floor(last / 2));
    L.polyline(route.slice(0, mid + 1), {
      color: C.blue,
      weight: 5,
      opacity: 0.88,
      lineJoin: "round",
      lineCap: "round",
    }).addTo(map);
    L.polyline(route.slice(mid), {
      color: C.green,
      weight: 5,
      opacity: 0.88,
      lineJoin: "round",
      lineCap: "round",
    }).addTo(map);
  }

  function buildMap(containerId, options) {
    const el = document.getElementById(containerId);
    if (!el || typeof L === "undefined") return null;

    const map = L.map(containerId, {
      zoomControl: true,
      attributionControl: true,
      ...options,
    });

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OSM</a>',
    }).addTo(map);

    addSplitRoute(map, SW_ROUTE);
    map.fitBounds(L.polyline(SW_ROUTE).getBounds(), { padding: [28, 28] });

    return { map };
  }

  function initDetail() {
    const el = document.getElementById("map-ride-detail");
    if (!el || typeof L === "undefined") return;
    if (detailMap) {
      detailMap.map.invalidateSize();
      return;
    }
    const m = buildMap("map-ride-detail");
    if (!m) return;
    detailMap = m;
    L.marker(SW_ROUTE[0], { icon: originIcon() })
      .addTo(m.map)
      .bindPopup("Start · Ludvika");
    L.marker(SW_ROUTE[SW_ROUTE.length - 1], { icon: destinationIcon() })
      .addTo(m.map)
      .bindPopup("Destination · Gävle");
  }

  function initPreview() {
    const el = document.getElementById("map-new-ride-preview");
    if (!el || typeof L === "undefined") return;
    if (previewMap) {
      previewMap.map.invalidateSize();
      return;
    }
    const m = buildMap("map-new-ride-preview", { scrollWheelZoom: false });
    if (!m) return;
    previewMap = m;
    L.marker(SW_ROUTE[0], { icon: originIcon() }).addTo(m.map).bindPopup("Origin");
    L.marker(SW_ROUTE[SW_ROUTE.length - 1], { icon: destinationIcon() })
      .addTo(m.map)
      .bindPopup("Destination");
  }

  function initLive() {
    const el = document.getElementById("map-live-trip");
    if (!el || typeof L === "undefined") return;

    if (liveMap) {
      liveMap.map.invalidateSize();
      return;
    }

    const m = buildMap("map-live-trip");
    if (!m) return;
    liveMap = m;

    L.marker(SW_ROUTE[0], { icon: originIcon() })
      .addTo(m.map)
      .bindPopup("<strong>Pickup</strong><br>Ludvika area");

    L.marker(SW_ROUTE[SW_ROUTE.length - 1], { icon: destinationIcon() })
      .addTo(m.map)
      .bindPopup("<strong>Drop-off</strong><br>Gävle");
  }

  window.TripMatesMaps = {
    onScreenShow(screenId) {
      requestAnimationFrame(function () {
        setTimeout(function () {
          if (screenId === "screen-ride-detail") initDetail();
          if (screenId === "screen-new-ride") initPreview();
          if (screenId === "screen-live-trip") initLive();
        }, 120);
      });
    },
    invalidateAll() {
      [detailMap, previewMap, liveMap].forEach(function (x) {
        try {
          if (x && x.map) x.map.invalidateSize();
        } catch (e) {
          /* ignore */
        }
      });
    },
  };
})();
