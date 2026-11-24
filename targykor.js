const initialItems = [
    {
        id: 1,
        title: "Bosch GSB 18V-50 Akkus Ütvefúró",
        category: "Barkácsgépek",
        city: "Pécs",
        price: 3200,
        deposit: 20000,
        rating: 4.9,
        owner: "Kovács Dániel",
        image: "https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=700&q=80",
        desc: "2 db 2.0Ah akkumulátorral, gyorstöltővel és profi kofferrel. Beton, fa és fém fúrására is kiváló."
    },
    {
        id: 2,
        title: "Kärcher K5 Power Control Magasnyomású Mosó",
        category: "Kerti eszközök",
        city: "Pécs",
        price: 4500,
        deposit: 30000,
        rating: 4.8,
        owner: "Szabó Péter",
        image: "https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=700&q=80",
        desc: "Térkő, autó és terasz tisztításához. 10 méteres magasnyomású tömlővel és szennymaró fejjel."
    },
    {
        id: 3,
        title: "Sony Alpha A7 III + 28-70mm Objektív",
        category: "Elektronika",
        city: "Budapest",
        price: 11500,
        deposit: 120000,
        rating: 5.0,
        owner: "Tóth Eszter",
        image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=700&q=80",
        desc: "Full-frame tükör nélküli fényképezőgép 64 GB SD kártyával, 2 pótakkumulátorral és hordtáskával."
    },
    {
        id: 4,
        title: "Quechua AirSeconds 4.1 Felfújható Sátor",
        category: "Kemping & Sport",
        city: "Szeged",
        price: 3800,
        deposit: 25000,
        rating: 4.7,
        owner: "Varga Márk",
        image: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&w=700&q=80",
        desc: "4 személyes, Fresh&Black technológiás sátor, 10 perc alatt felállítható. Pumpával együtt."
    },
    {
        id: 5,
        title: "JBL PartyBox 310 Hordozható Hangfal",
        category: "Rendezvény",
        city: "Pécs",
        price: 6500,
        deposit: 45000,
        rating: 4.9,
        owner: "Horváth Bence",
        image: "https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=700&q=80",
        desc: "240W teljesítmény, beépített fényeffektek, akár 18 óra akkumulátoros üzemidő házibulikhoz vagy kerti partikhoz."
    },
    {
        id: 6,
        title: "Makita DLM382Z Akkus Fűnyíró",
        category: "Kerti eszközök",
        city: "Debrecen",
        price: 4000,
        deposit: 25000,
        rating: 4.6,
        owner: "Nagy László",
        image: "https://images.unsplash.com/photo-1592417817098-8f3d691a4bf5?auto=format&fit=crop&w=700&q=80",
        desc: "Csendes, dupla 18V-os akkumulátoros fűnyíró 40 literes fűgyűjtő kosárral, akár 500 m² területre."
    },
    {
        id: 7,
        title: "Epson FullHD Házimozi és Prezentációs Projektor",
        category: "Elektronika",
        city: "Győr",
        price: 5500,
        deposit: 40000,
        rating: 4.8,
        owner: "Molnár Ádám",
        image: "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=700&q=80",
        desc: "3400 lumen fényerő, HDMI csatlakozás, 2 méteres kihúzható vetítővászonnal együtt."
    },
    {
        id: 8,
        title: "DeWalt DWE7485 Asztali Körfűrész",
        category: "Barkácsgépek",
        city: "Budapest",
        price: 5900,
        deposit: 40000,
        rating: 4.9,
        owner: "Farkas Gábor",
        image: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?auto=format&fit=crop&w=700&q=80",
        desc: "1850W-os precíziós asztali körfűrész párhuzamvezetővel és porelszívó adapterrel."
    }
];

let items = [...initialItems];
let favorites = new Set([1]);
let bookings = [
    {
        bookingId: 101,
        itemId: 2,
        title: "Kärcher K5 Power Control Magasnyomású Mosó",
        image: "https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=700&q=80",
        startDate: "2026-10-24",
        endDate: "2026-10-26",
        totalPaid: 9450
    }
];

let activeCategory = "all";
let currentModalItem = null;

const itemsGrid = document.getElementById("itemsGrid");
const resultsCountText = document.getElementById("resultsCountText");
const searchInput = document.getElementById("searchInput");
const cityFilter = document.getElementById("cityFilter");
const maxPriceRange = document.getElementById("maxPriceRange");
const priceValueLabel = document.getElementById("priceValueLabel");
const sortSelect = document.getElementById("sortSelect");
const categoryTabs = document.getElementById("categoryTabs");
const favCountBadge = document.getElementById("favCountBadge");
const bookingCountBadge = document.getElementById("bookingCountBadge");

function formatFt(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ") + " Ft";
}

function showToast(message) {
    const container = document.getElementById("toastContainer");
    const toast = document.createElement("div");
    toast.className = "toast";
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3200);
}

function renderItems() {
    const query = searchInput.value.trim().toLowerCase();
    const city = cityFilter.value;
    const maxPrice = Number(maxPriceRange.value);
    const sortBy = sortSelect.value;

    let filtered = items.filter(item => {
        const matchesQuery = item.title.toLowerCase().includes(query) || item.desc.toLowerCase().includes(query);
        const matchesCity = city === "all" || item.city === city;
        const matchesCat = activeCategory === "all" || item.category === activeCategory;
        const matchesPrice = item.price <= maxPrice;
        return matchesQuery && matchesCity && matchesCat && matchesPrice;
    });

    if (sortBy === "price-asc") filtered.sort((a, b) => a.price - b.price);
    if (sortBy === "price-desc") filtered.sort((a, b) => b.price - a.price);
    if (sortBy === "rating") filtered.sort((a, b) => b.rating - a.rating);

    resultsCountText.textContent = `Elérhető tárgyak (${filtered.length} db)`;
    itemsGrid.innerHTML = "";

    if (filtered.length === 0) {
        itemsGrid.innerHTML = `<p style="grid-column: 1/-1; color: #64748b; padding: 20px 0;">Nincs a szűrésnek megfelelő találat.</p>`;
        return;
    }

    filtered.forEach(item => {
        const isFav = favorites.has(item.id);
        const card = document.createElement("div");
        card.className = "item-card";
        card.innerHTML = `
            <div class="card-img-wrap" data-open-id="${item.id}">
                <img src="${item.image}" alt="${item.title}">
                <span class="card-cat-tag">${item.category}</span>
                <button class="fav-btn ${isFav ? 'active' : ''}" data-fav-id="${item.id}" title="Kedvenc">
                    ${isFav ? '❤️' : '🤍'}
                </button>
            </div>
            <div class="card-body">
                <div class="card-meta">
                    <span>📍 ${item.city}</span>
                    <span>⭐ ${item.rating.toFixed(1)}</span>
                </div>
                <div class="card-title" data-open-id="${item.id}">${item.title}</div>
                <div class="card-deposit">Kaució: ${formatFt(item.deposit)}</div>
                <div class="card-footer">
                    <div class="card-price">${formatFt(item.price)} <span>/ nap</span></div>
                    <button class="btn-primary" data-open-id="${item.id}">Kölcsönzés</button>
                </div>
            </div>
        `;
        itemsGrid.appendChild(card);
    });

    updateBadges();
}

function updateBadges() {
    favCountBadge.textContent = favorites.size;
    bookingCountBadge.textContent = bookings.length;
}

itemsGrid.addEventListener("click", (e) => {
    const favBtn = e.target.closest("[data-fav-id]");
    if (favBtn) {
        e.stopPropagation();
        const id = Number(favBtn.dataset.favId);
        if (favorites.has(id)) {
            favorites.delete(id);
            showToast("Eltávolítva a kedvencek közül.");
        } else {
            favorites.add(id);
            showToast("Hozzáadva a kedvencekhez! ❤️");
        }
        renderItems();
        return;
    }

    const openTrigger = e.target.closest("[data-open-id]");
    if (openTrigger) {
        const id = Number(openTrigger.dataset.openId);
        openBookingModal(id);
    }
});

const bookingModal = document.getElementById("bookingModal");
const startDateInput = document.getElementById("startDate");
const endDateInput = document.getElementById("endDate");

function openBookingModal(itemId) {
    currentModalItem = items.find(i => i.id === itemId);
    if (!currentModalItem) return;

    document.getElementById("modalItemImg").src = currentModalItem.image;
    document.getElementById("modalItemCat").textContent = currentModalItem.category;
    document.getElementById("modalItemCity").textContent = `📍 ${currentModalItem.city}`;
    document.getElementById("modalItemRating").textContent = `⭐ ${currentModalItem.rating.toFixed(1)}`;
    document.getElementById("modalItemTitle").textContent = currentModalItem.title;
    document.getElementById("modalItemDesc").textContent = currentModalItem.desc;
    document.getElementById("modalOwnerName").textContent = currentModalItem.owner;
    document.getElementById("modalOwnerAvatar").textContent = currentModalItem.owner.slice(0, 2).toUpperCase();
    document.getElementById("modalItemPrice").textContent = currentModalItem.price.toLocaleString("hu-HU");

    const today = new Date();
    const twoDaysLater = new Date(today);
    twoDaysLater.setDate(today.getDate() + 2);

    startDateInput.value = today.toISOString().split("T")[0];
    endDateInput.value = twoDaysLater.toISOString().split("T")[0];

    recalculateBookingPrice();
    bookingModal.classList.add("open");
}

function recalculateBookingPrice() {
    if (!currentModalItem) return;
    const start = new Date(startDateInput.value);
    const end = new Date(endDateInput.value);
    let diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
    if (isNaN(diffDays) || diffDays < 1) diffDays = 1;

    const baseTotal = diffDays * currentModalItem.price;
    const insurance = Math.round(baseTotal * 0.05);
    const grandTotal = baseTotal + insurance;

    document.getElementById("calcDays").textContent = `${diffDays} nap`;
    document.getElementById("calcBaseTotal").textContent = formatFt(baseTotal);
    document.getElementById("calcInsurance").textContent = formatFt(insurance);
    document.getElementById("calcDeposit").textContent = formatFt(currentModalItem.deposit);
    document.getElementById("calcGrandTotal").textContent = formatFt(grandTotal);
}

startDateInput.addEventListener("change", recalculateBookingPrice);
endDateInput.addEventListener("change", recalculateBookingPrice);

document.getElementById("closeBookingModal").addEventListener("click", () => {
    bookingModal.classList.remove("open");
});

document.getElementById("confirmBookingBtn").addEventListener("click", () => {
    if (!currentModalItem) return;
    const grandTotalText = document.getElementById("calcGrandTotal").textContent;
    const numericTotal = parseInt(grandTotalText.replace(/\D/g, ""), 10);

    bookings.push({
        bookingId: Date.now(),
        itemId: currentModalItem.id,
        title: currentModalItem.title,
        image: currentModalItem.image,
        startDate: startDateInput.value,
        endDate: endDateInput.value,
        totalPaid: numericTotal
    });

    updateBadges();
    bookingModal.classList.remove("open");
    showToast(`Sikeres foglalás: ${currentModalItem.title}! 🎉`);
});

const uploadModal = document.getElementById("uploadModal");
document.getElementById("openUploadModalBtn").addEventListener("click", () => {
    uploadModal.classList.add("open");
});
document.getElementById("closeUploadModal").addEventListener("click", () => {
    uploadModal.classList.remove("open");
});

document.getElementById("uploadForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const newItem = {
        id: Date.now(),
        title: document.getElementById("upTitle").value.trim(),
        category: document.getElementById("upCategory").value,
        city: document.getElementById("upCity").value,
        price: Number(document.getElementById("upPrice").value),
        deposit: Number(document.getElementById("upDeposit").value),
        rating: 5.0,
        owner: "Saját profilom",
        image: document.getElementById("upImage").value.trim() || "https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=700&q=80",
        desc: document.getElementById("upDesc").value.trim()
    };

    items.unshift(newItem);
    renderItems();
    e.target.reset();
    uploadModal.classList.remove("open");
    showToast("Az új tárgy sikeresen felkerült a kínálatba! 🚀");
});

const sideDrawerOverlay = document.getElementById("sideDrawerOverlay");
const drawerTitle = document.getElementById("drawerTitle");
const drawerContent = document.getElementById("drawerContent");

function openBookingsDrawer() {
    drawerTitle.textContent = "Aktív foglalásaim";
    drawerContent.innerHTML = "";

    if (bookings.length === 0) {
        drawerContent.innerHTML = `<p style="color:#64748b;">Még nincs aktív foglalásod.</p>`;
    } else {
        bookings.forEach(b => {
            const el = document.createElement("div");
            el.className = "drawer-item";
            el.innerHTML = `
                <img src="${b.image}" alt="${b.title}">
                <div class="drawer-item-info">
                    <h4>${b.title}</h4>
                    <p>${b.startDate} → ${b.endDate}</p>
                    <p><strong>Fizetve: ${formatFt(b.totalPaid)}</strong></p>
                </div>
                <button class="btn-danger-sm" data-cancel-id="${b.bookingId}">Lemondás</button>
            `;
            drawerContent.appendChild(el);
        });
    }
    sideDrawerOverlay.classList.add("open");
}

function openFavoritesDrawer() {
    drawerTitle.textContent = "Kedvenc tárgyaim";
    drawerContent.innerHTML = "";

    const favItems = items.filter(i => favorites.has(i.id));
    if (favItems.length === 0) {
        drawerContent.innerHTML = `<p style="color:#64748b;">Nincs elmentett kedvenc tárgyad.</p>`;
    } else {
        favItems.forEach(item => {
            const el = document.createElement("div");
            el.className = "drawer-item";
            el.innerHTML = `
                <img src="${item.image}" alt="${item.title}">
                <div class="drawer-item-info">
                    <h4>${item.title}</h4>
                    <p>📍 ${item.city} • ${formatFt(item.price)} / nap</p>
                </div>
                <button class="btn-primary" style="padding: 8px 12px; font-size: 12px;" data-drawer-open="${item.id}">Megnézem</button>
            `;
            drawerContent.appendChild(el);
        });
    }
    sideDrawerOverlay.classList.add("open");
}

document.getElementById("openBookingsBtn").addEventListener("click", openBookingsDrawer);
document.getElementById("openFavoritesBtn").addEventListener("click", openFavoritesDrawer);
document.getElementById("closeDrawerBtn").addEventListener("click", () => {
    sideDrawerOverlay.classList.remove("open");
});

drawerContent.addEventListener("click", (e) => {
    const cancelBtn = e.target.closest("[data-cancel-id]");
    if (cancelBtn) {
        const bId = Number(cancelBtn.dataset.cancelId);
        bookings = bookings.filter(b => b.bookingId !== bId);
        updateBadges();
        openBookingsDrawer();
        showToast("Foglalás sikeresen lemondva.");
    }

    const openBtn = e.target.closest("[data-drawer-open]");
    if (openBtn) {
        const itemId = Number(openBtn.dataset.drawerOpen);
        sideDrawerOverlay.classList.remove("open");
        openBookingModal(itemId);
    }
});

searchInput.addEventListener("input", renderItems);
cityFilter.addEventListener("change", renderItems);
sortSelect.addEventListener("change", renderItems);

maxPriceRange.addEventListener("input", (e) => {
    priceValueLabel.textContent = formatFt(Number(e.target.value));
    renderItems();
});

categoryTabs.addEventListener("click", (e) => {
    const btn = e.target.closest(".cat-tab");
    if (!btn) return;
    document.querySelectorAll(".cat-tab").forEach(t => t.classList.remove("active"));
    btn.classList.add("active");
    activeCategory = btn.dataset.cat;
    renderItems();
});

document.getElementById("resetFiltersBtn").addEventListener("click", () => {
    searchInput.value = "";
    cityFilter.value = "all";
    maxPriceRange.value = 15000;
    priceValueLabel.textContent = "15 000 Ft";
    sortSelect.value = "popular";
    activeCategory = "all";
    document.querySelectorAll(".cat-tab").forEach(t => t.classList.remove("active"));
    document.querySelector('.cat-tab[data-cat="all"]').classList.add("active");
    renderItems();
}); 

renderItems();
