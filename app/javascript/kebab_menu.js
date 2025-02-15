document.addEventListener("turbo:load", function() {
  const menuButtons = document.querySelectorAll(".menu-btn");

  menuButtons.forEach((button) => {
    button.addEventListener("click", function (event) {
      event.stopPropagation(); // 他のクリックイベントを無視

      // すべてのメニューを閉じる
      document.querySelectorAll(".menu-content").forEach((menu) => {
        if (menu !== this.nextElementSibling) {
          menu.classList.remove("active");
        }
      });

      // クリックしたメニューを開閉
      const menu = this.nextElementSibling;
      menu.classList.toggle("active");
    });
  });

  // メニュー外をクリックしたら閉じる
  document.addEventListener("click", () => {
    document.querySelectorAll(".menu-content").forEach((menu) => {
      menu.classList.remove("active");
    });
  });
});