const listaPokemon = document.querySelector("#lista-pokemon");
const spinner = document.querySelector("#spinner");
const mensajeError = document.querySelector("#mensaje-error");
const btnCargarMas = document.querySelector("#btn-cargar-mas");

const modalPokemon = new bootstrap.Modal(
    document.querySelector("#modalPokemon")
);

const modalContenido = document.querySelector("#modal-contenido");
const modalTitulo = document.querySelector("#modalPokemonLabel");

let cantidadPokemon = 151;
let offset = 0;


// Mostrar spinner
function mostrarSpinner() {
    spinner.classList.remove("d-none");
}


// Ocultar spinner
function ocultarSpinner() {
    spinner.classList.add("d-none");
}


// Obtener Pokémon de la API
async function obtenerPokemon() {

    mostrarSpinner();
    mensajeError.classList.add("d-none");

    try {

        const respuesta = await fetch(
            `https://pokeapi.co/api/v2/pokemon?limit=${cantidadPokemon}&offset=${offset}`
        );

        if (!respuesta.ok) {
            throw new Error("Error al obtener los Pokémon");
        }

        const datos = await respuesta.json();

        const detallesPokemon = await Promise.all(
            datos.results.map(function (pokemon) {
                return obtenerDetallePokemon(pokemon.url);
            })
        );

        detallesPokemon.forEach(function (pokemon) {
            crearCartaPokemon(pokemon);
        });

        offset += cantidadPokemon;

    } catch (error) {

        console.error(error);

        mensajeError.classList.remove("d-none");

    } finally {

        ocultarSpinner();
    }
}


// Obtener información detallada
async function obtenerDetallePokemon(url) {

    const respuesta = await fetch(url);

    if (!respuesta.ok) {
        throw new Error("No se pudo obtener el Pokémon");
    }

    return await respuesta.json();
}


// Crear carta
function crearCartaPokemon(pokemon) {

    const columna = document.createElement("div");

    columna.classList.add(
        "col-12",
        "col-sm-6",
        "col-md-4",
        "col-lg-3"
    );

    const tipos = pokemon.types.map(function (tipo) {

        return `
            <span class="tipo">
                ${tipo.type.name}
            </span>
        `;

    }).join("");


    columna.innerHTML = `

        <div class="card card-pokemon shadow-sm">

            <img
                src="${pokemon.sprites.other["official-artwork"].front_default}"
                class="card-img-top imagen-pokemon"
                alt="${pokemon.name}"
            >

            <div class="card-body text-center">

                <h5 class="card-title nombre-pokemon">
                    #${pokemon.id} ${pokemon.name}
                </h5>

                <div class="mb-3">
                    ${tipos}
                </div>

                <button
                    class="btn btn-danger"
                    onclick="mostrarInformacionPokemon(${pokemon.id})"
                >
                    Ver más
                </button>

            </div>

        </div>

    `;

    listaPokemon.appendChild(columna);
}


// Mostrar información completa
async function mostrarInformacionPokemon(id) {

    mostrarSpinner();

    try {

        const respuesta = await fetch(
            `https://pokeapi.co/api/v2/pokemon/${id}`
        );

        if (!respuesta.ok) {
            throw new Error("Error al obtener información");
        }

        const pokemon = await respuesta.json();

        modalTitulo.textContent =
            `#${pokemon.id} ${pokemon.name}`;


        // Tipos
        const tipos = pokemon.types.map(function (tipo) {

            return `
                <span class="tipo">
                    ${tipo.type.name}
                </span>
            `;

        }).join("");


        // Habilidades
        const habilidades = pokemon.abilities.map(function (habilidad) {

            return `
                <div class="habilidad">
                    ${habilidad.ability.name}
                </div>
            `;

        }).join("");


        // Movimientos
        const movimientos = pokemon.moves
            .slice(0, 4)
            .map(function (movimiento) {

                return `
                    <li class="list-group-item text-capitalize">
                        ${movimiento.move.name}
                    </li>
                `;

            }).join("");


        modalContenido.innerHTML = `

            <div class="text-center">

                <img
                    src="${pokemon.sprites.other["official-artwork"].front_default}"
                    class="modal-imagen"
                    alt="${pokemon.name}"
                >

                <h3 class="text-capitalize mt-3">
                    ${pokemon.name}
                </h3>

                <p>
                    <strong>Altura:</strong>
                    ${pokemon.height / 10} m
                </p>

                <p>
                    <strong>Peso:</strong>
                    ${pokemon.weight / 10} kg
                </p>

                <h5>Tipos</h5>

                <div class="mb-4">
                    ${tipos}
                </div>

                <h5>Habilidades</h5>

                <div class="mb-4">
                    ${habilidades}
                </div>

                <h5>Movimientos</h5>

                <ul class="list-group lista-movimientos">
                    ${movimientos}
                </ul>

            </div>

        `;

        modalPokemon.show();

    } catch (error) {

        console.error(error);

        modalContenido.innerHTML = `
            <div class="alert alert-danger">
                No se pudo cargar la información del Pokémon.
            </div>
        `;

        modalPokemon.show();

    } finally {

        ocultarSpinner();
    }
}


// Cargar más Pokémon
btnCargarMas.addEventListener("click", function () {

    cantidadPokemon = 20;

    obtenerPokemon();

});


// Cargar los primeros 151 al iniciar
obtenerPokemon();
