document.addEventListener("turbo:load", () => {
  console.log("turbo loaded");

  const hamburger = document.querySelector(".hamburger");
  const sideMenu = document.querySelector(".side-menu");

  if (!hamburger || !sideMenu) return;

  hamburger.addEventListener("click", () => {
    console.log("clicked");
    sideMenu.classList.toggle("open");
  });
});