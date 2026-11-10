
// ==========================================
// CONFIGURACION INICIAL
// ==========================================

const API_URL = "https://pokeapi.co/api/v2/pokemon/";

const contenedor = document.getElementById("contenedor-pokemon");
const spinner = document.getElementById("spinner");
const botonMas = document.getElementById("btn-cargar-mas");
const buscador = document.getElementById("buscador");
const mensajeError = document.getElementById("mensaje-error");

let cantidadPokemon = 151;
let pokemonCargados = [];
let cargando = false;


// ==========================================
// COLORES DE LOS TIPOS
// ==========================================

const coloresTipos = {
    normal: "#A8A77A",
    fire: "#EE8130",
    water: "#6390F0",
    electric: "#F7D02C",
    grass: "#7AC74C",
    ice: "#96D9D6",
    fighting: "#C22E28",
    poison: "#A33EA1",
    ground: "#E2BF65",
    flying: "#A98FF3",
    psychic: "#F95587",
    bug: "#A6B91A",
    rock: "#B6A136",
    ghost: "#735797",
    dragon: "#6F35FC",
    dark: "#705746",
    steel: "#B7B7CE",
    fairy: "#D685AD"
};


// ==========================================
// MOSTRAR SPINNER
// ==========================================

function mostrarSpinner() {
    spinner.classList.remove("d-none");
    botonMas.disabled = true;
}

function ocultarSpinner() {
    spinner.classList.add("d-none");
    botonMas.disabled = false;
}


// ==========================================
// CARGAR POKEMON DESDE LA API
// ==========================================

async function cargarPokemon() {

    if (cargando) return;

    cargando = true;
    mostrarSpinner();
    mensajeError.classList.add("d-none");
    botonMas.classList.add("d-none");

    try {

        const respuesta = await fetch(
            `${API_URL}?limit=${cantidadPokemon}&offset=0`
        );

        if (!respuesta.ok) {
            throw new Error("Error al consultar la API");
        }

        const datos = await respuesta.json();

        // Obtener información completa de cada Pokémon
        const resultados = await Promise.all(
            datos.results.map(async (pokemon) => {

                const respuestaPokemon = await fetch(pokemon.url);

                if (!respuestaPokemon.ok) {
                    throw new Error("Error al obtener un Pokémon");
                }

                return await respuestaPokemon.json();

            })
        );

        pokemonCargados = resultados;

        mostrarPokemon(pokemonCargados);

        botonMas.classList.remove("d-none");

    } catch (error) {

        console.error("Error:", error);

        mensajeError.classList.remove("d-none");

    } finally {

        ocultarSpinner();
        cargando = false;

    }

}


// ==========================================
// MOSTRAR TARJETAS DE POKEMON
// ==========================================

function mostrarPokemon(lista) {

    contenedor.innerHTML = "";

    if (lista.length === 0) {

        contenedor.innerHTML = `
            <div class="col-12 text-center">
                <h4>No se encontraron Pokémon.</h4>
            </div>
        `;

        return;
    }

    lista.forEach(pokemon => {

        const tipos = pokemon.types.map(tipo => {

            const nombreTipo = tipo.type.name;
            const color = coloresTipos[nombreTipo] || "#777";

            return `
                <span class="tipo" style="background-color: ${color}">
                    ${nombreTipo}
                </span>
            `;

        }).join("");

        const tarjeta = document.createElement("div");

        tarjeta.className = "col-12 col-sm-6 col-md-4 col-lg-3";

        tarjeta.innerHTML = `

            <div class="tarjeta-pokemon">

                <img
                    src="${pokemon.sprites.other['official-artwork'].front_default || pokemon.sprites.front_default}"
                    alt="${pokemon.name}"
                    loading="lazy"
                >

                <h5>${pokemon.name}</h5>

                <p>
                    N.º ${String(pokemon.id).padStart(3, "0")}
                </p>

                <div>
                    ${tipos}
                </div>

                <button
                    class="btn btn-danger mt-3"
                    onclick="verInformacion(${pokemon.id})">

                    Ver más información

                </button>

            </div>

        `;

        contenedor.appendChild(tarjeta);

    });

}


// ==========================================
// VER INFORMACION DE UN POKEMON
// ==========================================

function verInformacion(id) {

    const pokemon = pokemonCargados.find(
        p => p.id === id
    );

    if (!pokemon) return;

    const imagen =
        pokemon.sprites.other['official-artwork'].front_default ||
        pokemon.sprites.front_default;

    // Obtener habilidades
    const habilidades = pokemon.abilities.map(habilidad => {

        return habilidad.ability.name;

    }).join(", ");

    // Obtener los primeros cuatro movimientos
    const movimientos = pokemon.moves
        .slice(0, 4)
        .map(movimiento => {

            return `<li>${movimiento.move.name}</li>`;

        }).join("");

    const tipos = pokemon.types.map(tipo => {

        return tipo.type.name;

    }).join(", ");

    const contenido = document.getElementById("modal-contenido");

    contenido.innerHTML = `

        <img src="${imagen}" alt="${pokemon.name}">

        <h4>${pokemon.name}</h4>

        <p><strong>Número:</strong> ${pokemon.id}</p>

        <p><strong>Tipos:</strong> ${tipos}</p>

        <p><strong>Altura:</strong> ${pokemon.height / 10} metros</p>

        <p><strong>Peso:</strong> ${pokemon.weight / 10} kg</p>

        <hr>

        <h5>Habilidades</h5>

        <p>${habilidades}</p>

        <hr>

        <h5>Primeros cuatro movimientos</h5>

        <ul class="lista-movimientos">
            ${movimientos}
        </ul>

    `;

    document.getElementById("modal-titulo").textContent =
        "Información de " + pokemon.name;

    const modal = new bootstrap.Modal(
        document.getElementById("modalPokemon")
    );

    modal.show();

}


// ==========================================
// CARGAR MAS POKEMON
// ==========================================

async function cargarMasPokemon() {

    if (cargando) return;

    cargando = true;
    botonMas.disabled = true;
    mostrarSpinner();

    const nuevosPokemon = [];

    try {

        const respuesta = await fetch(
            `${API_URL}?limit=20&offset=${pokemonCargados.length}`
        );

        if (!respuesta.ok) {
            throw new Error("No se pudieron cargar más Pokémon");
        }

        const datos = await respuesta.json();

        const resultados = await Promise.all(
            datos.results.map(async pokemon => {

                const respuestaPokemon = await fetch(pokemon.url);

                if (!respuestaPokemon.ok) {
                    throw new Error("Error al obtener un Pokémon");
                }

                return await respuestaPokemon.json();

            })
        );

        nuevosPokemon.push(...resultados);

        pokemonCargados.push(...nuevosPokemon);

        // Mostrar todos los Pokémon cargados
        mostrarPokemon(pokemonCargados);

        // Actualizar el buscador
        buscador.value = "";

    } catch (error) {

        console.error(error);

        mensajeError.textContent =
            "No se pudieron cargar más Pokémon. Intentá nuevamente.";

        mensajeError.classList.remove("d-none");

    } finally {

        ocultarSpinner();
        cargando = false;

        botonMas.disabled = false;

    }

}


// ==========================================
// BUSCADOR DE POKEMON
// ==========================================

buscador.addEventListener("input", function() {

    const texto = buscador.value.toLowerCase().trim();

    const filtrados = pokemonCargados.filter(pokemon => {

        return pokemon.name.includes(texto) ||
            String(pokemon.id) === texto;

    });

    mostrarPokemon(filtrados);

    // Ocultar botón mientras se busca
    if (texto !== "") {

        botonMas.classList.add("d-none");

    } else {

        botonMas.classList.remove("d-none");

    }

});


// ==========================================
// EVENTO DEL BOTON CARGAR MAS
// ==========================================

botonMas.addEventListener("click", cargarMasPokemon);


// ==========================================
// INICIAR APLICACION
// ==========================================

cargarPokemon();
