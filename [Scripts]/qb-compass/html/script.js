window.addEventListener("message", function(event) {
    let data = event.data;

    

    
    if (data.direction) {
        $(".direction").find(".image").attr('style', 'transform: translate3d(' + data.direction + 'px, 0px, 0px)');
        return;
    }

    $(".Street_1").text(data.street);
    $(".Street_2").text(data.street2);

    if (data.showCarUi == true) {
        $("#Street1").show()
        $("#Street2").show()
        $("#streetwrapper").show()
        $("#compassindicator").show()
    } else if (data.showCarUi == false && data.ShowLocation == false) {
        $("#Street1").hide()
        $("#Street2").hide()
        $("#streetwrapper").hide()
        $("#compassindicator").hide()
    }



     if (data.ShowLocation == true) {
        $("#Street1").show()
        $("#Street2").show()
        $("#streetwrapper").show()
        $("#compassindicator").show()
    } else if (data.ShowLocation == false) {
        $("#Street1").hide()
        $("#Street2").hide()
        $("#streetwrapper").hide()
        $("#compassindicator").hide()
    }



    if (data.action == "toggle_hud") {
        $("body").fadeToggle()
    }
});
