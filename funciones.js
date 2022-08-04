// Se declara primero la funcion, y despues se la llama
function saludar (){
    respuesta = prompt(`Hola! Como esta tu dia?`);
    if(respuesta == `bien`){
        alert(`me alegro`);
    }else if(respuesta == `mal`){
        alert(`que pena`);
    }else{
        alert(`no entiendo XD`);
    }
}

saludar()


//En la funcion una cosa es lo que hace, en este caso el alert
//y otra cosa es lo que retorna, que es el return
//el return finaliza la funcion, es como un break
//la variante saludo es igual a lo que la funcion retorna, NO al alert 
/*function saludar (){
    alert(`Hola`);
    return `la funcion se ejecuto correctamente`;
}

let saludo = saludar();

document.write(saludo);*/