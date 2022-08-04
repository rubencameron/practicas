// Bucle for
// Break termina el bucle
// Continue solo corta la iteracion 

/*for(let i = 0; i < 5; i++){
    
    if(i == 3){
        continue;
    }
   
    document.write(i + "<br>");
}*/


// For in muestra la posicion de los elementos
// For of muestra el valor de esos elementos

/*let animales = ["gato", "perro", "tiranosaurio rex"];

for(let animal in animales){
    document.write(animal + "<br>");
}
document.write("<br>");

for(let animal of animales){
    document.write(animal + "<br>");
}*/


let array1 = ["maria", "josefa", "roberta"];
let array2 = ["pedro", "marcelo", array1, "josefina"];

forRancio:
for(let array in array2){
    if(array == 2){
        for(let array of array1){
            document.write(array + "<br>");
        };
    }else{
        document.write(array2[array] + "<br>");
    }
}

