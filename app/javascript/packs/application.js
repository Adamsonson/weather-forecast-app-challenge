require("chartkick")
require("chart.js")
import "bootstrap";


let chart = Chartkick.charts["chart-id"]


let buttonExist;

const closeNotice = () => {
    console.log(buttonExist);


}


document.addEventListener('DOMContentLoaded', (event) => {
    console.log('DOM loaded');
     buttonExist = document.querySelector("button.close");

     if (buttonExist) {
        closeNotice();
        console.log("Crazy bitch") }

        else {
     console.log("No crazy bitch");
    }

});
