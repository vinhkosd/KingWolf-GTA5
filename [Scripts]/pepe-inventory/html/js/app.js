var InventoryOption = "33, 128, 237";

var totalWeight = 0;
var totalWeightOther = 0;

var playerMaxWeight = 0;
var otherMaxWeight = 0;

var otherLabel = "";

var ClickedItemData = {};

var SelectedAttachment = null;
var AttachmentScreenActive = false;
var ControlPressed = false;
var disableRightMouse = false;
var selectedItem = null;

var IsDragging = false;

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
        case 9: // TAB
            Inventory.Close();
            break;
        case 17: // TAB
            ControlPressed = true;
            break;
    }
});

$(document).on('keyup', function(){
    switch(event.keyCode) {
        case 17: // TAB
            ControlPressed = false;
            break;
    }
});

$(document).on("mouseenter", ".item-slot", function(e){
    e.preventDefault();
    if ($(this).data("item") != null) {
        $(".ply-iteminfo-container").fadeIn(150);
        FormatItemInfo($(this).data("item"));
    } else {
        $(".ply-iteminfo-container").fadeOut(100);
    }
});

// Autostack Quickmove
function GetFirstFreeSlot($toInv, $fromSlot) {
    var retval = null;
    $.each($toInv.find('.item-slot'), function(i, slot){
        if ($(slot).data('item') === undefined) {
            if (retval === null) {
                retval = (i + 1);
            }
        }
    });
    return retval;
}

function CanQuickMove() {
    var otherinventory = otherLabel.toLowerCase();
    var retval = true;
    // if (otherinventory == "grond") {
    //     retval = false
    // } else if (otherinventory.split("-")[0] == "dropped") {
    //     retval = false;
    // }
    if (otherinventory.split("-")[0] == "player") {
        retval = false;
    }
    return retval;
}

$(document).on('mousedown', '.item-slot', function(event){
    switch(event.which) {
        case 3:
            fromSlot = $(this).attr("data-slot");
            fromInventory = $(this).parent();

            if ($(fromInventory).attr('data-inventory') == "player") {
                toInventory = $(".other-inventory");
            } else {
                toInventory = $(".player-inventory");
            }
            toSlot = GetFirstFreeSlot(toInventory, $(this));
            if ($(this).data('item') === undefined) {
                return;
            }
            toAmount = $(this).data('item').amount;
            if (ControlPressed) {
                if (toAmount > 1) {
                    toAmount = Math.round(toAmount / 2)
                }
            }
            if (CanQuickMove()) {
                if (toSlot === null) {
                    InventoryError(fromInventory, fromSlot);
                    return;
                }
                if (fromSlot == toSlot && fromInventory == toInventory) {
                    return;
                }
                if (toAmount >= 0) {
                    if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                        swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                    }
                }
            } else {
                InventoryError(fromInventory, fromSlot);
            }
            break;
    }
});

$(document).on("click", "#close-inv", function(e){
    e.preventDefault();
    Inventory.Close();
});

$(document).on("click", ".item-slot", function(e){
    e.preventDefault();
    var ItemData = $(this).data("item");

    if (ItemData !== null && ItemData !== undefined) {
        if (ItemData.name !== undefined) {
            if ((ItemData.name).split("_")[0] == "weapon") {
                if (!$("#weapon-attachments").length) {
                    // if (ItemData.info.attachments !== null && ItemData.info.attachments !== undefined && ItemData.info.attachments.length > 0) {
                    $(".inv-options-list").append('<div class="inv-option-item" id="weapon-attachments"><p>ATTACHMENTS</p></div>');
                    $("#weapon-attachments").hide().fadeIn(250);
                    ClickedItemData = ItemData;
                    // }
                } else if (ClickedItemData == ItemData) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                    ClickedItemData = {};
                } else {
                    ClickedItemData = ItemData;
                }
            } else {
                ClickedItemData = {};
                if ($("#weapon-attachments").length) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                }
            }
        } else {
            ClickedItemData = {};
            if ($("#weapon-attachments").length) {
                $("#weapon-attachments").fadeOut(250, function(){
                    $("#weapon-attachments").remove();
                });
            } 
        }
    } else {
        ClickedItemData = {};
        if ($("#weapon-attachments").length) {
            $("#weapon-attachments").fadeOut(250, function(){
                $("#weapon-attachments").remove();
            });
        } 
    }
});

$(document).on('click', '.weapon-attachments-back', function(e){
    e.preventDefault();
    $("#framework-inventory").css({"display":"block"});
    $("#framework-inventory").animate({
        left: 0+"vw"
    }, 200);
    $(".weapon-attachments-container").animate({
        left: -100+"vw"
    }, 200, function(){
        $(".weapon-attachments-container").css({"display":"none"});
    });
    AttachmentScreenActive = false;
});

function FormatAttachmentInfo(data) {
    $.post("http://pepe-inventory/GetWeaponData", JSON.stringify({
        weapon: data.name,
        ItemData: ClickedItemData
    }), function(data){
        var AmmoLabel = "9mm";
        var Durability = 100;
        if (data.WeaponData.ammotype == "AMMO_RIFLE") {
            AmmoLabel = "7.62"
        } else if (data.WeaponData.ammotype == "AMMO_SHOTGUN") {
            AmmoLabel = "12 Gauge"
        }
        if (ClickedItemData.info.quality !== undefined) {
            Durability = ClickedItemData.info.quality;
        }

        $(".weapon-attachments-container-title").html(data.WeaponData.label + " | " + AmmoLabel);
        $(".weapon-attachments-container-description").html(data.WeaponData.description);
        $(".weapon-attachments-container-details").html('<span style="font-weight: bold; letter-spacing: .1vh;">Serie Nummer</span><br> ' + ClickedItemData.info.serie + '<br><br><span style="font-weight: bold; letter-spacing: .1vh;">Durability - ' + Durability.toFixed() + '% </span> <div class="weapon-attachments-container-detail-durability"><div class="weapon-attachments-container-detail-durability-total"></div></div>')
        $(".weapon-attachments-container-detail-durability-total").css({
            width: Durability + "%"
        });
        $(".weapon-attachments-container-image").attr('src', './attachment_images/' + data.WeaponData.name + '.png');
        $(".weapon-attachments").html("");

        if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
            if (data.AttachmentData.length > 0) {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Phụ kiện</span>');
                $.each(data.AttachmentData, function(i, attachment){
                    var WeaponType = (data.WeaponData.ammotype).split("_")[1].toLowerCase();
                    $(".weapon-attachments").append('<div class="weapon-attachment" id="weapon-attachment-'+i+'"> <div class="weapon-attachment-label"><p>' + attachment.label + '</p></div> <div class="weapon-attachment-img"><img src="./images/' + WeaponType + '_' + attachment.attachment + '.png"></div> </div>')
                    attachment.id = i;
                    $("#weapon-attachment-"+i).data('AttachmentData', attachment)
                });
            } else {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Dit wapen bevat geen attachments</span>');
            }
        } else {
            $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Dit wapen bevat geen attachments</span>');
        }

        handleAttachmentDrag()
    });
}

var AttachmentDraggingData = {};

function handleAttachmentDrag() {
    $(".weapon-attachment").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        start: function(event, ui) {
           var ItemData = $(this).data('AttachmentData');
           $(this).addClass('weapon-dragging-class');
           AttachmentDraggingData = ItemData
        },
        stop: function() {
            $(this).removeClass('weapon-dragging-class');
        },
    });
    $(".weapon-attachments-remove").droppable({
        accept: ".weapon-attachment",
        hoverClass: 'weapon-attachments-remove-hover',
        drop: function(event, ui) {
            $.post('http://pepe-inventory/RemoveAttachment', JSON.stringify({
                AttachmentData: AttachmentDraggingData,
                WeaponData: ClickedItemData,
            }), function(data){
                if (data.Attachments !== null && data.Attachments !== undefined) {
                    if (data.Attachments.length > 0) {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                        });
                    } else {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                            $(".weapon-attachments").html("");
                        });
                        $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Vũ khí này không có phụ kiện</span>');
                    }
                } else {
                    $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                        $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                        AttachmentDraggingData = null;
                        $(".weapon-attachments").html("");
                    });
                    $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Vũ khí này không có phụ kiện</span>');
                }
            });
        },
    });
}

$(document).on('click', '#weapon-attachments', function(e){
    e.preventDefault();
    if (!Inventory.IsWeaponBlocked(ClickedItemData.name)) {
        $(".weapon-attachments-container").css({"display":"block"})
        $("#framework-inventory").animate({
            left: 100+"vw"
        }, 200, function(){
            $("#framework-inventory").css({"display":"none"})
        });
        $(".weapon-attachments-container").animate({
            left: 0+"vw"
        }, 200);
        AttachmentScreenActive = true;
        FormatAttachmentInfo(ClickedItemData);    
    } else {
        $.post('http://pepe-inventory/Notify', JSON.stringify({
            message: "Không có phụ kiện cho vũ khí này.",
            type: "error"
        }))
    }
});

function FormatItemInfo(itemData) {
    if (itemData != null && itemData.info != "") {
        if (itemData.name == "id-card") {
            var gender = "Nam";
            if (itemData.info.gender == 1) {
                gender = "Nữ";
            }
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>IDG: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>Họ: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Tên: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Ngày sinh: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Giới tính: </strong><span>' + gender + '</span></p><p><strong>Quốc tịch: </strong><span>' + itemData.info.nationality + '</span></p>');
        } else if (itemData.name == "farm-license") {
            var gender = "Nam";
            if (itemData.info.gender == 1) {
                gender = "Nữ";
            }
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>IDG: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>Họ: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Tên: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Ngày sinh: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Giới tính: </strong><span>' + gender + '</span></p><p><strong>Quốc tịch: </strong><span>' + itemData.info.nationality + '</span></p>');
        } else if (itemData.name == "drive-card") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Họ: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Tên: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>Ngày sinh: </strong><span>' + itemData.info.birthdate + '</span></p><p><strong>Giấy phép lái xe: </strong><span>' + itemData.info.type + '</span></p>');
        } else if (itemData.name == "lawyerpass") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Pas-ID: </strong><span>' + itemData.info.id + '</span></p><p><strong>Họ: </strong><span>' + itemData.info.firstname + '</span></p><p><strong>Tên: </strong><span>' + itemData.info.lastname + '</span></p><p><strong>BSN: </strong><span>' + itemData.info.citizenid + '</span></p>');
        } else if (itemData.name == "harness") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>Nog '+itemData.info.uses+'x te gebruiken.</p>');
        } else if (itemData.type == "weapon") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.ammo == undefined) {
                itemData.info.ammo = 0;
            } else {
                itemData.info.ammo != null ? itemData.info.ammo : 0;
            }
            if (itemData.info.attachments != null) {
                var attachmentString = "";
                $.each(itemData.info.attachments, function (i, attachment) {
                    if (i == (itemData.info.attachments.length - 1)) {
                        attachmentString += attachment.label
                    } else {
                        attachmentString += attachment.label + ", "
                    }
                });
                $(".item-info-description").html('<p><strong>Số seri: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Đạn: </strong><span>' + itemData.info.ammo + '</span></p><p><strong>Phụ kiện: </strong><span>' + attachmentString + '</span></p>');
            } else if (itemData.info.serie == undefined || itemData.info.serie == '') {
                $(".item-info-description").html('<p>' + itemData.description + '</p>');
            } else if (itemData.info.melee) {
                $(".item-info-description").html('<p>' + itemData.description + '</p>');
            } else {
                $(".item-info-description").html('<p><strong>Số seri: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Đạn: </strong><span>' + itemData.info.ammo + '</span></p><p>' + itemData.description + '</p>');
            }

        } else if (itemData.name == "filled_evidence_bag") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            if (itemData.info.type == "casing") {
                $(".item-info-description").html('<p><strong>Bằng chứng: </strong><span>' + itemData.info.label + '</span></p><p><strong>Mẫu đạn: </strong><span>' + itemData.info.ammotype + '</span></p><p><strong>Kaliber: </strong><span>' + itemData.info.ammolabel + '</span></p><p><strong>Seri súng: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Hiện trường vụ án tại: </strong><span>' + itemData.info.street + '</span></p>');
            }else if (itemData.info.type == "blood") {
                $(".item-info-description").html('<p><strong>Bằng chứng: </strong><span>' + itemData.info.label + '</span></p><p><strong>Mẫu máu: </strong><span>' + itemData.info.bloodtype + '</span></p><p><strong>Hiện trường vụ án tại: </strong><span>' + itemData.info.street + '</span></p>');
            }else if (itemData.info.type == "fingerprint") {
                $(".item-info-description").html('<p><strong>Bằng chứng: </strong><span>' + itemData.info.label + '</span></p><p><strong>Vân tay: </strong><span>' + itemData.info.fingerprint + '</span></p><p><strong>Hiện trường vụ án tại: </strong><span>' + itemData.info.street + '</span></p>');
            }else if (itemData.info.type == "hair") {
                $(".item-info-description").html('<p><strong>Bằng chứng: </strong><span>' + itemData.info.label + '</span></p><p><strong>Mẫu tóc: </strong><span>' + itemData.info.hair + '</span></p><p><strong>Hiện trường vụ án tại: </strong><span>' + itemData.info.street + '</span></p>');
            } else if (itemData.info.type == "slime") {
                $(".item-info-description").html('<p><strong>Bằng chứng: </strong><span>' + itemData.info.label + '</span></p><p><strong>Chất nhờn: </strong><span>' + itemData.info.slime + '</span></p><p><strong>Hiện trường vụ án tại: </strong><span>' + itemData.info.street + '</span></p>');
            }
        } else if (itemData.info.costs != undefined && itemData.info.costs != null) {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.info.costs + '</p>');
        } else if (itemData.name == "burger-ticket") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Đã trả: </strong><span>$' + itemData.info.price + '</span></p><p><strong>Ghi chú: </strong><span>' + itemData.info.note + '</span></p>');
        } else if (itemData.name == "moneybag") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Trị giá: </strong><span>$' + itemData.info.cash + '</span></p>');
        } else if (itemData.name == "used-card") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Trị giá: $</strong><span>' + itemData.info.card + '</span></p>');
        } else if (itemData.name == "bloodvial") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Mẫu máu: </strong><span>' + itemData.info.vialid + '</span></p><p><strong>Patiënt: </strong><span>' + itemData.info.vialname + '</span></p><p><strong>BSN: </strong><span>' + itemData.info.vialbsn + '</span></p><p><strong>Bloed Type: </strong><span>' + itemData.info.bloodtype + '</span></p>' );
        } else if (itemData.name == "markedbills") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Hóa đơn bẩn trị giá: </strong><span>$' + itemData.info.worth + '</span></p>');
        } else {
            let itemDesc = itemData.info && itemData.info.label ? itemData.info.label : itemData.description
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>' + itemDesc + '</p>')
        }
    } else {
        $(".item-info-title").html('<p>'+itemData.label+'</p>')
        $(".item-info-description").html('<p>' + itemData.description + '</p>')
    }
 }

function handleDragDrop() {
    $(".item-drag").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function(event, ui) {
            IsDragging = true;
           // $(this).css("background", "rgba(20,20,20,1.0)");
            $(this).find("img").css("filter", "brightness(50%)");

            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)")

            var itemData = $(this).data("item");
            var dragAmount = $("#item-amount").val();
            if (!itemData.useable) {
                $("#item-use").css("background", "rgba(35,35,35, 0.5");
            }

            if ( dragAmount == 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('0 (0.0)');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html('0 (0.0)');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else if(dragAmount > itemData.amount) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            } else if(dragAmount > 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html('('+itemData.amount+') €' + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html((itemData.amount - dragAmount) + ' (' + ((itemData.weight * (itemData.amount - dragAmount)) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(dragAmount + ' (' + ((itemData.weight * dragAmount) / 1000).toFixed(1) + ')');
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else {
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
                $(".ui-draggable-dragging").find(".item-slot-key").remove();
                $(this).find(".item-slot-amount p").html(itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')');
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            }
        },
        stop: function() {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            $(this).css("background", "rgba(235, 235, 235, 0.03)");
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("background", "rgba("+InventoryOption+", 0.3)");
        },
    });

    $(".item-slot").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromSlot = ui.draggable.attr("data-slot");
            fromInventory = ui.draggable.parent();
            toSlot = $(this).attr("data-slot");
            toInventory = $(this).parent();
            toAmount = $("#item-amount").val();
            fromAmount = $("#item-amount").val();
            
            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if (toAmount >= 0) {
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
            $.post("http://pepe-inventory/UpdateStash", JSON.stringify({}));
        },
    });

    $("#item-use").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if(fromData.useable) {
                if (fromData.shouldClose) {
                    Inventory.Close();
                }
                $.post("http://pepe-inventory/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
            }
        }
    });

    $("#item-give").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if(fromData.amount > 0) {
                $.post("http://pepe-inventory/GiveItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                    amount: parseInt(amount),
                }));
                Inventory.Close();
            }
        }
    });

    $(".item-slot").click(function(event) {
        if (event.shiftKey) {
            var itemData = $(this).data();
            $.post('http://pepe-inventory/UseItemShiftClick', JSON.stringify({
                slot: itemData.slot
            }));
        } 
    });

    $("#item-drop").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if (amount == 0) {amount=fromData.amount}
            $(this).css("background", "rgba(35,35,35, 0.7");
            $.post("http://pepe-inventory/DropItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
                amount: parseInt(amount),
            }));
        }
    })
}

function updateweights($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    var otherinventory = otherLabel.toLowerCase();
    if (otherinventory.split("-")[0] == "dropped") {
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if (toData !== null && toData !== undefined) {
            InventoryError($fromInv, $fromSlot);
            return false;
        }
    }

    if (($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "hotbar") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "hotbar")) {
        return true;
    }

    if (($fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").split("-")[0] == "itemshop") || ($fromInv.attr("data-inventory") == "crafting" && $toInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');

        }

        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toAmount == 0 && ($fromInv.attr("data-inventory").split("-")[0] == "itemshop" || $fromInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($toInv.attr("data-inventory").split("-")[0] == "itemshop" || $toInv.attr("data-inventory") == "crafting") {
        itemData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>('+itemData.amount+') €'+itemData.price+'</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        } else {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + itemData.image + '" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>'+itemData.amount + ' (' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + itemData.label + '</p></div>');
        }
 
        InventoryError($fromInv, $fromSlot);
        return false;
    }

    if ($fromInv.attr("data-inventory") != $toInv.attr("data-inventory")) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeight = totalWeight + (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (toData.weight * toData.amount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeight = totalWeight - (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (toData.weight * toData.amount);
            }
        }
    }

    if (totalWeight > playerMaxWeight || (totalWeightOther > otherMaxWeight && $fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting")) {
        InventoryError($fromInv, $fromSlot);
        return false;
    }
    $("#player-inv-weight").html("Cân nặng: " + (parseInt(totalWeight) / 1000).toFixed(2) + " / " + (playerMaxWeight / 1000).toFixed(2));
    if ($fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $toInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting" && $toInv.attr("data-inventory") != "crafting") {
        $("#other-inv-label").html(otherLabel)
        $("#other-inv-weight").html("Cân nặng: " + (parseInt(totalWeightOther) / 1000).toFixed(2) + " / " + (otherMaxWeight / 1000).toFixed(2))
    }
    return true;
}

var combineslotData = null;

$(document).on('click', '.CombineItem', function(e){
    e.preventDefault();
    if (combineslotData.toData.combinable.anim != null) {
        $.post('http://pepe-inventory/combineWithAnim', JSON.stringify({
            combineData: combineslotData.toData.combinable,
            usedItem: combineslotData.toData.name,
            requiredItem: combineslotData.fromData.name
            
        }))
    } else {
        $.post('http://pepe-inventory/combineItem', JSON.stringify({
            reward: combineslotData.toData.combinable.reward,
            toItem: combineslotData.toData.name,
            fromItem: combineslotData.fromData.name
        }))
    }
    Inventory.Close();
});

$(document).on('click', '.SwitchItem', function(e){
    e.preventDefault();
    $(".combine-option-container").hide();

    optionSwitch(combineslotData.fromSlot, combineslotData.toSlot, combineslotData.fromInv, combineslotData.toInv, combineslotData.toAmount, combineslotData.toData, combineslotData.fromData)
});

function optionSwitch($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, toData, fromData) {
    fromData.slot = parseInt($toSlot);
    
    $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);

    $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
    $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

    
    if ($toSlot < 6) {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    } else {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>');
    }

    toData.slot = parseInt($fromSlot);

    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);

    if ($fromSlot < 6) {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
    } else {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + toData.label + '</p></div>');
    }

    $.post("http://pepe-inventory/SetInventoryData", JSON.stringify({
        fromInventory: $fromInv.attr("data-inventory"),
        toInventory: $toInv.attr("data-inventory"),
        fromSlot: $fromSlot,
        toSlot: $toSlot,
        fromAmount: $toAmount,
        toAmount: toData.amount,
    }));
}

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    var otherinventory = otherLabel.toLowerCase();

    if (otherinventory.split("-")[0] == "dropped") {
        if (toData !== null && toData !== undefined) {
            InventoryError($fromInv, $fromSlot);
            return;
        }
    } 

    if (fromData !== undefined && fromData.amount >= $toAmount) {       
        if (($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") && $toInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        }

        if ($toAmount == 0 && $fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $fromInv.attr("data-inventory") == "crafting") {
            InventoryError($fromInv, $fromSlot);
            return;
        } else if ($toAmount == 0) {
            $toAmount=fromData.amount
        }
        if((toData != undefined || toData != null) && toData.name == fromData.name && !fromData.unique) {
            var newData = [];
            newData.name = toData.name;
            newData.label = toData.label;
            newData.amount = (parseInt($toAmount) + parseInt(toData.amount));
            newData.type = toData.type;
            newData.description = toData.description;
            newData.image = toData.image;
            newData.weight = toData.weight;
            newData.info = toData.info;
            newData.useable = toData.useable;
            newData.unique = toData.unique;
            newData.slot = parseInt($toSlot);

            if (fromData.amount == $toAmount) {
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + '</p></div>';
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }
                
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) { newData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = (newData.info.quality).toFixed();
                        } else {
                            qualityLabel = (newData.info.quality);
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "GEBROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
            } else if(fromData.amount > $toAmount) {
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);

                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + '</p></div>';
                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newData.image + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + ' (' + ((newData.weight * newData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((newData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) { newData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = (newData.info.quality).toFixed();
                        } else {
                            qualityLabel = (newData.info.quality);
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "BỊ HỎNG";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
                
                // From Data zooi
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");

                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') €'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {
                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';
                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';                       
                        }
                    }

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) { newDataFrom.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = (newDataFrom.info.quality).toFixed();
                            } else {
                                qualityLabel = (newDataFrom.info.quality);
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = "BỊ HỎNG";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }
                }    
            }
            $.post("http://pepe-inventory/PlayDropSound", JSON.stringify({}));
            $.post("http://pepe-inventory/SetInventoryData", JSON.stringify({
                fromInventory: $fromInv.attr("data-inventory"),
                toInventory: $toInv.attr("data-inventory"),
                fromSlot: $fromSlot,
                toSlot: $toSlot,
                fromAmount: $toAmount,
            }));
        } else {
            if (fromData.amount == $toAmount) {
                if (toData != undefined && toData.combinable != null && isItemAllowed(fromData.name, toData.combinable.accept)) {
                    $.post('http://pepe-inventory/getCombineItem', JSON.stringify({item: toData.combinable.reward}), function(item){
                        $('.combine-option-text').html("<p>Als je dit item combined krijg je een: <b>"+item.label+"</b></p>");
                    })
                    $(".combine-option-container").fadeIn(100);
                    combineslotData = []
                    combineslotData.fromData = fromData
                    combineslotData.toData = toData
                    combineslotData.fromSlot = $fromSlot
                    combineslotData.toSlot = $toSlot
                    combineslotData.fromInv = $fromInv
                    combineslotData.toInv = $toInv
                    combineslotData.toAmount = $toAmount
                    return
                }

                fromData.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + fromData.label + '</p></div>';
                if ((fromData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromData.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromData.image + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + ' (' + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((fromData.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        if (fromData.info.quality == undefined) { fromData.info.quality = 100.0; }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (fromData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (fromData.info.quality > 25 && fromData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (fromData.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (fromData.info.quality !== undefined) {
                            qualityLabel = (fromData.info.quality).toFixed();
                        } else {
                            qualityLabel = (fromData.info.quality);
                        }
                        if (fromData.info.quality == 0) {
                            qualityLabel = "BỊ HỎNG";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
    
                if (toData != undefined) {
                    toData.slot = parseInt($fromSlot);
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);

                    var ItemLabel = '<div class="item-slot-label"><p>' + toData.label + '</p></div>';
                    if ((toData.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toData.label + '</p></div>';                       
                        }
                    }
 
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toData.image + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + ' (' + ((toData.weight * toData.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((toData.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            if (toData.info.quality == undefined) { toData.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (toData.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (toData.info.quality > 25 && toData.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (toData.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (toData.info.quality !== undefined) {
                                qualityLabel = (toData.info.quality).toFixed();
                            } else {
                                qualityLabel = (toData.info.quality);
                            }
                            if (toData.info.quality == 0) {
                                qualityLabel = "BỊ HỎNG";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }

                    $.post("http://pepe-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        toAmount: toData.amount,
                    }));
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    }

                    $.post("http://pepe-inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                    }));
                }
                $.post("http://pepe-inventory/PlayDropSound", JSON.stringify({}));
            } else if(fromData.amount > $toAmount && (toData == undefined || toData == null)) {
                var newDataTo = [];
                newDataTo.name = fromData.name;
                newDataTo.label = fromData.label;
                newDataTo.amount = parseInt($toAmount);
                newDataTo.type = fromData.type;
                newDataTo.description = fromData.description;
                newDataTo.image = fromData.image;
                newDataTo.weight = fromData.weight;
                newDataTo.info = fromData.info;
                newDataTo.useable = fromData.useable;
                newDataTo.unique = fromData.unique;
                newDataTo.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + newDataTo.label + '</p></div>';
                if ((newDataTo.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataTo.label + '</p></div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataTo.image + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + ' (' + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                }

                if ((newDataTo.name).split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        if (newDataTo.info.quality == undefined) { 
                            newDataTo.info.quality = 100.0; 
                        }
                        var QualityColor = "rgb(39, 174, 96)";
                        if (newDataTo.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newDataTo.info.quality > 25 && newDataTo.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newDataTo.info.quality >= 50) {
                            QualityColor = "rgb(39, 174, 96)";
                        }
                        if (newDataTo.info.quality !== undefined) {
                            qualityLabel = (newDataTo.info.quality).toFixed();
                        } else {
                            qualityLabel = (newDataTo.info.quality);
                        }
                        if (newDataTo.info.quality == 0) {
                            qualityLabel = "BỊ HỎNG";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }

                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>('+newDataFrom.amount+') €'+newDataFrom.price+'</p></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>');
                } else {

                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';
                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';                       
                        }
                    }

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.image + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + ' (' + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }

                    if ((newDataFrom.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) { newDataFrom.info.quality = 100.0; }
                            var QualityColor = "rgb(39, 174, 96)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(39, 174, 96)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = (newDataFrom.info.quality).toFixed();
                            } else {
                                qualityLabel = (newDataFrom.info.quality);
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = "BỊ HỎNG";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    }
                }
                $.post("http://pepe-inventory/PlayDropSound", JSON.stringify({}));
                $.post("http://pepe-inventory/SetInventoryData", JSON.stringify({
                    fromInventory: $fromInv.attr("data-inventory"),
                    toInventory: $toInv.attr("data-inventory"),
                    fromSlot: $fromSlot,
                    toSlot: $toSlot,
                    fromAmount: $toAmount,
                }));
            } else {
                InventoryError($fromInv, $fromSlot);
            }
        }
    } else {
        //InventoryError($fromInv, $fromSlot);
    }
    handleDragDrop();
}

function isItemAllowed(item, allowedItems) {
    var retval = false
    $.each(allowedItems, function(index, i){
        if (i == item) {
            retval = true;
        }
    });
    return retval
}

function InventoryError($elinv, $elslot) {
    $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(156, 20, 20, 0.5)").css("transition", "background 500ms");
    setTimeout(function() {
        $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(255, 255, 255, 0.03)");
    }, 500)
    $.post("http://pepe-inventory/PlayDropFail", JSON.stringify({}));
}

var requiredItemOpen = false;

(() => {
    Inventory = {};

    Inventory.slots = 25;

    Inventory.dropslots = 15;
    Inventory.droplabel = "Grond";
    Inventory.dropmaxweight = 100000

    Inventory.Error = function() {
        $.post("http://pepe-inventory/PlayDropFail", JSON.stringify({}));
    }

    Inventory.IsWeaponBlocked = function(WeaponName) {
        var DurabilityBlockedWeapons = [ 
            "weapon_molotov",
            "weapon_unarmed"
        ]

        var retval = false;
        $.each(DurabilityBlockedWeapons, function(i, name) {
            if (name == WeaponName) {
                retval = true;
            }
        });
        return retval;
    }

    Inventory.QualityCheck = function(item, IsHotbar, IsOtherInventory) {
        if (!Inventory.IsWeaponBlocked(item.name)) {
            if ((item.name).split("_")[0] == "weapon") {
                if (item.info.quality == undefined) { item.info.quality = 100; }
                var QualityColor = "rgb(39, 174, 96)";
                if (item.info.quality < 25) {
                    QualityColor = "rgb(192, 57, 43)";
                } else if (item.info.quality > 25 && item.info.quality < 50) {
                    QualityColor = "rgb(230, 126, 34)";
                } else if (item.info.quality >= 50) {
                    QualityColor = "rgb(39, 174, 96)";
                }
                if (item.info.quality !== undefined) {
                    qualityLabel = (item.info.quality).toFixed();
                } else {
                    qualityLabel = (item.info.quality);
                }
                if (item.info.quality == 0) {
                    qualityLabel = "GEBROKEN";
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": "100%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": "100%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": "100%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                } else {
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            }).find('p').html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        }).find('p').html(qualityLabel);
                    }
                }
            }
        }
    }

    Inventory.Open = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;

        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();

        if (requiredItemOpen) {
            $(".requiredItem-container").hide();
            requiredItemOpen = false;
        }

        $("#framework-inventory").fadeIn(300);
        if(data.other != null && data.other != "") {
            $(".other-inventory").attr("data-inventory", data.other.name);
        } else {
            $(".other-inventory").attr("data-inventory", 0);
        }
        // First 5 Slots
        for(i = 1; i < 6; i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>' + i + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        // Inventory
        for(i = 6; i < (data.slots + 1); i++) {
            if (i == 41) {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            } else {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        }

        if (data.other != null && data.other != "") {
            for(i = 1; i < (data.other.slots + 1); i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        } else {
            for(i = 1; i < (Inventory.dropslots + 1); i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
            $(".other-inventory .item-slot").css({
                "background-color": "rgba(120, 10, 20, 0.05)"
            });
        }

        if (data.inventory !== null) {
            $.each(data.inventory, function (i, item) {
                if (item != null) {
                    totalWeight += (item.weight * item.amount);
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    if (item.slot < 6) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else if (item.slot == 41) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                    Inventory.QualityCheck(item, false, false);
                }
            });
        }

        if ((data.other != null && data.other != "") && data.other.inventory != null) {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += (item.weight * item.amount);
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    if (item.price != null) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>('+item.amount+') €'+item.price+'</p></div>' + ItemLabel);
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    Inventory.QualityCheck(item, false, true);
                }
            });
        }

        $("#player-inv-weight").html("Cân nặng: " + (totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2));
        playerMaxWeight = data.maxweight;
        if (data.other != null) 
        {
            var name = data.other.name.toString()
            if (name != null && (name.split("-")[0] == "itemshop" || name == "crafting")) {
                $("#other-inv-label").html(data.other.label);
            } else {
                $("#other-inv-label").html(data.other.label)
                $("#other-inv-weight").html("Cân nặng: " + (totalWeightOther / 1000).toFixed(2) + " / " + (data.other.maxweight / 1000).toFixed(2))
            }
            otherMaxWeight = data.other.maxweight;
            otherLabel = data.other.label;
        } else {
            $("#other-inv-label").html(Inventory.droplabel)
            $("#other-inv-weight").html("Cân nặng: " + (totalWeightOther / 1000).toFixed(2) + " / " + (Inventory.dropmaxweight / 1000).toFixed(2))
            otherMaxWeight = Inventory.dropmaxweight;
            otherLabel = Inventory.droplabel;
        }

        $.each(data.maxammo, function(index, ammotype){
            $("#"+index+"_ammo").find('.ammo-box-amount').css({"height":"0%"});
        });

        if (data.Ammo !== null) {
            $.each(data.Ammo, function(i, amount){
                var Handler = i.split("_");
                var Type = Handler[1].toLowerCase();
                if (amount > data.maxammo[Type]) {
                    amount = data.maxammo[Type]
                }
                var Percentage = (amount / data.maxammo[Type] * 100)

                $("#"+Type+"_ammo").find('.ammo-box-amount').css({"height":Percentage+"%"});
                $("#"+Type+"_ammo").find('span').html(amount+"x");
            });
        }

        handleDragDrop();
    };

    Inventory.Close = function() {
        $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
        $(".ply-hotbar-inventory").css("display", "block");
        $(".ply-iteminfo-container").css("display", "none");
        $("#framework-inventory").fadeOut(300);
        $(".combine-option-container").hide();
        $(".item-slot").remove();
        if ($("#rob-money").length) {
            $("#rob-money").remove();
        }
        $.post("http://pepe-inventory/CloseInventory", JSON.stringify({}));

        if (AttachmentScreenActive) {
            $("#framework-inventory").css({"left": "0vw"});
            $(".weapon-attachments-container").css({"left": "-100vw"});
            AttachmentScreenActive = false;
        }

        if (ClickedItemData !== null) {
            $("#weapon-attachments").fadeOut(250, function(){
                $("#weapon-attachments").remove();
                ClickedItemData = {};
            });
        }
    };

    Inventory.Update = function(data) {
        totalWeight = 0;
        totalWeightOther = 0;
        $(".player-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();
        if (data.error) {
            Inventory.Error();
        }
        for(i = 1; i < (data.slots + 1); i++) {
            if (i == 41) {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            } else {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }        
        }

        $.each(data.inventory, function (i, item) {
            if (item != null) {
                totalWeight += (item.weight * item.amount);
                if (item.slot < 6) {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                } else if (item.slot == 41) {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                } else {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div><div class="item-slot-label"><p>' + item.label + '</p></div>');
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                }
            }
        });

        $("#player-inv-weight").html("Cân nặng: " + (totalWeight / 1000).toFixed(2) + " / " + (data.maxweight / 1000).toFixed(2));

        handleDragDrop();
    };

    Inventory.ToggleHotbar = function(data) {
        if (data.open) {
            $(".z-hotbar-inventory").html("");
            for(i = 1; i < 6; i++) {
                var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="'+i+'"> <div class="z-hotbar-item-slot-key"><p>'+i+'</p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>'
                $(".z-hotbar-inventory").append(elem);
            }
            // var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="41"> <div class="z-hotbar-item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>'
            // $(".z-hotbar-inventory").append(elem);
            $.each(data.items, function(i, item){
                if (item != null) {
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + '</p></div>';
                    if ((item.name).split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div>';                       
                        }
                    }
                    if (item.slot == 41) {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>' + item.slot + '</p></div><div class="z-hotbar-item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + ' (' + ((item.weight * item.amount) / 1000).toFixed(1) + ')</p></div>' + ItemLabel);
                    }
                    Inventory.QualityCheck(item, true, false);
                }
            });
            $(".z-hotbar-inventory").fadeIn(150);
        } else {
            $(".z-hotbar-inventory").fadeOut(150, function(){
                $(".z-hotbar-inventory").html("");
            });
        }
    }

    Inventory.UseItem = function(data) {
        $(".itembox-container").hide();
        $(".itembox-container").fadeIn(250);
        $("#itembox-action").html("<p>Đã sử dụng</p>");
        $("#itembox-label").html("<p>"+data.item.label+"</p>");
        $("#itembox-image").html('<div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>')
        setTimeout(function(){
            $(".itembox-container").fadeOut(250);
        }, 2000)
    };

    var itemBoxtimer = null;
    var requiredTimeout = null;

    Inventory.itemBox = function(data) {
        if (itemBoxtimer !== null) {
            clearTimeout(itemBoxtimer)
        }
        var type = "Đã sử dụng"
        if (data.type == "add") {
            type = "Đã nhận";
        } else if (data.type == "remove") { 
            type = "Đã xóa";
        }

        var $itembox = $(".itembox-container.template").clone();
        $itembox.removeClass('template');
        $itembox.html('<div id="itembox-action"><p>' + type + '</p></div><div id="itembox-label"><p>'+data.item.label+'</p></div><div class="item-slot-img"><img src="images/' + data.item.image + '" alt="' + data.item.name + '" /></div>');
        $(".itemboxes-container").prepend($itembox);
        $itembox.fadeIn(250);
        setTimeout(function() {
            $.when($itembox.fadeOut(300)).done(function() {
                $itembox.remove()
            });
        }, 3000);
    };

    Inventory.RequiredItem = function(data) {
        if (requiredTimeout !== null) {
            clearTimeout(requiredTimeout)
        }
        if (data.toggle) {
            if (!requiredItemOpen) {
                $(".requiredItem-container").html("");
                $.each(data.items, function(index, item){
                    var element = '<div class="requiredItem-box"><div id="requiredItem-action">Nodig</div><div id="requiredItem-label"><p>'+item.label+'</p></div><div id="requiredItem-image"><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div></div></div>'
                    $(".requiredItem-container").hide();
                    $(".requiredItem-container").append(element);
                    $(".requiredItem-container").fadeIn(100);
                });
                requiredItemOpen = true;
            }
        } else {
            $(".requiredItem-container").fadeOut(100);
            requiredTimeout = setTimeout(function(){
                $(".requiredItem-container").html("");
                requiredItemOpen = false;
            }, 100)
        }
    };

    var AmountText = document.getElementById("item-amount");
    AmountText.addEventListener("change", function() {
        var Amount = $("#item-amount").val();
        if (Amount == '' || Amount == undefined) {
            $("#item-amount").val(0);
        }
    });

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Inventory.Open(event.data);
                    break;
                case "close":
                    Inventory.Close();
                    break;
                case "update":
                    Inventory.Update(event.data);
                    break;
                case "itemBox":
                    Inventory.itemBox(event.data);
                    break;
                case "requiredItem":
                    Inventory.RequiredItem(event.data);
                    break;
                case "toggleHotbar":
                    Inventory.ToggleHotbar(event.data);
                    break;
                case "RobMoney":
                    $(".inv-options-list").append('<div class="inv-option-item" id="rob-money"><p>NEEM GELD</p></div>');
                    $("#rob-money").data('TargetId', event.data.TargetId);
                    break;
            }
        })
    }

})();

$(document).on('click', '#rob-money', function(e){
    e.preventDefault();
    var TargetId = $(this).data('TargetId');
    $.post('http://pepe-inventory/RobMoney', JSON.stringify({
        TargetId: TargetId
    }));
    $("#rob-money").remove();
});