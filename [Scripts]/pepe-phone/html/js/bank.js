var FoccusedBank = null;

$(document).on('click', '.bank-app-account', function(e){
    var copyText = document.getElementById("iban-account");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");

    QB.Phone.Notifications.Add("fas fa-university", "Bank", "Số tài khoản ngân hàng được sao chép!", "#badc58", 1750);
});

var CurrentTab = "accounts";

$(document).on('click', '.bank-app-header-button', function(e){
    e.preventDefault();

    var PressedObject = this;
    var PressedTab = $(PressedObject).data('headertype');

    if (CurrentTab != PressedTab) {
        var PreviousObject = $(".bank-app-header").find('[data-headertype="'+CurrentTab+'"]');

        if (PressedTab == "invoices") {
            // $.post('http://pepe-phone/OpenInvoiceMenu', JSON.stringify({}));
            $(".bank-app-"+CurrentTab).animate({
                left: -30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
            // QB.Phone.Animations.BottomSlideDown('.container', 500, -90);
            // QB.Phone.Data.IsOpen = false;
            // return;
        } else if (PressedTab == "accounts") {
            $(".bank-app-"+CurrentTab).animate({
                left: 30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
        }

        $(PreviousObject).removeClass('bank-app-header-button-selected');
        $(PressedObject).addClass('bank-app-header-button-selected');
        setTimeout(function(){ CurrentTab = PressedTab; }, 300)
    }
})

QB.Phone.Functions.DoBankOpen = function() {
    QB.Phone.Data.PlayerData.money.bank = (QB.Phone.Data.PlayerData.money.bank).toFixed();
    $(".bank-app-account-number").val(QB.Phone.Data.PlayerData.charinfo.account);
    $(".bank-app-account-balance").html("&dollar; "+QB.Phone.Data.PlayerData.money.bank);
    $(".bank-app-account-balance").data('balance', QB.Phone.Data.PlayerData.money.bank);

    $(".bank-app-loaded").css({"display":"none", "padding-left":"30vh"});
    $(".bank-app-accounts").css({"left":"30vh"});
    $(".bank-logo").css({"left": "0vh"});
    $("#bank-text").css({"opacity":"0.0", "left":"9vh"});
    $(".bank-app-loading").css({
        "display":"block",
        "left":"0vh",
    });
    setTimeout(function(){
        CurrentTab = "accounts";
        $(".bank-logo").animate({
            left: -12+"vh"
        }, 500);
        setTimeout(function(){
            $("#bank-text").animate({
                opacity: 1.0,
                left: 14+"vh"
            });
        }, 100);
        setTimeout(function(){
            $(".bank-app-loaded").css({"display":"block"}).animate({"padding-left":"0"}, 300);
            $(".bank-app-accounts").animate({left:0+"vh"}, 300);
            $(".bank-app-loading").animate({
                left: -30+"vh"
            },300, function(){
                $(".bank-app-loading").css({"display":"none"});
            });
        }, 1500)
    }, 500)
}

$(document).on('click', '.bank-app-account-actions', function(e){
    QB.Phone.Animations.TopSlideDown(".bank-app-transfer", 400, 0);
});

$(document).on('click', '#cancel-transfer', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
});

$(document).on('click', '.create-invoice-actions', function(e){
    $.post('http://pepe-phone/OpenInvoiceMenu', JSON.stringify({}));
    QB.Phone.Animations.BottomSlideDown('.container', 500, -90);
    QB.Phone.Data.IsOpen = false;
    // QB.Phone.Animations.TopSlideDown(".bank-app-create-invoice", 400, 0);
});

$(document).on('click', '#cancel-invoice', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".bank-app-create-invoice", 400, -100);
});


$(document).on('click', '#accept-transfer', function(e){
    e.preventDefault();

    var iban = $("#bank-transfer-iban").val();
    var amount = $("#bank-transfer-amount").val();
    var amountData = $(".bank-app-account-balance").data('balance');

    if (iban != "" && amount != "") {
		// console.log(amount);
		// console.log(amountData);
		// console.log(amount - amountData < 0);
        if (!amount - amountData < 0) {
			if (amount > 0) {
				$.post('http://pepe-phone/TransferMoney', JSON.stringify({
					iban: iban,
					amount: amount
				}), function(data){
					if (data.CanTransfer) {
						$("#bank-transfer-iban").val("");
						$("#bank-transfer-amount").val("");
						data.NewAmount = (data.NewAmount).toFixed();
						// $(".bank-app-account-balance").html("&dollar; "+data.NewAmount);
						// $(".bank-app-account-balance").data('balance', data.NewAmount);
						QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn đã chuyển $"+amount+",-!", "#badc58", 1500);
					} else {
						QB.Phone.Notifications.Add("fas fa-university", "Bank", "Không đủ số dư. ", "#badc58", 1500);
					}
				})
				QB.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
			} else {
				QB.Phone.Notifications.Add("fas fa-university", "Bank", "Số tiền không thấp hơn 0", "#badc58", 1500);
			 }
        } else {
            QB.Phone.Notifications.Add("fas fa-university", "Bank", "Không đủ số dư. ", "#badc58", 1500);
        }
    } else {
        QB.Phone.Notifications.Add("fas fa-university", "Bank", "Tất cả các trường phải được điền!", "#badc58", 1750);
    }
});

$(document).on('click', '#accept-invoice', function(e){
    e.preventDefault();

    var id = $("#create-invoice-id").val();
    var amount = $("#create-invoice-amount").val();
    var description = $("#create-invoice-desc").val();

    if (id != "" && amount != "" && description !="") {
        if (amount > 0) {
            $.post('http://pepe-phone/CreateInvoice', JSON.stringify({
                id: id,
                amount: amount,
                description: description
            }), function(data){
                if (data) {
                    $("#create-invoice-id").val("");
                    $("#create-invoice-amount").val("");
                    $("#create-invoice-desc").val("");
                    QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn đã tạo thành công hoá đơn $"+amount+" !", "#badc58", 1500);
                } else {
                    QB.Phone.Notifications.Add("fas fa-university", "Bank", "Không thể tạo hoá đơn! ", "#badc58", 1500);
                }
            })
            QB.Phone.Animations.TopSlideUp(".bank-app-create-invoice", 400, -100);
        } else {
            QB.Phone.Notifications.Add("fas fa-university", "Bank", "Số tiền không thấp hơn 0", "#badc58", 1500);
            }

    } else {
        QB.Phone.Notifications.Add("fas fa-university", "Bank", "Tất cả các trường phải được điền!", "#badc58", 1750);
    }
});

GetInvoiceLabel = function(type) {
    retval = null;
    if (type == "request") {
        retval = "Betaalverzoek";
    } else if (type == "invoice") {
        retval = "Hoá đơn";
    } else if (type == 'realestate') {
        retval = "Makelaar";
    }
    return retval
}

$(document).on('click', '.pay-invoice', function(event){
    event.preventDefault();
    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');
    var BankBalance = $(".bank-app-account-balance").data('balance');
    if (BankBalance >= InvoiceData.amount) {
        $.post('http://pepe-phone/PayInvoice', JSON.stringify({
            sender: InvoiceData.sender,
            amount: InvoiceData.amount,
            invoiceId: InvoiceData.invoiceid,
            SenderCitizenId: InvoiceData.sendercitizenid,
        }), function(CanPay){
            if (CanPay) {
                $("#"+InvoiceId).animate({
                    left: 30+"vh",
                }, 300, function(){
                    setTimeout(function(){
                        $("#"+InvoiceId).remove();
                    }, 100);
                });
                
                QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn đã thanh toán hoá đơn &dollar;"+InvoiceData.amount+"!", "#badc58", 1500);
                // var amountData = $(".bank-app-account-balance").data('balance');
                // var NewAmount = (amountData - InvoiceData.amount).toFixed();
                // $("#bank-transfer-amount").val(NewAmount);
                // $(".bank-app-account-balance").data('balance', NewAmount);
            } else {
                QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn không đủ tiền để thanh toán hoá đơn này. ", "#badc58", 1500);
            }
        });
    } else {
        QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn không đủ tiền để thanh toán hoá đơn này. ", "#badc58", 1500);
    }
});

$(document).on('click', '.decline-invoice', function(event){
    event.preventDefault();
    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');
    if (InvoiceData.type !== 'invoice' && InvoiceData.type !== 'realestate') {
    $.post('http://pepe-phone/DeclineInvoice', JSON.stringify({
        sender: InvoiceData.sender,
        amount: InvoiceData.amount,
        invoiceId: InvoiceData.invoiceid,
        SenderCitizenId: InvoiceData.sendercitizenid
    }));
    $("#"+InvoiceId).animate({
        left: 30+"vh",
    }, 300, function(){
        setTimeout(function(){
            $("#"+InvoiceId).remove();
        }, 100);
    });
    QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn vừa huỷ thanh toán hoá đơn " + InvoiceData.amount + "$ .", "#badc58", 1500);
 } else {
    QB.Phone.Notifications.Add("fas fa-university", "Bank", "Bạn không thể từ chối yêu cầu này ..", "#badc58", 1500);
 }
});

QB.Phone.Functions.LoadBankInvoices = function(invoices) {
    if (invoices !== null) {
        $(".bank-app-invoices-list").html("");

        $.each(invoices, function(i, invoice){
            var Elem = `
            <div class="bank-app-invoice" id="invoiceid-${i}">
                <div class="bank-app-invoice-title">
                ${GetInvoiceLabel(invoice.type)}
                    <span style="font-size: 1vh; color: gray;">
                    (Người gửi: ${invoice.sender})
                    </span>
                </div>
                <div class="bank-app-invoice-amount">
                    &dollar; ${invoice.amount}, ${limitCharacter(invoice.description, 15) || 'Không có nội dung'}
                </div>
                ${invoice.status == "unpaid" && `<div id="actioninvoiceid-${i}" class="bank-app-invoice-buttons">
                    <i class="fas fa-check-circle pay-invoice"></i>
                    <i class="fas fa-times-circle decline-invoice"></i>
                </div>`}
            </div>`;

            $(".bank-app-invoices-list").append(Elem);
            $("#invoiceid-"+i).data('invoicedata', invoice);
        });
    }
}

QB.Phone.Functions.LoadContactsWithNumber = function(myContacts) {
    var ContactsObject = $(".bank-app-my-contacts-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $("#bank-app-my-contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".bank-app-my-contacts-list .bank-app-my-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var RandomNumber = Math.floor(Math.random() * 6);
            var ContactColor = QB.Phone.ContactColors[RandomNumber];
            var ContactElement = '<div class="bank-app-my-contact" data-bankcontactid="'+i+'"> <div class="bank-app-my-contact-firstletter">'+((contact.name).charAt(0)).toUpperCase()+'</div> <div class="bank-app-my-contact-name">'+contact.name+'</div> </div>'
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-bankcontactid='"+i+"']").data('contactData', contact);
        });
    }
};

$(document).on('click', '.bank-app-my-contacts-list-back', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});

$(document).on('click', '.bank-transfer-mycontacts-icon', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideDown(".bank-app-my-contacts", 400, 0);
});

$(document).on('click', '.bank-app-my-contact', function(e){
    e.preventDefault();
    var PressedContactData = $(this).data('contactData');

    if (PressedContactData.iban !== "" && PressedContactData.iban !== undefined && PressedContactData.iban !== null) {
        $("#bank-transfer-iban").val(PressedContactData.iban);
    } else {
        QB.Phone.Notifications.Add("fas fa-university", " Bank", "Không có IBAN được gắn với liên hệ này!", "#badc58", 2500);
    }
    QB.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});

const limitCharacter = (str, max, suffix = '...') => {
    if (!str) return '';
    if (str.length <= max) return str;
    
    let strGioiHan ='';
    if(typeof(max) === 'number'){
      strGioiHan = str.substr(0,max);
    }
    else{
      strGioiHan = str.substr(0,30);
    }
    return strGioiHan + suffix;
  };