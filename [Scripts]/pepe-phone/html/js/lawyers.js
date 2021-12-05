SetupLawyers = function(data) {
    $(".lawyers-list").html("");
    var lawyers = [];
    var realestate = [];
    var cardealer = [];
    var mechanic = [];
    var police = [];
    var ambulance = [];
    var bennys = [];

    if (data.length > 0) {
        
        $.each(data, function(i, lawyer){
            if(lawyer.typejob == "lawyer"){
                lawyers.push(lawyer);
            }
            if(lawyer.typejob == "cardealer"){
                realestate.push(lawyer);
            }
            if(lawyer.typejob == "mechanic"){
                cardealer.push(lawyer);
            }

            if(lawyer.typejob == "ambulance"){
                ambulance.push(lawyer);
            }

            if(lawyer.typejob == "police"){
                police.push(lawyer);
            }

            if(lawyer.typejob == "bennys"){
                bennys.push(lawyer);
            }
        });

        $(".lawyers-list").append('<h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(42, 137, 214);">Bác sĩ ('+ambulance.length+')</h1>');
        if (ambulance.length > 0) {
            $.each(ambulance, function(i, lawyer){
                var element = '<div class="lawyer-list" id="lawyeridambulance-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(42, 137, 214);">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyeridambulance-"+i).data('LawyerData', lawyer);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">Không có bác sĩ trực tuyến.</div></div>'
            $(".lawyers-list").append(element);
        }

        $(".lawyers-list").append('<h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(42, 137, 214);">Cảnh sát ('+police.length+')</h1>');
        if (police.length > 0) {
            $.each(police, function(i, lawyer){
                var element = '<div class="lawyer-list" id="lawyeridpolice-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(42, 137, 214);">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyeridpolice-"+i).data('LawyerData', lawyer);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">Không có cảnh sát trực tuyến.</div></div>'
            $(".lawyers-list").append(element);
        }


        $(".lawyers-list").append('<h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(42, 137, 214);">Luật sư ('+lawyers.length+')</h1>');
        if (lawyers.length > 0) {
            $.each(lawyers, function(i, lawyer){
                var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(42, 137, 214);">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid-"+i).data('LawyerData', lawyer);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">No lawyer is available.</div></div>'
            $(".lawyers-list").append(element);
        }

        $(".lawyers-list").append('<br><h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(155, 15, 120);">Cardealers ('+realestate.length+')</h1>');

        if (realestate.length > 0) {            
            $.each(realestate, function(i, lawyer1){
                var element = '<div class="lawyer-list" id="lawyerid1-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(155, 15, 120);">' + (lawyer1.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer1.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid1-"+i).data('LawyerData', lawyer1);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">No car dealer is available.</div></div>'
            $(".lawyers-list").append(element);
        }



        $(".lawyers-list").append('<br><h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(235, 183, 52);">Autocare ('+cardealer.length+')</h1>');

        if (cardealer.length > 0) {            
            $.each(cardealer, function(i, lawyer3){
                var element = '<div class="lawyer-list" id="lawyerid3-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(235, 183, 52);">' + (lawyer3.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer3.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid3-"+i).data('LawyerData', lawyer3);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">No AutoCare is available.</div></div>'
            $(".lawyers-list").append(element);
        }
         // mechanic
        // $(".lawyers-list").append('<br><h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(235, 183, 52);">Autocare ('+cardealer.length+')</h1>');

        // if (cardealer.length > 0) {            
        //     $.each(cardealer, function(i, lawyer3){
        //         var element = '<div class="lawyer-list" id="lawyerid3-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(235, 183, 52);">' + (lawyer3.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer3.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
        //         $(".lawyers-list").append(element);
        //         $("#lawyerid3-"+i).data('LawyerData', lawyer3);
        //     });
        // } else {
        //     var element = '<div class="lawyer-list"><div class="no-lawyers">No AutoCare is available.</div></div>'
        //     $(".lawyers-list").append(element);
        // }


        $(".lawyers-list").append('<br><h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(235, 183, 52);">Autocare ('+mechanic.length+')</h1>');

        if (mechanic.length > 0) {            
            $.each(mechanic, function(i, lawyer3){
                var element = '<div class="lawyer-list" id="lawyerid3-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(235, 183, 52);">' + (lawyer3.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer3.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerid3-"+i).data('LawyerData', lawyer3);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">No AutoCare is available.</div></div>'
            $(".lawyers-list").append(element);
        }

        $(".lawyers-list").append('<br><h1 style="font-size:16px; padding:10px; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(235, 183, 52);">Độ xe ('+bennys.length+')</h1>');

        if (bennys.length > 0) {            
            $.each(bennys, function(i, lawyer3){
                var element = '<div class="lawyer-list" id="lawyerbennys-'+i+'"> <div class="lawyer-list-firstletter" style="background-color: rgb(235, 183, 52);">' + (lawyer3.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer3.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
                $(".lawyers-list").append(element);
                $("#lawyerbennys-"+i).data('LawyerData', lawyer3);
            });
        } else {
            var element = '<div class="lawyer-list"><div class="no-lawyers">No AutoCare is available.</div></div>'
            $(".lawyers-list").append(element);
        }



    }


}

$(document).on('click', '.lawyer-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    $.post('http://pepe-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: QB.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== QB.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (QB.Phone.Data.AnonymousCall) {
                            QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "You have started an anonymous call!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        QB.Phone.Functions.HeaderTextColor("white", 400);
                        QB.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".lawyers-app").css({"display":"none"});
                            QB.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            QB.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);

                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        QB.Phone.Data.currentApplication = "phone-call";
                    } else {
                        QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "You are already talking!");
                    }
                } else {
                    QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "This person is in conversation!");
                }
            } else {
                QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "This person is not available!");
            }
        } else {
            QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "You can't call your own number!");
        }
    });
});