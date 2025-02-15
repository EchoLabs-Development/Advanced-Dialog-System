window.addEventListener("message", function(event) {

  if (!event.data || !event.data.action) {
      return;
  }
  if (event.data.action === "openDialog") {
      document.getElementById("dialogTitle").innerText = event.data.title || "Are you sure?";
      document.getElementById("dialogText").innerText = event.data.text || "Are you sure you want to proceed?";
      document.querySelector(".dialog").style.display = "block";
      document.body.style.display = "flex";
  } else if (event.data.action === "closeDialog") {
      closeDialog();
  } else if (event.data.action === "openAlert") {
      document.getElementById("alertTitle").innerText = event.data.title || "Alert";
      document.getElementById("alertText").innerText = event.data.text || "This is an alert message.";
      document.querySelector(".alert").style.display = "block";
      document.body.style.display = "flex";
  } else if (event.data.action === "closeAlert") {
      closeAlert();
  } else if (event.data.action === "openInput") {
      document.getElementById("inputTitle").innerText = event.data.title || "Input";
      document.getElementById("inputDescription").innerText = event.data.description || "Enter your details below.";
      let inputContainer = document.getElementById("inputFields");
      inputContainer.innerHTML = ""; // Clear previous inputs
      event.data.inputs.forEach((input, index) => {
          let inputHTML = `
              <div class="input-group">
                  <label>${input.label}</label>
                  <input type="${input.type}" class="input-field" id="input${index}" placeholder="${input.placeholder}" oninput="checkInputs()">
              </div>
          `;
          inputContainer.innerHTML += inputHTML;
      });
      document.querySelector(".input-dialog").style.display = "block";
      document.body.style.display = "flex";
      checkInputs();
  } else if (event.data.action === "closeInput") {
      closeInput();
  }
});

function closeDialog() {
  document.querySelector(".dialog").style.display = "none";
  document.body.style.display = "none";
}

function closeAlert() {
  document.querySelector(".alert").style.display = "none";
  document.body.style.display = "none";
  // Echo Labs
}

function closeInput() {
  document.querySelector(".input-dialog").style.display = "none";
  document.body.style.display = "none";
}

function handleConfirm() {
  closeDialog();
  fetch(`https://${GetParentResourceName()}/dialogResponse`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ response: true })
  })
}

function handleDecline() {
  closeDialog();
  closeAlert();
  closeInput();
  fetch(`https://${GetParentResourceName()}/dialogResponse`, {
    // Echo Labs
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ response: false })
  })
}

function handleAlertOK() {
  closeAlert();
  fetch(`https://${GetParentResourceName()}/alertResponse`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  })
  // Echo Labs
}

function handleInputSubmit() {
  let inputFields = document.querySelectorAll(".input-field");
  let values = [];
  let emptyFields = false;
  inputFields.forEach((input) => {
      let value = input.value.trim();
      values.push(value);
      if (value === "") {
          emptyFields = true;
      }
  });
  if (emptyFields) {
      alert("⚠️ Please fill in all fields before confirming.");
      return;
  }
  closeInput();
  fetch(`https://${GetParentResourceName()}/inputResponse`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ values: values })
  })
}

function checkInputs() {
  let inputFields = document.querySelectorAll(".input-field");
  let confirmButton = document.querySelector(".input-dialog .confirm");
  let allFilled = true;

  inputFields.forEach((input) => {
      if (input.value.trim() === "") {
          allFilled = false;
      }
  });

  confirmButton.disabled = !allFilled;
}
// Echo Labs