(function () {
  if (document.documentElement.classList.contains("static-preview")) {
    document.addEventListener(
      "click",
      function (e) {
        const t = e.target;
        if (!t || !t.closest) return;
        const block = t.closest(
          "button:not([data-mode]), a[href], [data-nav], [data-open-modal], [data-screen], [data-close-modal], [data-toggle-password], input, select, textarea, .nav-item, .icon-btn, .star-btn, .switch, .country-item, .ride-result-card__main, .filter-chip, .swap-btn, .password-toggle, .flag, .list-row, .checkbox-row, .leaflet-control-container, .leaflet-interactive, .tm-map-marker"
        );
        if (block) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
      },
      true
    );
    document.addEventListener(
      "keydown",
      function (e) {
        if (e.key !== "Enter" && e.key !== " ") return;
        const el = document.activeElement;
        if (!el || !el.closest) return;
        if (
          el.closest(
            "button:not([data-mode]), a[href], [data-nav], [data-open-modal], [data-screen], .nav-item, [tabindex], .ride-result-card__main, .list-row, .filter-chip, .star-btn, .country-item, .flag, .checkbox-row"
          )
        ) {
          e.preventDefault();
        }
      },
      true
    );
  }

  const AUTH_SCREENS = [
    "screen-launch-white",
    "screen-onboard-1",
    "screen-onboard-2",
    "screen-onboard-3",
    "screen-welcome",
    "screen-login",
    "screen-register",
    "screen-forgot-password",
  ];

  function isWelcomeChromeScreen(id) {
    return (
      id === "screen-welcome" ||
      id === "screen-launch-white" ||
      id === "screen-onboard-1" ||
      id === "screen-onboard-2" ||
      id === "screen-onboard-3"
    );
  }

  const screens = document.querySelectorAll(".screen");
  function forEachNavItem(fn) {
    document.querySelectorAll(".bottom-nav .nav-item[data-screen]").forEach(fn);
  }
  const countryModal = document.getElementById("modal-countries");
  const phone = document.getElementById("app");
  const toastRoot = document.getElementById("toast-root");

  let pendingArchiveContext = null;
  let profileSetupStep = 2;

  const CHECK_SVG =
    '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 6L9 17l-5-5" /></svg>';

  function syncRideDetailReview() {
    try {
      const raw = sessionStorage.getItem("tm_review");
      const panel = document.getElementById("ride-detail-your-review");
      const starsEl = document.getElementById("ride-detail-your-stars");
      const noteEl = document.getElementById("ride-detail-your-note");
      if (!raw || !panel || !starsEl || !noteEl) return;
      const r = JSON.parse(raw);
      panel.classList.remove("tm-hidden");
      starsEl.textContent =
        (r.stars != null ? r.stars + " ★" : "") + (r.label ? " · " + r.label : "");
      noteEl.textContent = r.note && String(r.note).trim() ? r.note : "No comment.";
    } catch (err) {
      /* ignore */
    }
  }

  function updateCreditMeter(pct) {
    const fill = document.getElementById("credit-meter-fill");
    const lab = document.getElementById("credit-meter-pct");
    const bar = fill && fill.parentElement;
    const n = Math.max(0, Math.min(100, pct));
    if (fill) fill.style.width = n + "%";
    if (lab) lab.textContent = n + "%";
    if (bar) bar.setAttribute("aria-valuenow", String(n));
  }

  function applyProfileSetupVisual(step) {
    const n1 = document.getElementById("ps-node-1");
    const n2 = document.getElementById("ps-node-2");
    const n3 = document.getElementById("ps-node-3");
    const c1 = document.getElementById("ps-conn-1");
    const c2 = document.getElementById("ps-conn-2");
    const cap1 = document.getElementById("ps-cap-1");
    const cap2 = document.getElementById("ps-cap-2");
    const cap3 = document.getElementById("ps-cap-3");
    if (!n1 || !n2 || !n3 || !c1 || !c2) return;

    n1.className = "tm-stepper__circle";
    n2.className = "tm-stepper__circle";
    n3.className = "tm-stepper__circle";
    c1.className = "tm-stepper__conn";
    c2.className = "tm-stepper__conn";
    [cap1, cap2, cap3].forEach(function (c) {
      if (c) {
        c.classList.remove("tm-stepper__cap--done", "tm-stepper__cap--active");
      }
    });

    if (step === 1) {
      n1.classList.add("tm-stepper__circle--active");
      n1.innerHTML = "<span>1</span>";
      c1.classList.add("tm-stepper__conn--todo");
      n2.classList.add("tm-stepper__circle--todo");
      n2.innerHTML = "<span>2</span>";
      c2.classList.add("tm-stepper__conn--todo");
      n3.classList.add("tm-stepper__circle--todo");
      n3.innerHTML = "<span>3</span>";
      if (cap1) cap1.classList.add("tm-stepper__cap--active");
    } else if (step === 2) {
      n1.classList.add("tm-stepper__circle--done");
      n1.innerHTML = CHECK_SVG;
      c1.classList.add("tm-stepper__conn--done");
      n2.classList.add("tm-stepper__circle--active");
      n2.innerHTML = "<span>2</span>";
      c2.classList.add("tm-stepper__conn--todo");
      n3.classList.add("tm-stepper__circle--todo");
      n3.innerHTML = "<span>3</span>";
      if (cap1) cap1.classList.add("tm-stepper__cap--done");
      if (cap2) cap2.classList.add("tm-stepper__cap--active");
    } else {
      n1.classList.add("tm-stepper__circle--done");
      n1.innerHTML = CHECK_SVG;
      c1.classList.add("tm-stepper__conn--done");
      n2.classList.add("tm-stepper__circle--done");
      n2.innerHTML = CHECK_SVG;
      c2.classList.add("tm-stepper__conn--done");
      n3.classList.add("tm-stepper__circle--active");
      n3.innerHTML = "<span>3</span>";
      if (cap1) cap1.classList.add("tm-stepper__cap--done");
      if (cap2) cap2.classList.add("tm-stepper__cap--done");
      if (cap3) cap3.classList.add("tm-stepper__cap--active");
    }
  }

  function applyProfileSetupPanels(step) {
    document.querySelectorAll(".profile-setup-panel").forEach(function (p) {
      const s = parseInt(p.getAttribute("data-profile-step"), 10);
      p.hidden = s !== step;
    });
  }

  function goProfileSetup(step) {
    profileSetupStep = step;
    applyProfileSetupPanels(step);
    applyProfileSetupVisual(step);
    const nextBtn = document.getElementById("btn-profile-next");
    const backBtn = document.getElementById("btn-profile-back");
    if (nextBtn) nextBtn.textContent = step === 3 ? "Finish" : "Continue";
    if (backBtn) {
      backBtn.textContent = step === 1 ? "Account home" : "Back";
    }
  }

  function modalIdFromKey(key) {
    return "modal-" + key;
  }

  function openModalByKey(key) {
    const el = document.getElementById(modalIdFromKey(key));
    if (el) {
      el.classList.add("open");
      document.body.style.overflow = "hidden";
    }
  }

  function closeModalByKey(key) {
    const el = document.getElementById(modalIdFromKey(key));
    if (el) {
      el.classList.remove("open");
      document.body.style.overflow = "";
    }
  }

  function showToast(message) {
    if (!toastRoot) return;
    const t = document.createElement("div");
    t.className = "toast";
    t.textContent = message;
    toastRoot.appendChild(t);
    requestAnimationFrame(function () {
      t.classList.add("toast--show");
    });
    setTimeout(function () {
      t.classList.remove("toast--show");
      setTimeout(function () {
        t.remove();
      }, 320);
    }, 2800);
  }

  function showScreen(id) {
    const prev = document.querySelector(".screen.active");
    if (
      id === "screen-home" &&
      prev &&
      (prev.id === "screen-login" || prev.id === "screen-register")
    ) {
      try {
        localStorage.setItem("tm_registered", "1");
      } catch (err) {
        /* ignore */
      }
    }

    if (id === "screen-login" && prev && prev.id === "screen-onboard-3") {
      try {
        sessionStorage.setItem("tm_intro_complete", "1");
      } catch (err) {
        /* ignore */
      }
    }

    screens.forEach((s) => {
      s.classList.toggle("active", s.id === id);
    });
    const isAuth = AUTH_SCREENS.includes(id);
    forEachNavItem((n) => {
      const target = n.getAttribute("data-screen");
      if (isAuth) {
        n.classList.remove("active");
        n.removeAttribute("aria-current");
      } else {
        n.classList.toggle("active", target === id);
        if (target === id) n.setAttribute("aria-current", "page");
        else n.removeAttribute("aria-current");
      }
    });
    if (phone) {
      phone.classList.toggle("phone--auth", isAuth);
      phone.classList.toggle("phone--welcome-only", isWelcomeChromeScreen(id));
    }
    history.replaceState(null, "", "#" + id);

    if (
      window.TripMatesMaps &&
      typeof window.TripMatesMaps.onScreenShow === "function"
    ) {
      window.TripMatesMaps.onScreenShow(id);
    }

    syncRideDetailReview();

    if (id === "screen-profile-setup") {
      goProfileSetup(2);
    }

    try {
      if (id === "screen-account" && sessionStorage.getItem("tm_profile_complete")) {
        updateCreditMeter(100);
      }
    } catch (e2) {
      /* ignore */
    }
  }

  forEachNavItem((btn) => {
    btn.addEventListener("click", () => {
      const id = btn.getAttribute("data-screen");
      if (id) showScreen(id);
    });
  });

  function injectBottomNavClonesForFigmaExport() {
    if (!document.documentElement.classList.contains("figma-export")) return;
    const stack = document.querySelector(".screen-stack");
    const source = document.querySelector(".bottom-nav[data-bottom-nav-template]");
    if (!stack || !source) return;
    const screens = stack.querySelectorAll(".screen");
    if (!screens.length) return;

    const navActiveTab = {
      "screen-launch-white": 0,
      "screen-onboard-1": 0,
      "screen-onboard-2": 0,
      "screen-onboard-3": 0,
      "screen-welcome": 0,
      "screen-login": 0,
      "screen-register": 0,
      "screen-forgot-password": 0,
      "screen-flow-guide": 0,
      "screen-home": 0,
      "screen-new-ride": 0,
      "screen-datetime": 0,
      "screen-preferences": 0,
      "screen-search": 1,
      "screen-results": 1,
      "screen-booking": 2,
      "screen-live-trip": 2,
      "screen-review": 2,
      "screen-ride-detail": 2,
      "screen-my-rides": 2,
      "screen-my-rides-passenger": 2,
      "screen-garage": 2,
      "screen-account": 3,
      "screen-settings": 3,
      "screen-edit-profile": 3,
      "screen-trip-history": 3,
      "screen-payment-history": 3,
      "screen-profile-setup": 3,
    };

    screens.forEach(function (screen) {
      const clone = source.cloneNode(true);
      clone.removeAttribute("data-bottom-nav-template");
      clone.classList.add("bottom-nav--in-frame");
      clone.classList.remove("bottom-nav--replaced");
      clone.setAttribute("aria-hidden", "true");
      clone.setAttribute("aria-label", "Tabs (duplicate for layout)");
      const idx = navActiveTab[screen.id];
      const activeIndex = typeof idx === "number" ? idx : 0;
      clone.querySelectorAll(".nav-item[data-screen]").forEach(function (btn, i) {
        btn.classList.toggle("active", i === activeIndex);
        if (i === activeIndex) btn.setAttribute("aria-current", "page");
        else btn.removeAttribute("aria-current");
      });
      screen.appendChild(clone);
    });

    source.classList.add("bottom-nav--replaced");
  }

  document.addEventListener("click", function (e) {
    const navEl = e.target.closest("[data-nav]");
    if (!navEl) return;
    const id = navEl.getAttribute("data-nav");
    if (!id || !document.getElementById(id)) return;
    e.preventDefault();
    showScreen(id);
  });

  document.addEventListener("keydown", function (e) {
    if (e.key !== "Enter" && e.key !== " ") return;
    const el = document.activeElement;
    if (!el || !el.closest) return;
    const navEl = el.closest("[data-nav][tabindex]");
    if (navEl) {
      const id = navEl.getAttribute("data-nav");
      if (id && document.getElementById(id)) {
        e.preventDefault();
        showScreen(id);
      }
      return;
    }
    const openEl = el.closest("[data-open-modal][tabindex]");
    if (openEl) {
      e.preventDefault();
      openEl.click();
    }
  });

  /* Modals: open / close */
  document.querySelectorAll("[data-open-modal]").forEach((btn) => {
    btn.addEventListener("click", (e) => {
      const key = btn.getAttribute("data-open-modal");
      if (!key) return;
      e.preventDefault();
      e.stopPropagation();
      if (key === "book-confirm") {
        e.stopPropagation();
        const d = document.getElementById("book-modal-driver");
        const r = document.getElementById("book-modal-route");
        const t = document.getElementById("book-modal-time");
        const p = document.getElementById("book-modal-price");
        if (d) d.textContent = btn.getAttribute("data-book-driver") || "Driver";
        if (r) r.textContent = btn.getAttribute("data-book-route") || "";
        if (t) t.textContent = btn.getAttribute("data-book-time") || "—";
        if (p) p.textContent = btn.getAttribute("data-book-price") || "—";
      }
      if (key === "archive-confirm") {
        pendingArchiveContext = btn.getAttribute("data-archive-context") || "";
      }
      openModalByKey(key);
    });
  });

  document.querySelectorAll("[data-close-modal]").forEach((btn) => {
    btn.addEventListener("click", () => {
      closeModalByKey(btn.getAttribute("data-close-modal"));
    });
  });

  ["modal-search-filters", "modal-book-confirm", "modal-archive-confirm", "modal-publish-success", "modal-countries"].forEach((mid) => {
    const el = document.getElementById(mid);
    if (!el) return;
    el.addEventListener("click", (e) => {
      if (e.target === el) {
        el.classList.remove("open");
        document.body.style.overflow = "";
      }
    });
  });

  const confirmBook = document.getElementById("btn-confirm-booking");
  if (confirmBook) {
    confirmBook.addEventListener("click", () => {
      const driver = document.getElementById("book-modal-driver");
      const price = document.getElementById("book-modal-price");
      const who = driver ? driver.textContent.trim() : "Driver";
      const kr = price ? price.textContent.trim() : "";
      closeModalByKey("book-confirm");
      showToast("Booking confirmed · " + who + (kr ? " · " + kr : ""));
      showScreen("screen-booking");
    });
  }

  const confirmArchive = document.getElementById("btn-confirm-archive");
  if (confirmArchive) {
    confirmArchive.addEventListener("click", () => {
      closeModalByKey("archive-confirm");
      showToast("Trip archived");
      if (pendingArchiveContext === "my-rides") {
        const active = document.getElementById("card-driver-active");
        const archived = document.getElementById("my-rides-archived-block");
        if (active) active.classList.add("tm-hidden");
        if (archived) archived.classList.remove("tm-hidden");
      }
      if (pendingArchiveContext === "detail") {
        const actions = document.getElementById("ride-detail-actions");
        const msg = document.getElementById("ride-detail-archived-msg");
        if (actions) actions.classList.add("tm-hidden");
        if (msg) msg.classList.remove("tm-hidden");
      }
      pendingArchiveContext = null;
    });
  }

  const applyFilters = document.getElementById("btn-apply-filters");
  if (applyFilters) {
    applyFilters.addEventListener("click", () => {
      const dateEl = document.getElementById("filter-date");
      const radEl = document.getElementById("filter-radius");
      const sortEl = document.getElementById("filter-sort");
      const chipDate = document.getElementById("chip-filter-date");
      const chipRad = document.getElementById("chip-filter-radius");
      const chipSort = document.getElementById("chip-filter-sort");
      if (dateEl && chipDate) chipDate.textContent = dateEl.options[dateEl.selectedIndex].value;
      if (radEl && chipRad) chipRad.textContent = radEl.value;
      if (sortEl && chipSort) chipSort.textContent = sortEl.value;
      closeModalByKey("search-filters");
      showToast("Filters applied");
      showScreen("screen-search");
    });
  }

  const publishGo = document.getElementById("btn-publish-go-rides");
  if (publishGo) {
    publishGo.addEventListener("click", () => {
      closeModalByKey("publish-success");
      showToast("Ride published");
      showScreen("screen-my-rides");
    });
  }

  if (countryModal) {
    countryModal.addEventListener("click", (e) => {
      if (e.target === countryModal) {
        countryModal.classList.remove("open");
        document.body.style.overflow = "";
      }
    });
  }

  document.querySelectorAll(".country-item").forEach((row) => {
    row.addEventListener("click", () => {
      row.classList.toggle("selected");
      const cb = row.querySelector(".checkbox");
      if (cb)
        cb.textContent = row.classList.contains("selected") ? "\u2713" : "";
    });
  });

  function applyRideMode(mode) {
    document.querySelectorAll("[data-visible-mode]").forEach((block) => {
      const m = block.getAttribute("data-visible-mode");
      block.style.display = m === mode ? "block" : "none";
    });
  }

  document.querySelectorAll(".segmented").forEach((seg) => {
    const active = seg.querySelector("button[data-mode].active");
    if (active) applyRideMode(active.getAttribute("data-mode"));
    seg.querySelectorAll("button[data-mode]").forEach((b) => {
      b.addEventListener("click", () => {
        seg.querySelectorAll("button[data-mode]").forEach((x) =>
          x.classList.remove("active")
        );
        b.classList.add("active");
        applyRideMode(b.getAttribute("data-mode"));
      });
    });
  });

  document.querySelectorAll(".switch").forEach((sw) => {
    sw.addEventListener("click", () => sw.classList.toggle("on"));
  });

  document.querySelectorAll(".swap-btn[data-swap]").forEach((btn) => {
    btn.addEventListener("click", () => {
      const scope = btn.closest(".screen") || document;
      const o = scope.querySelector("[data-field='origin']");
      const d = scope.querySelector("[data-field='destination']");
      if (o && d && o.value !== undefined && d.value !== undefined) {
        const t = o.value;
        o.value = d.value;
        d.value = t;
      }
    });
  });

  document.querySelectorAll("[data-toggle-password]").forEach((btn) => {
    btn.addEventListener("click", () => {
      const id = btn.getAttribute("data-toggle-password");
      const input = id && document.getElementById(id);
      if (!input) return;
      const isPw = input.getAttribute("type") === "password";
      input.setAttribute("type", isPw ? "text" : "password");
      btn.setAttribute("aria-label", isPw ? "Hide password" : "Show password");
    });
  });

  const figmaExport = document.documentElement.classList.contains("figma-export");

  /** Order for grouping frames left-to-right inside each band (static / Figma export). */
  var FIGMA_FLOW_CATEGORIES = [
    {
      title: "Authentication",
      ids: [
        "screen-launch-white",
        "screen-onboard-1",
        "screen-onboard-2",
        "screen-onboard-3",
        "screen-welcome",
        "screen-login",
        "screen-register",
        "screen-forgot-password",
      ],
    },
    {
      title: "Dashboard & overview",
      ids: ["screen-flow-guide", "screen-home"],
    },
    {
      title: "Search & booking",
      ids: [
        "screen-search",
        "screen-results",
        "screen-ride-detail",
        "screen-booking",
        "screen-live-trip",
        "screen-review",
      ],
    },
    {
      title: "Driver · publish & manage",
      ids: [
        "screen-new-ride",
        "screen-datetime",
        "screen-preferences",
        "screen-my-rides",
        "screen-my-rides-passenger",
        "screen-garage",
      ],
    },
    {
      title: "Profile & account",
      ids: [
        "screen-account",
        "screen-settings",
        "screen-edit-profile",
        "screen-trip-history",
        "screen-payment-history",
        "screen-profile-setup",
      ],
    },
  ];

  /** Static/Figma layout: attach each modal under its parent screen (see CSS .figma-flow-pair). */
  function pairFigmaFlowPopups() {
    if (!document.documentElement.classList.contains("figma-export")) return;
    var pairs = [
      ["screen-search", "modal-search-filters"],
      ["screen-results", "modal-book-confirm"],
      ["screen-my-rides", "modal-archive-confirm"],
      ["screen-preferences", "modal-publish-success"],
      ["screen-account", "modal-countries"],
    ];
    pairs.forEach(function (pair) {
      var screen = document.getElementById(pair[0]);
      var modal = document.getElementById(pair[1]);
      if (!screen || !modal || !modal.parentNode) return;
      var wrap = document.createElement("div");
      wrap.className = "figma-flow-pair";
      var conn = document.createElement("div");
      conn.className = "figma-popup-connector";
      conn.setAttribute("aria-hidden", "true");
      var aside = document.createElement("aside");
      aside.className = "figma-popup-side";
      var parent = screen.parentNode;
      parent.insertBefore(wrap, screen);
      wrap.appendChild(screen);
      wrap.appendChild(conn);
      wrap.appendChild(aside);
      aside.appendChild(modal);
    });
  }

  /** Static/Figma layout: horizontal strips per journey category (scroll each row on small viewports). */
  function organizeFigmaFlowCategories() {
    if (!document.documentElement.classList.contains("figma-export")) return;
    var stack = document.querySelector(".screen-stack");
    if (!stack) return;

    var blocks = Array.from(stack.children).filter(function (el) {
      return (
        el.matches &&
        (el.matches("section.screen[id]") || el.classList.contains("figma-flow-pair"))
      );
    });

    var nodeByScreenId = new Map();
    blocks.forEach(function (el) {
      if (el.classList.contains("figma-flow-pair")) {
        var s = el.querySelector("section.screen[id]");
        if (s && s.id) nodeByScreenId.set(s.id, el);
      } else if (el.id) {
        nodeByScreenId.set(el.id, el);
      }
    });

    while (stack.firstChild) {
      stack.removeChild(stack.firstChild);
    }

    FIGMA_FLOW_CATEGORIES.forEach(function (cat) {
      var row = document.createElement("div");
      row.className = "figma-flow-category__row";

      cat.ids.forEach(function (sid) {
        var node = nodeByScreenId.get(sid);
        if (node) {
          row.appendChild(node);
          nodeByScreenId.delete(sid);
        }
      });

      if (!row.children.length) return;

      var band = document.createElement("section");
      band.className = "figma-flow-category";
      band.setAttribute("aria-label", cat.title);
      var h2 = document.createElement("h2");
      h2.className = "figma-flow-category__title";
      h2.textContent = cat.title;

      band.appendChild(h2);
      band.appendChild(row);
      stack.appendChild(band);
    });

    if (nodeByScreenId.size > 0) {
      var row = document.createElement("div");
      row.className = "figma-flow-category__row";
      nodeByScreenId.forEach(function (node) {
        row.appendChild(node);
      });
      var band = document.createElement("section");
      band.className = "figma-flow-category figma-flow-category--extra";
      band.setAttribute("aria-label", "Additional screens");
      var h2 = document.createElement("h2");
      h2.className = "figma-flow-category__title";
      h2.textContent = "Additional";
      band.appendChild(h2);
      band.appendChild(row);
      stack.appendChild(band);
      nodeByScreenId.clear();
    }
  }

  function isRegistered() {
    try {
      return localStorage.getItem("tm_registered") === "1";
    } catch (err) {
      return false;
    }
  }

  function getInitialScreenId() {
    const hash = window.location.hash.slice(1);
    if (hash && document.getElementById(hash)) {
      return hash;
    }
    if (isRegistered()) {
      return "screen-home";
    }
    try {
      if (sessionStorage.getItem("tm_intro_complete") === "1") {
        return "screen-welcome";
      }
    } catch (err) {
      /* private mode */
    }
    return "screen-launch-white";
  }

  if (!figmaExport) {
    showScreen(getInitialScreenId());
  } else {
    pairFigmaFlowPopups();
    organizeFigmaFlowCategories();
    if (phone) {
      phone.classList.remove("phone--auth", "phone--welcome-only");
    }
    document.querySelectorAll(".modal-overlay").forEach(function (m) {
      m.classList.add("open");
    });
    requestAnimationFrame(function () {
      setTimeout(function () {
        if (window.TripMatesMaps && typeof window.TripMatesMaps.onScreenShow === "function") {
          ["screen-ride-detail", "screen-new-ride", "screen-live-trip"].forEach(function (sid) {
            window.TripMatesMaps.onScreenShow(sid);
          });
        }
        if (window.TripMatesMaps && typeof window.TripMatesMaps.invalidateAll === "function") {
          window.TripMatesMaps.invalidateAll();
        }
      }, 280);
      setTimeout(function () {
        if (window.TripMatesMaps && typeof window.TripMatesMaps.invalidateAll === "function") {
          window.TripMatesMaps.invalidateAll();
        }
      }, 700);
      injectBottomNavClonesForFigmaExport();
    });
  }

  (function initStars() {
    const wrap = document.getElementById("star-rating");
    const label = document.getElementById("star-rating-label");
    if (!wrap) return;
    const texts = {
      1: "Room to improve",
      2: "Okay",
      3: "Good ride",
      4: "Very good",
      5: "Excellent — 5 stars",
    };
    wrap.querySelectorAll(".star-btn").forEach((btn) => {
      btn.addEventListener("click", () => {
        const v = parseInt(btn.getAttribute("data-value"), 10);
        wrap.querySelectorAll(".star-btn").forEach((b) => {
          const bv = parseInt(b.getAttribute("data-value"), 10);
          b.classList.toggle("star-btn--active", bv <= v);
        });
        if (label) label.textContent = texts[v] || "";
      });
    });
  })();

  document.querySelectorAll(".ride-result-card__main").forEach((el) => {
    el.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        el.click();
      }
    });
  });

  const submitReview = document.getElementById("btn-submit-review");
  if (submitReview) {
    submitReview.addEventListener("click", function (e) {
      e.preventDefault();
      const wrap = document.getElementById("star-rating");
      const labelEl = document.getElementById("star-rating-label");
      const noteEl = document.getElementById("review-note");
      let stars = 5;
      if (wrap) {
        const btns = wrap.querySelectorAll(".star-btn.star-btn--active");
        stars = btns.length;
      }
      const label = labelEl ? labelEl.textContent.trim() : "";
      const note = noteEl ? noteEl.value : "";
      sessionStorage.setItem(
        "tm_review",
        JSON.stringify({ stars: stars, label: label, note: note })
      );
      showToast("Thanks! Your review is saved on this trip.");
      showScreen("screen-my-rides");
    });
  }

  const payFilters = document.querySelector("[data-payment-filters]");
  if (payFilters) {
    payFilters.addEventListener("click", function (e) {
      const chip = e.target.closest("[data-payment-filter]");
      if (!chip) return;
      const v = chip.getAttribute("data-payment-filter");
      payFilters.querySelectorAll("[data-payment-filter]").forEach(function (c) {
        const on = c === chip;
        c.classList.toggle("active", on);
        c.setAttribute("aria-selected", on ? "true" : "false");
      });
      document.querySelectorAll(".payment-row").forEach(function (row) {
        const t = row.getAttribute("data-payment-type");
        if (v === "all") row.classList.remove("tm-hidden");
        else row.classList.toggle("tm-hidden", t !== v);
      });
    });
  }

  const btnProfileNext = document.getElementById("btn-profile-next");
  const btnProfileBack = document.getElementById("btn-profile-back");
  const btnSetupPhoto = document.getElementById("btn-setup-photo");

  if (btnProfileNext) {
    btnProfileNext.addEventListener("click", function () {
      if (profileSetupStep < 3) {
        goProfileSetup(profileSetupStep + 1);
        return;
      }
      sessionStorage.setItem("tm_profile_complete", "1");
      updateCreditMeter(100);
      showToast("Profile verified — trust score updated");
      showScreen("screen-account");
    });
  }

  if (btnProfileBack) {
    btnProfileBack.addEventListener("click", function () {
      if (profileSetupStep <= 1) {
        showScreen("screen-account");
        return;
      }
      goProfileSetup(profileSetupStep - 1);
    });
  }

  if (btnSetupPhoto) {
    btnSetupPhoto.addEventListener("click", function () {
      showToast("Photo upload is a demo — no file sent");
    });
  }

  (function initIntroWhiteScreen() {
    if (
      document.documentElement.classList.contains("figma-export") ||
      document.documentElement.classList.contains("static-preview")
    ) {
      return;
    }

    const active = document.querySelector(".screen.active");
    if (!active || active.id !== "screen-launch-white") return;

    setTimeout(function () {
      const cur = document.querySelector(".screen.active");
      if (cur && cur.id === "screen-launch-white") {
        showScreen("screen-onboard-1");
      }
    }, 1100);
  })();

  window.TripMatesNav = {
    showScreen,
    showToast,
    openModalByKey,
    closeModalByKey,
    syncRideDetailReview,
    updateCreditMeter,
  };
})();
