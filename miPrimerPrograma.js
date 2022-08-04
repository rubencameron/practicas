alert(`Hello! Would you like to play a game?`);

let respuesta = prompt(`Please say yes!`);

if(respuesta == `yes` || respuesta == `Yes`){

 var yourName = prompt(`What is your name?`);

 let state = prompt(`Hello ${yourName}! Please tell me how are you?`);

 if(state == `Fine` || state == `fine` || state == `I'm fine`){
    alert(`I'm so glad to hear that!`); 
}

 else if(state == `bad` || state == `not so good`){
    alert(`Keep it up!`);
}

 else{
    alert(`Got it though`);
}

 let question = prompt(`Would you like to know what to do with your money?
Please answer Yes or No`);

 if(question == `Yes` || question == `yes`){

  let money = prompt(`How much money do you have ${yourName}?`);

  alert(`You have ${money} USD dollars`);

  if(money <= 2000){
    alert(`You should invest in crypto`); 
}

  else if(money > 2000 && money <= 2500){
    alert(`Maybe you could invest in axies`);
} 

  else if(money > 2500 && money <= 3000){
    alert(`Maybe you should do both crypto and axies`);
}

  else{
    alert(`You could buy new equipment and invest the other half XD`);
} } 

 else{
    alert(`Then, I can not do anything for you though`);
}
} 

else{
    alert(`You ARE NOT funny!`);
    alert(`What would you like to do instead?`);

    let posible1 = prompt(`Would you like to talk?`);
    if(posible1 == `Yes` || posible1 == `yes`){
      alert(`I'm not a very good listener :(`);
    }
    else{
      let posible2 = prompt(`Would you like to do nothing?`);
      if(posible2 == `yes`|| posible2 == `Yes`){
        alert(`That's fine`);
      }
      else{
        alert(`THAT IS FINEE`);
      }
    }
}

































