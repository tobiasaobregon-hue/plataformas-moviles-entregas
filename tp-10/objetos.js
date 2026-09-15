var personaEjemplo = {
    apellido: "Perez",
    nombre: "Juan",
    edad: 20,
    documento: 12345
};

// 01 - crearPersona
function crearPersona(nombre, apellido, edad, documento) {
    return {
        nombre: nombre,
        apellido: apellido,
        edad: edad,
        documento: documento
    };
}

console.log("resultado crearPersona: ",
    crearPersona("Juan", "Pérez", 20, 123456)
);


// 02 - agregarApodo
function agregarApodo(persona, apodo) {
    persona.apodo = apodo;
    return persona;
}

console.log("resultado agregarApodo: ",
    agregarApodo(personaEjemplo, "JuanPe")
);


// 03 - sinDocumento
function sinDocumento(persona) {
    delete persona.documento;
    return persona;
}

console.log("resultado sinDocumento: ",
    sinDocumento(personaEjemplo)
);


// 04 - tieneDocumento
function tieneDocumento(persona) {
    return "documento" in persona;
}

console.log("resultado tieneDocumento: ",
    tieneDocumento(personaEjemplo)
);


// 05 - nombreCompletoDePersona
function nombreCompletoDePersona(persona) {
    return persona.apellido + ", " + persona.nombre;
}

console.log("resultado nombreCompletoDePersona: ",
    nombreCompletoDePersona(personaEjemplo)
);


// 06 - felizCumpleaños
function felizCumpleaños(persona) {
    persona.edad = persona.edad + 1;
    return persona;
}

console.log("resultado felizCumpleaños: ",
    felizCumpleaños(personaEjemplo)
);


// 07 - sonLaMismaPersona
function sonLaMismaPersona(persona1, persona2) {
    return persona1.documento === persona2.documento;
}

console.log("resultado sonLaMismaPersona: ",
    sonLaMismaPersona(
        {
            apellido: "Perez",
            nombre: "Juan",
            edad: 20,
            documento: 12345
        },
        {
            apellido: "Perez",
            nombre: "Juan",
            edad: 20,
            documento: 12345
        }
    )
);


// 08 - personaMasGrande
function personaMasGrande(persona1, persona2) {
    if (persona1.edad >= persona2.edad) {
        return persona1;
    } else {
        return persona2;
    }
}

console.log("resultado personaMasGrande: ",
    personaMasGrande(
        {
            nombre: "Ana",
            edad: 30
        },
        {
            nombre: "Luis",
            edad: 25
        }
    )
);
