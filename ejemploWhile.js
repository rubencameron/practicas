/*let x = 0;
// Label a loop as "myLoop"
myLoop:
while (true) {
  if (x >= 10) {
    // This will cause "myLoop" to end.
    break myLoop;
  }
  x++;
}*/



//EJEMPLO DE BUCLE WHILE Y COMO PONER NOMBRE A UN STATEMENT
//TAMBIEN SE PUEDE NOMBRAR A UN "IF" STATEMENT USANDO UN LABEL


let arreglos = ['batman', 'superman', 'flash', 'cyborg', 'arrow'];

for(arreglo in arreglos){
    if(arreglo[2]){
      break;
    }
    document.write(arreglo + '<br>');
}

