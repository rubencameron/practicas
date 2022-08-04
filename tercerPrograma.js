
/*function holis(nombre){
    let answer = nombre;
    return `Hola ${answer}! <br> Que tal todo`
}

let respuesta = holis('Ruben');
document.write(respuesta);*/


/*const holis = (nombre)=>{
    let answer = nombre;
    return `Hola ${answer}! <br> Que tal todo?`
}

let respuesta = holis(prompt(`Como te llamas?`));
document.write(respuesta);*/


//DOS FORMAS DE HACER LA FUNCION, DAN EL MISMO RESULTADO 

const holis = (nombre)=>{
    let answer = nombre;
    return `Hola ${answer}! <br> Que tal todo?`
}

let question = prompt(`te interesa saber mas?`)

if(question == `si`){
    let respuesta = holis(prompt(`Como te llamas?`));
    document.write(respuesta);
}else if(question == `puede ser` || question == `tal vez`){
    alert(`oki doki xd`);
}else if(question == `mejor quiero un bucle`){
    alert(`aca tenes tu bucle mi REY`);
    for(let i=1; i<5; i++){
        document.write(`Este es tu bucle` + '<br>');
    }
}else{
    alert(`Aqui termina todillo`);
}