JS = {
    RecolorAccessibleContainers = [[
        const style_id = "inventory-9333-green-box";
        let style = document.getElementById(style_id);
        if (style === null) {
            style = document.createElement("style");
            style.id = style_id;
            document.head.appendChild(style);
        }
        style.textContent = ".inventory-window .inventory-item:has(img[alt=\"ID:9333\"]):not(:has(.inventory-item__timer)) .inventory-item__activity-icon.icon-type-box { color: var(--inv9333-color, #00ff00) !important; }";

        window.__inventory9333Green = {
            setColor(color) {
                document.documentElement.style.setProperty("--inv9333-color", color);
            },
            destroy() {
                style.remove();
                document.documentElement.style.removeProperty("--inv9333-color");
                delete window.__inventory9333Green;
            }
        };
    ]],
    CollectInaccessibleContainers = [[
        const BTN_CLASS = "cont-opener-collect-inaccessible-containers-btn";

        const ICON_SVG = `
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-bar-to-down">
            <path stroke="none" d="M0 0h24v24H0z" fill="none" />
            <path d="M4 20l16 0" />
            <path d="M12 14l0 -10" />
            <path d="M12 14l4 -4" />
            <path d="M12 14l-4 -4" />
        </svg>`;

        function addCollectButton() {
            const wrapper = document.querySelector(".inventory__wallet-wrapper");
            if (!wrapper) return;

            const controls = wrapper.querySelector(".inventory-window__header-controls");
            if (!controls || controls.querySelector("." + BTN_CLASS)) return;

            const closeBtn = controls.querySelector(".inventory-window__header-control-close");
            if (!closeBtn) return;

            const btn = closeBtn.cloneNode(false);
            btn.classList.remove("ui-close");
            btn.classList.add("icon-type-box", BTN_CLASS);
            btn.innerHTML = ICON_SVG;
            btn.style.marginRight = "8px";

            btn.addEventListener("mousedown", (e) => e.stopPropagation());
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                window.cef.SendMessage(`cont_opener:collectInaccessibleContainers;`, null);
            });

            controls.insertBefore(btn, closeBtn);
            console.log("[Cont Opener] Collect button added to wallet");
        }

        addCollectButton();
    ]],
    StoreAccessibleContainers = [[
        const BTN_CLASS = "cont-opener-store-accessible-containers-btn";

        const ICON_SVG = `
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-arrow-bar-up">
            <path stroke="none" d="M0 0h24v24H0z" fill="none" />
            <path d="M12 4l0 10" />
            <path d="M12 4l4 4" />
            <path d="M12 4l-4 4" />
            <path d="M4 20l16 0" />
        </svg>`;

        function addStoreButton() {
            const wrapper = document.querySelector(".inventory__wallet-wrapper");
            if (!wrapper) return;

            const controls = wrapper.querySelector(".inventory-window__header-controls");
            if (!controls || controls.querySelector("." + BTN_CLASS)) return;

            const closeBtn = controls.querySelector(".inventory-window__header-control-close");
            if (!closeBtn) return;

            const btn = closeBtn.cloneNode(false);
            btn.classList.remove("ui-close");
            btn.classList.add("icon-type-box", BTN_CLASS);
            btn.innerHTML = ICON_SVG;
            btn.style.marginRight = "8px";

            btn.addEventListener("mousedown", (e) => e.stopPropagation());
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                window.cef.SendMessage(`cont_opener:storeAccessibleContainers;`, null);
            });

            controls.insertBefore(btn, closeBtn);
            console.log("[Cont Opener] Store button added to wallet");
        }

        addStoreButton();
    ]]
}
