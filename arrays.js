// Ejemplo de Arrays Asociativos

/*let pc1 = {
    nombre: "DaltoPC",
    procesador: "Intel Core I7",
    ram: "16GB",
    espacio: "1TB"
};

let nombre = pc1["nombre"];
let procesador = pc1["procesador"];
let ram = pc1["ram"];
let espacio = pc1["espacio"];

let frase = `el nombre de mi PC es: ${nombre} <br>
             el procesador es de: ${procesador} <br>
             la memoria ram es de: ${ram} <br>
             el espacio en disco es de: ${espacio}`;

document.write(frase);   */          

// Ejemplo de bucle while y derivados
// El while NUNCA va a ejecutar el codigo, si la condicion es falsa
// Mientras que el do while primero ejecuta el codigo, despues pregunta
// y si es falso, ya no lo ejecuta mas 

let numero = 0;
do{
    numero++;
    document.write(numero);
}

while(numero<=10);

// Al ejecutarse el break ya no se ejecuta el while

/*let numero = 0;
while(numero < 1000){
    numero++;
    document.write(numero + "<br>");
    if(numero == 10){
        break;
    }
}*/
