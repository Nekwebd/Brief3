const apiUrl = "https://reqres.in/api/users?per_page=12";

let modal = document.createElement("div");
modal.id = "userModal";
modal.classList.add("modal");
modal.style.display = "none";
document.body.appendChild(modal);

let overlay = document.createElement("div");
overlay.id = "overlay";
overlay.classList.add("overlay");
overlay.style.display = "none";
document.body.appendChild(overlay);

async function fetchUsers() {
  try {
    const response = await fetch(apiUrl);
    if (!response.ok) {
      throw new Error(`API request failed with status: ${response.status}`);
    }
    const jsonData = await response.json();
    return jsonData.data;
  } catch (error) {
    console.error("Error fetching users:", error);
    return [];
  }
}

async function renderUsers() {
  const usersContainer = document.getElementById("users-container");
  const users = await fetchUsers();

  users.forEach((user, index) => {
    const cardElement = document.createElement("div");
    cardElement.classList.add("card");
    cardElement.id = `userCard${index}`;
    cardElement.innerHTML = `
        <h1>${user.first_name}</h1>
        <a href="mailto:${user.email}">${user.email}</a>
        <img src="${user.avatar}" alt="${user.first_name} avatar" />
    `;
    cardElement.addEventListener("click", () => {
      openModal(user);
    });
    usersContainer.appendChild(cardElement);
  });
}

function openModal(user) {
  modal.innerHTML = `
      <div id="userInfo" class="modal-content">
          <h2>${user.first_name} ${user.last_name} <button id="closeButtonModal" class="modal-close">&times</button></h2>
          <a href="mailto:${user.email}">${user.email}</a>
          <img src="${user.avatar}" alt="${user.first_name} avatar" />
          <p>Le petit texte de présentation, faut imaginer en revanche.</p>
      </div>
      <button id="closeButtonOutside" class="modal-close"></button>
  `;

  modal.style.display = "block";
  overlay.style.display = "block";
  const closeButtonModal = document.querySelector("#closeButtonModal");
  const closeButtonOutside = document.querySelector("#closeButtonOutside");
  closeButtonModal.addEventListener("click", closeModal);
  closeButtonOutside.addEventListener("click", closeModal);
}

function closeModal() {
  modal.style.display = "none";
  overlay.style.display = "none";
}
overlay.addEventListener("click", closeModal);

renderUsers();
