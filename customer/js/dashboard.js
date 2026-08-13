// ===============================
// PUSTAKMANDI CUSTOMER DASHBOARD
// dashboard.js
// ===============================

// Sidebar Toggle

const sidebar = document.querySelector(".sidebar");

const menuBtn = document.createElement("button");

menuBtn.innerHTML = '<i class="fa-solid fa-bars"></i>';

menuBtn.className = "menu-btn";

document.querySelector(".topbar").prepend(menuBtn);

menuBtn.onclick = function () {
  sidebar.classList.toggle("show");
};

// ===============================
// Active Sidebar Menu
// ===============================

const menuLinks = document.querySelectorAll(".sidebar ul li");

menuLinks.forEach((link) => {
  link.addEventListener("click", function () {
    menuLinks.forEach((item) => item.classList.remove("active"));

    this.classList.add("active");
  });
});

// ===============================
// Card Animation
// ===============================

const cards = document.querySelectorAll(".card");

cards.forEach((card, index) => {
  card.style.opacity = "0";

  card.style.transform = "translateY(30px)";

  setTimeout(() => {
    card.style.transition = ".5s";

    card.style.opacity = "1";

    card.style.transform = "translateY(0)";
  }, index * 150);
});

// ===============================
// Live Clock
// ===============================

const clock = document.createElement("div");

clock.className = "clock";

document.querySelector(".topbar").appendChild(clock);

function updateClock() {
  const now = new Date();

  clock.innerHTML = now.toLocaleTimeString();
}

setInterval(updateClock, 1000);

updateClock();

// ===============================
// Welcome Message
// ===============================

const hour = new Date().getHours();

let greeting = "Welcome";

if (hour < 12) {
  greeting = "Good Morning ☀️";
} else if (hour < 17) {
  greeting = "Good Afternoon 🌞";
} else {
  greeting = "Good Evening 🌙";
}

document.querySelector(".welcome h1").innerHTML =
  greeting + ", " + document.querySelector(".user-info span").innerText;

// ===============================
// Notification
// ===============================

document.querySelector(".notification").onclick = function () {
  alert("No new notifications.");
};

// ===============================
// Search
// ===============================

const search = document.querySelector(".search input");

search.addEventListener("keyup", () => {
  console.log("Searching : " + search.value);
});

// ===============================
// Dashboard Loaded
// ===============================

console.log("Customer Dashboard Loaded Successfully.");
