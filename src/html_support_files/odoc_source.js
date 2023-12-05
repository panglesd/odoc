document.querySelectorAll(".summary").forEach((elem) => {
  elem.addEventListener("click", (ev) => {
    document.querySelectorAll(".summary.open").forEach((e) => {
      if (e != ev.currentTarget) e.classList.remove("open");
    });
    ev.currentTarget.classList.toggle("open");
  });
});
