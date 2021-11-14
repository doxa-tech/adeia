document.addEventListener("DOMContentLoaded", (e) => {
  
  const flash = document.querySelector("#flash")

  if (flash != null) {
    document.querySelector("#flash .close").addEventListener("click", () => {
      flash.remove()
    });
  }

});
