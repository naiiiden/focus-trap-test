export default function createFocusTrap(modalElement, openModalButtons) {
    let openModal = false;
    let previousFocusElement = null;

    const toggleModal = () => {
        openModal = !openModal;
        if (openModal) {
            previousFocusElement = document.activeElement;

            if (!document.querySelector('.overlay')) {
                document.body.insertAdjacentHTML('afterbegin', '<div class="overlay"></div>');
                document.querySelector('.overlay').addEventListener('click', (e) => {
                    if (!modalElement.contains(e.target)) {
                        toggleModal();
                        modalElement.style.display = "none";
                        previousFocusElement.focus();
                        if (document.querySelector('.overlay')) {
                            document.querySelector('.overlay').remove();
                        }
                    }
                });
            }
        } else {
            document.querySelector('.overlay').remove();
        }
    };

    openModalButtons.forEach((btn) => {
        btn.addEventListener("click", () => {
            toggleModal();
            modalElement.style.display = openModal ? "block" : "none";
            focusTrap(modalElement);
        });
    });

    function focusTrap(modalElement) {
        const focusableElements = "a[href]:not([disabled]), button:not([disabled]), textarea:not([disabled]), input:not([disabled]):not([type='hidden']):not([type='radio']):not([type='checkbox']), select:not([disabled]), [contenteditable]:not([disabled]), [tabindex]:not([tabindex='-1'])";
        const firstFocusableElement = modalElement.querySelectorAll(focusableElements)[0];
        const focusableContent = modalElement.querySelectorAll(focusableElements);
        const lastFocusableElement = focusableContent[focusableContent.length - 1];


        document.addEventListener("keydown", (e) => {
            let isTabPressed = e.key === "Tab" || e.keyCode === 9;

            if ((e.key === "Escape" || e.keyCode === 27) && openModal) {
                toggleModal(); 
                modalElement.style.display = "none";
                previousFocusElement.focus(); 
                if (document.querySelector('.overlay')) {
                    document.querySelector('.overlay').remove();
                }
            }

            if (!isTabPressed) {
                return;
            }

            if (e.shiftKey) {
                if (document.activeElement === firstFocusableElement) {
                lastFocusableElement.focus();
                e.preventDefault();
                }
            } else {
                if (document.activeElement === lastFocusableElement) {
                firstFocusableElement.focus();
                e.preventDefault();
                }
            }
        });
        firstFocusableElement.focus();
    }
focusTrap(modalElement);
}