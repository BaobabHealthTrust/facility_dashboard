
function __$(id){
    return document.getElementById(id);
}

function fadeIn(id){
    if(__$(id)){
        if(__$(id).style.opacity == ""){
            __$(id).style.opacity = 0;
            __$(id).style.display = "block";
        } else if(eval(__$(id).style.opacity) >= 1){
            __$(id).style.opacity = 0;
        }

        __$(id).style.opacity = eval(__$(id).style.opacity) + 0.1;

        if(eval(__$(id).style.opacity) < 1){

            setTimeout("fadeIn('" + id + "')", 100);
        }
    }
}

function slideShow(step){
    var idColl = __$("main").getElementsByTagName("div");

    for(var i = 0; i < idColl.length; i++){
        var id = idColl[i].id;

        if(__$(id)){
            __$(id).style.opacity = 0;

            setTimeout("fadeIn('" + id + "')", 100 + (i * step));
        }
    }
}

function checkIfNumber(id){
    if(__$(id)){

        if(!__$(id).value.trim().match(/^\d+(\.\d+)?$/)){
            __$(id).style.color = "red";
            
            if(__$(id + "_lbl"))
                __$(id + "_lbl").style.color = "red";
        } else {
            __$(id).style.color = "black";

            if(__$(id + "_lbl"))
                __$(id + "_lbl").style.color = "black";
        }

        setTimeout("checkIfNumber('" + id + "')", 100);

    }
}

function checkDate(id){
    if(!__$(id).value.trim().match(/^\d{4}\-((0[1-9])|(1[0-2]))\-(([0-2][0-9])|(3[0-1]))$|^$/)){
        __$(id).style.color = "red";

        if(__$(id + "_lbl"))
            __$(id + "_lbl").style.color = "red";
        
    } else if(__$(id).value.trim().match(/^\d{4}\-((0[1-9])|(1[0-2]))\-(([0-2][0-9])|(3[0-1]))$|^$/)){
        var d = new Date(__$(id).value.trim());

        if(isNaN(d.getFullYear())){
            __$(id).style.color = "red";

            if(__$(id + "_lbl"))
                __$(id + "_lbl").style.color = "red";
        } else {
            __$(id).style.color = "green";
            
            if(__$(id + "_lbl"))
                __$(id + "_lbl").style.color = "green";
        }

    } else {
        __$(id).style.color = "black";
        
        if(__$(id + "_lbl"))
            __$(id + "_lbl").style.color = "black";
    }

    setTimeout("checkDate('" + id + "')", 100);

}
