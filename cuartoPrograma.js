
const comicsDC = [`Watchmen`, `The Killing Joke`, `Year One`, 
`The Long Halloween`, `Dark Victory`, `Flashpoint`, 
`The Batman Who Laughs`, `Arkham Asylum`];

const comicsMarvel = [`The Punisher`, `Ghost Rider`, `Maximum Carnage`];

const otrosComics = [`Resident Alien`, `Analog`, `Concrete`, `Clear`];

const bestOfEach = [comicsDC[3] + '<br>', comicsMarvel[0] + '<br>', 
                   otrosComics[3] + '<br>'];

const bestOfDC = comicsDC[3];
const bestOfMarvel = comicsMarvel[0];

var question1 = prompt(`Would you like to know what comics I've read?`).toUpperCase();


miSentencia:
if(question1 == `YES`){
    let question2 = prompt(`Marvel, DC or another publisher?`).toUpperCase();
        
        if(question2 == `MARVEL`){
        document.write(`I've read these: ` + comicsMarvel);
        break miSentencia;
        }else if (question2 == `DC`){
        document.write(`I've read these: ` + comicsDC);

        }else if(question2 == `ANOTHER ONE`){
        document.write(`I've read these: ` + otrosComics);
        }
    document.write('<br>' + '<br>' + 
    `<strong>Esto imprime pase lo que pase</strong>`);

    alert("Esto tambien se imprimira")
        
}else{
    document.write(`De acuerdo`);
}



