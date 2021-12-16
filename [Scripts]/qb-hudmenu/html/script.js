$(function() {
    let height = 25.5;
    window.addEventListener("message", function(event) {
       
        let item = event.data;
        if (item.response == 'hud') {
            hudMenuOpen()
        }else if (item.response == 'hudoff') {
            hudMenuClose()
        }
    });
})

function hudMenuOpen()
{
    $('.hud-menu').fadeIn()
}

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        hudMenuClose();
    }
};

function hudMenuClose()
{
    
    $('.hud-menu').fadeOut()
    $.post('https://qb-hudmenu/closeHud');
}

$(document).ready(function () {
    $('.save-settings').click(() => {
        Health = $('input[name="Health"]').prop('checked');
        Armor = $('input[name="Armor"]').prop('checked');
        Food = $('input[name="Food"]').prop('checked');
        Water = $('input[name="Water"]').prop('checked');
        Oxygen = $('input[name="Oxygen"]').prop('checked');
        Stress = $('input[name="Stress"]').prop('checked');
        Wm = $('input[name="Wm"]').prop('checked');
        Fps = $('input[name="Fps"]').prop('checked');
        Barras = $('input[name="Barras"]').prop('checked');
        Compass = $('input[name="Compass"]').prop('checked');  
 

        //Send post message with new settings
        $.post(
            'https://qb-hudmenu/UpdateHudSettings', 
            JSON.stringify({
                Health: Health,
                Armor: Armor,
                Food: Food,
                Water: Water,
                Oxygen: Oxygen,
                Stress: Stress,
                Wm: Wm,
                Fps: Fps,
                Barras: Barras,
                Compass: Compass
            }),
        );
    });
    $('.CloseHud').click(() => {
        hudMenuClose()
    });
});
