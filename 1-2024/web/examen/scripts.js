document.addEventListener("DOMContentLoaded", function() {

    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(event) {
            event.preventDefault();
            document.getElementById('mensajeConfirmacion').style.display = 'block';
        });
    }

    function activateLoginModal() {
        const loginButton = document.querySelector('button[data-target="#loginModal"]');
        const loginModal = document.getElementById('loginModal');
        const closeModalButton = loginModal.querySelector('.close');

        loginButton.addEventListener('click', function() {
            loginModal.style.display = 'block';
        });

        closeModalButton.addEventListener('click', function() {
            loginModal.style.display = 'none';
        });
    }
});
