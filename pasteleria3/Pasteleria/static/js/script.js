document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("loginModal");
  const btnUser = document.getElementById("btnUser");
  const closeModal = document.getElementById("closeModal");

  if (btnUser) {
    btnUser.addEventListener("click", function (e) {
      e.preventDefault();
      modal.style.display = "block";
    });
  }

  closeModal.addEventListener("click", function () {
    modal.style.display = "none";
  });

  window.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });

  // Mostrar el modal si el backend lo indica
  const mostrarModal = document.body.getAttribute("data-modal");
  if (mostrarModal === "true") {
    modal.style.display = "block";
  }
});
