document.addEventListener("DOMContentLoaded", function() {
    const colorRadios = document.querySelectorAll('input[name="color"]');
    const letraRadios = document.querySelectorAll('input[name="letra"]');
    const cells = document.querySelectorAll("table:last-of-type td");

    for (let i = 0; i < colorRadios.length; i++) {
        colorRadios[i].addEventListener("change", function() {
            updateTable();
        });
    }

    for (let i = 0; i < letraRadios.length; i++) {
        letraRadios[i].addEventListener("change", function() {
            updateTable();
        });
    }

    function updateTable() {
        const selectedColor = document.querySelector('input[name="color"]:checked').value;
        const selectedLetter = document.querySelector('input[name="letra"]:checked').value;

        // Reiniciar la tabla
        cells.forEach(cell => {
            cell.style.backgroundColor = "";
            cell.textContent = "";
        });

        // Si se selecciona T y azul, modifica la tabla
        if (selectedLetter === "t") {
            const color = selectedColor === "azul" ? "blue" : (selectedColor === "naranja" ? "orange" : "purple");
            for (let i = 0; i < 5; i++) {
                if (i !== 0 && i !== 4) {
                    cells[i].style.backgroundColor = color; // primera fila, excepto el primero y el último
                }
                cells[i * 5 + 2].style.backgroundColor = color; // columna 3
            }
        }
        else if (selectedLetter === "f") {
            const color = selectedColor === "azul" ? "blue" : (selectedColor === "naranja" ? "orange" : "purple");
            for (let i = 0; i < 5; i++) {
                if (i !== 0 && i !== 4) {
                    cells[i].style.backgroundColor = color; // primera fila, excepto el primero y el último
                }
            }
            for (let i = 0; i < 5; i++) {
                cells[i * 5 + 1].style.backgroundColor = color; // columna 2
                cells[2 * 5 + 2].style.backgroundColor = color; // tercer componente del tercer reglón
            }
        
        } else if (selectedLetter === "l") {
            const color = selectedColor === "azul" ? "blue" : (selectedColor === "naranja" ? "orange" : "purple");
            for (let i = 0; i < 5; i++) {
                if (i !== 0 && i !== 4) {
                    cells[(4 * 5) + i].style.backgroundColor = color; // última fila, excepto el primero y el último
                }
                cells[i * 5 + 1].style.backgroundColor = color; // columna 2
            }
        }
    }

    // Llamar a updateTable al inicio para que refleje el estado inicial de los radios
    updateTable();
});
