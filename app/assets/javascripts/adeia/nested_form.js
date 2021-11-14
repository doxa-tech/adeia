const addButton = document.querySelector(".add-fields")
addButton.addEventListener("click", (e) => {
  e.preventDefault();
  let count = Number(e.target.dataset.count) + 1;
  const type = e.target.dataset.type;
  const lastFields = document.querySelectorAll("." + type + "-fields");
  const lastField = lastFields[lastFields.length - 1]
  const newFields = lastField.cloneNode(true);
  const label = newFields.querySelector("label");
  label.setAttribute("for", label.getAttribute("for").replace(/\d/, count));
  newFields.querySelectorAll("input, select").forEach(element => {
    element.setAttribute("name", element.getAttribute("name").replace(/\d/, count));
    element.setAttribute("id", element.getAttribute("id").replace(/\d/, count));
    element.value = ""
  });
  lastField.after(newFields);
  newFields.style.display = "block";
  e.target.dataset.count = Number(count) + 1;
})

const fieldsFor = document.querySelector(".fields-for");
fieldsFor.addEventListener("click", (e) => {
  if (e.target.classList.contains("remove-fields")) {
    e.preventDefault();
    const type = e.target.dataset.type;
    const fields = e.target.closest("." + type + "-fields");
    fields.querySelector("input[identifier=destroy]").value = 1
    fields.style.display = "none";
  }
})