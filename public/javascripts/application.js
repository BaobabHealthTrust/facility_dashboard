
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
