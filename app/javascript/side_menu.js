document.addEventListener("DOMContentLoaded", () => {
  const hamburger = document.querySelector(".hamburger");
  const sideMenu = document.querySelector(".side-menu");

  if (!hamburger || !sideMenu) return;

  hamburger.addEventListener("click", () => {
    sideMenu.classList.toggle("open");
  });
});