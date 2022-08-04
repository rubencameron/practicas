// SE CREA LA FUNCION PRIMERO Y DESPUES AL LLAMARLA 
//SE LE PASAN LOS PARAMETROS

/*function suma(num1, num2){
    let res = num1 + num2;
    document.write(res);
    document.write("<br>");
    return(`Tu resultado esta correcto`);
}

suma(12, 32);


let elResultadi = suma(3, 5);
document.write(elResultadi);*/


// 1 FUNCION SALUDAR

/*function saludar(nombre){
    let frase = `Hola! ${nombre}, como estas?`
    document.write(frase);
}

saludar(`Ruben`);*/


// 2 OTRA FORMA DE CREAR FUNCIONES

/*const saludar = function(nombre){
    let frase = `Hola! ${nombre}, como estas?`
    document.write(frase);
}*/


// 3 FUNCIONES FLECHA. SE REEMPLAZA LA PALABRA FUNCTION CON LA FLECHA

const saludar = (nombre)=>{
    let frase = `Holis! ${nombre}, como estas?`
    return frase;
}

let respuesta = saludar (`Ruben`);
document.write(respuesta);