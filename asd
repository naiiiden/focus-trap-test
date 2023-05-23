<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        a, button, input {
            display: block;
            margin: 1rem 0;
            width: fit-content;
        }

        .modal, .modal-2 {
            display: none;
            border: 1px solid red;
            width: fit-content;
            padding: 2rem;
            position: relative;
            z-index: 9999;           
            background: mediumseagreen; 
        }

        .overlay {
            position: absolute;
            inset: 0 0 0 0;
            z-index: 9998;
            border: 1px solid red;
            background: skyblue;
        }
    </style>
</head>
<body>
    <h1>Focus Trap Test Page</h1>
    <a href="">very important link outside modal</a>
    <button class="open-close-modal">open modal</button>
    <div class="modal">
        <a href="">very important link</a>
        <div>
            <h2>this is a modal</h2>
        </div>
        <input type="text" name="" id="" placeholder="write something here"/>
        <input type="password" name="" id="" placeholder="password"/>
    </div>
    <button class="open-close-modal-2">open 2nd modal</button>
    <div class="modal-2">
        <div>
            <button class="open-close-modal-2">close modal 2 X</button>
            <h2>this is modal 2</h2>
        </div>
        <input type="date" name="" id="">
        <input type="color" name="" id="">
        <input type="file" name="" id="">
        <select>
            <option value="">1</option>
            <option value="">2</option>
            <option value="">3</option>
            <option value="">4</option>
            <option value="">5</option>
        </select>
        <input type="text" name="" id="" placeholder="write something here"/>
        <input type="password" name="" id="" placeholder="password"/>
        <input type="submit" value="submit" class="open-close-modal-2">
    </div>
    <a href="">very important link after the modal</a>
    <script>
        function createFocusTrap(modalElement, openModalButtons) {
            let openModal = false;
            let previousFocusElement = null;

            const toggleModal = () => {
                openModal = !openModal;
                if (openModal) {
                    previousFocusElement = document.activeElement;
                    
                    if (!document.querySelector('.overlay')) {
                        document.body.insertAdjacentHTML('afterbegin', '<div class="overlay"></div>');
                        document.querySelector('.overlay').addEventListener('click', () => {
                            console.log(1)
                        })
                    } else {
                        document.querySelector('.overlay').remove();
                    }
                }
            };

            const modalButtonsArray = Array.from(openModalButtons);

            modalButtonsArray.forEach((btn) => {
                btn.addEventListener("click", () => {
                    toggleModal();
                    modalElement.style.display = openModal ? "block" : "none";
                    focusTrap(modalElement);
                    // if (document.querySelector('.overlay')) {
                    //     document.querySelector('.overlay').remove();
                    // }
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

            document.addEventListener("click", (e) => {
                if (openModal && !modalElement.contains(e.target) && !modalButtonsArray.some(btn => btn.contains(e.target))) {
                    toggleModal();
                    modalElement.style.display = "none";
                    previousFocusElement.focus();
                    if (document.querySelector('.overlay')) {
                            document.querySelector('.overlay').remove();
                    }
                }
            });
        }

        createFocusTrap(document.querySelector('.modal'), document.querySelectorAll('.open-close-modal'));
        createFocusTrap(document.querySelector('.modal-2'), document.querySelectorAll('.open-close-modal-2'));
    </script>
</body>
</html>