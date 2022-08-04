/* Cuando decimos this nos referimos al new objeto 
   que creamos */ 

/*class Employee{
    constructor(id, name){
        this.id = id;
        this.name = name;
    }
}

var userOne = new Employee('ryu@ninjas.com', 'Ryu');
var userTwo = new Employee('yoshi@mariokorp.com', 'Yoshi');
var emp1 = new Employee(123, 'John');

document.write(emp1.id + emp1.name);*/

/*function frase(a, b){
    let completo = a + b;
    return completo;
}

let prueba = frase('Hola ', 'buenas tardes xd');

document.write(prueba);*/

const frase = (a, b) => {
    let completo = a + b;
    return completo;
}

let prueba2 = frase(`Hola, `, 'es la prueba dos');

document.write(prueba2);