
let dineroCofla = prompt("Cuanto dinero tienes Cofla?");
//let dineroRoberto = prompt("Cuanto dinero tienes Roberto?");
//let dineroPedro = prompt("Cuanto dinero tienes Pedro?");

dineroCofla = parseInt(dineroCofla);

if(dineroCofla >= 0.6 && dineroCofla < 1){
    alert("Comprate el helado de agua");
    alert("y te sobran" + (dineroCofla - 0.6));
}

else if(dineroCofla >= 1 && dineroCofla < 1.6){
    alert("Comprate el helado de crema");
     alert("y te sobran" + (dineroCofla - 1));
}

else if(dineroCofla >= 1.6 && dineroCofla < 1.7){
    alert("Comprate el helado de heladix");
     alert("y te sobran" + (dineroCofla - 1.6));
}

else if(dineroCofla >= 1.7 && dineroCofla < 1.8){
    alert("Comprate el helado de heladovich");
     alert("y te sobran" + (dineroCofla - 1.7));
}

else if(dineroCofla >= 1.8 && dineroCofla < 2.9){
    alert("Comprate el helado de helardo");
     alert("y te sobran" + (dineroCofla - 1.8));
}

else if(dineroCofla >= 2.9){
    alert("Helado con confites o el pote de 1/4kg");
     alert("y te sobran" + (dineroCofla - 2.9));
} 

else{
    alert("lo siento, no te alcanza");
     alert("y te sobran" + (dineroCofla - 0.6));
}


