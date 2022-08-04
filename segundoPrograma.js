//Comics leidos

// Este ejercicio es importante para entender los bucles

// Para tener en cuenta, el break es como un else. Si el if no se cumple,
// va a pasar a lo siguiente que seria el else o el break

var comicsDC = [`Watchmen`, `The Killing Joke`, `Year One`, 
                `The Long Halloween`, `Dark Victory`, `Flashpoint`, 
                `The Batman Who Laughs`, `Arkham Asylum`];

var comicsMarvel = [`The Punisher`, `Ghost Rider`, `Maximum Carnage`];

var otrosComics = [`Resident Alien`, `Analog`, `Concrete`, `Clear`];


/*for(let comic of comicsDC){
    document.write(comic + "<br>");
    
    
    if(comic == `Flashpoint`){
        for(let comic of comicsMarvel){
            document.write(comic + "<br>"); 
        }break; //Este break corta en caso de que se llegue al for anterior
    }else{
        for(let comic of otrosComics){
            document.write(comic + "<br>");
        }
    }
}*/

for(let comic of otrosComics){
    document.write(comic + "<br>");
    if(comic == `Concrete`){
        for(let i = 1; i<=5; i++){
            document.write(`Ojala funcione XD` + "<br>");
        }
    }else{
        document.write(`YUU` + "<br>");
    }
}

