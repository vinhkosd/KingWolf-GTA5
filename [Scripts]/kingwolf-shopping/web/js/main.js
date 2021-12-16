$( document ).ready(function() {
  jconfirm.pluginDefaults.useBootstrap = false
  $('.close').click(function(e) {
    modal.style.display = "none";
    modalBill.style.display = "none";
    modalPendingBill.style.display = "none";
  });

  $('.close-footer').click(function(e) {
    modal.style.display = "none";
    modalBill.style.display = "none";
    modalPendingBill.style.display = "none";
  });
  // $('.btn-cart').click(function(event) {
  //   console.log(event)
  //   var button = event.target;
  //   var product = button.parentElement.parentElement;
  //   var img = product.parentElement.getElementsByClassName("img-prd")[0].src
  //   var title = product.getElementsByClassName("content-product-h3")[0].innerText
  //   var prodid = product.getElementsByClassName("content-product-h3")[0].getAttribute("data-id")
  //   var price = product.getElementsByClassName("price")[0].innerText
  //   addItemToCart(title, price, img, prodid)
  //   // Khi thêm sản phẩm vào giỏ hàng thì sẽ hiển thị modal
  //   modal.style.display = "block";
    
  //   updatecart()
  // });
});
windowIsOpened = false
let pizzaItems = [];
let tradaItems = [];
let productState = "pizza";
let productBills = [];
let canOpenBill = false;
let productPendingBills = [];

window.addEventListener('message', function(event) {
	item = event.data;
	switch (event.data.action) {
		case 'mainmenu':
      console.log(event.data)
      pizzaItems = event.data.pizzaProduct;
      tradaItems = event.data.tradaProduct;
      productBills = event.data.productBills;
      productPendingBills = event.data.productPendingBills;
      canOpenBill = event.data.canOpenBill;
      renderProduct(pizzaItems);
      refreshBills();
      refreshPendingBills();
      productState = "pizza";

      if(canOpenBill) {
        document.getElementById("bill-button").style.display = "block"
        document.getElementById("pendingbill-button").style.display = "block"
      } else {
        document.getElementById("bill-button").style.display = "none"
        document.getElementById("pendingbill-button").style.display = "bone"
      }

			if (!windowIsOpened) {
				windowIsOpened = true
				
				$(".mainmenu").fadeIn();
			}
			break;
    case 'refreshdata':
      pizzaItems = event.data.pizzaProduct;
      tradaItems = event.data.tradaProduct;
      productBills = event.data.productBills;
      canOpenBill = event.data.canOpenBill;
      productPendingBills = event.data.productPendingBills;
      if (productState == "pizza") {
        renderProduct(pizzaItems);
      }else {
        renderProduct(tradaItems);
      }
      
      refreshBills();
      refreshPendingBills();

      if(canOpenBill) {
        document.getElementById("bill-button").style.display = "block"
        document.getElementById("pendingbill-button").style.display = "block"
      } else {
        document.getElementById("bill-button").style.display = "none"
        document.getElementById("pendingbill-button").style.display = "bone"
      }

      break;
	}
});

function renderProduct(products) {
  let html = '';
  $(".products").children().html("");
  $.each(products, function (i, product) {
    let productElm = `
      <li class="main-product">
        <div class="img-product">
            <img class="img-prd"
                src="./${product.name}.png"
                alt="" style="width: 20vh;height: 20vh;">
        </div>
        <div class="content-product">
            <h3 class="content-product-h3" data-id="${i}">${product.label}</h3>
            <div class="content-product-deltals">
                <div class="price">
                    <span class="money">${product.price}$</span>
                </div>
                <button type="button" class="btn btn-cart">Thêm Vào Giỏ</button>
            </div>
        </div>
      </li>
    `;
    html += productElm;
  });
  $(".products").children().html(html);
  var add_cart = document.getElementsByClassName("btn-cart");
  for (var i = 0; i < add_cart.length; i++) {
    var add = add_cart[i];
    add.addEventListener("click", function (event) {

      var button = event.target;
      var product = button.parentElement.parentElement;
      var img = product.parentElement.getElementsByClassName("img-prd")[0].src
      var title = product.getElementsByClassName("content-product-h3")[0].innerText
      var prodid = product.getElementsByClassName("content-product-h3")[0].getAttribute("data-id")
      var price = product.getElementsByClassName("price")[0].innerText
      addItemToCart(title, price, img, prodid)
      // Khi thêm sản phẩm vào giỏ hàng thì sẽ hiển thị modal
      modal.style.display = "block";
      
      updatecart()
    })
  }
}

function closeMenu() {
  windowIsOpened = false
				
  $(".mainmenu").fadeOut();
  $.post('https://kingwolf-shopping/action', JSON.stringify ({
    action: "close",
  }));
}

// Modal
var modal = document.getElementById("myModal");
var modalBill = document.getElementById("myProductBillModal");
var modalPendingBill = document.getElementById("myProductPendingBillModal");
var btn = document.getElementById("cart");
var btnclose = document.getElementById("close");
var btnpizza = document.getElementById("pizza-button");
var btntrada = document.getElementById("trada-button");
var btnbill = document.getElementById("bill-button");
var btnpendingbill = document.getElementById("pendingbill-button");
var close = document.getElementsByClassName("close")[0];
var close_footer = document.getElementsByClassName("close-footer")[0];
var order = document.getElementsByClassName("order")[0];
let carts = [];

btnbill.onclick = function () {
  modalBill.style.display = "block";
}

btnpendingbill.onclick = function () {
  modalPendingBill.style.display = "block";
}

btnpizza.onclick = function () {
  document.getElementsByClassName("cart-items")[0].innerText = ""
  carts = [];
  updatecart()
  renderProduct(pizzaItems);
  productState = "pizza";
}

btntrada.onclick = function () {
  document.getElementsByClassName("cart-items")[0].innerText = ""
  carts = [];
  updatecart()
  renderProduct(tradaItems);
  productState = "trada";
}

btn.onclick = function () {
  modal.style.display = "block";
}

btnclose.onclick = function () {
  windowIsOpened = false
				
  $(".mainmenu").fadeOut();
  $.post('https://kingwolf-shopping/action', JSON.stringify ({
    action: "close",
  }));
}

close.onclick = function () {
  modal.style.display = "none";
  modalBill.style.display = "none";
  modalPendingBill.style.display = "none";
}
close_footer.onclick = function () {
  modal.style.display = "none";
  modalBill.style.display = "none";
  modalPendingBill.style.display = "none";
}
order.onclick = function () {
  if (carts.length > 0) {
    $.post('https://kingwolf-shopping/action', JSON.stringify ({
      action: "buyItem",
      carts,
      productState
    }));

    $.alert({
      boxWidth: '30%',
      title: 'Thông báo!',
      content: 'Cảm ơn bạn đã đặt hàng',
      animation: 'scale',
      closeAnimation: 'scale',
      buttons: {
        close: function(){
          windowIsOpened = false
          $(".mainmenu").fadeOut();
          $.post('https://kingwolf-shopping/action', JSON.stringify ({
            action: "close"
          }));
        }
      }
    });
  } else {
    $.alert({
      boxWidth: '30%',
      title: 'Thông báo!',
      content: 'Giỏ hàng trống',
      animation: 'scale',
      closeAnimation: 'scale',
    });
  }
  document.getElementsByClassName("cart-items")[0].innerText = ""
  carts = [];
  updatecart()
  // alert("Cảm ơn bạn đã thanh toán đơn hàng")
  
}
window.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
    modalBill.style.display = "none";
    modalPendingBill.style.display = "none";
  }
}

// Giỏ Hàng Of thanhlongcart

// xóa cart
var remove_cart = document.getElementsByClassName("btn-danger");
for (var i = 0; i < remove_cart.length; i++) {
  var button = remove_cart[i]
  button.addEventListener("click", function () {
    var button_remove = event.target
    button_remove.parentElement.parentElement.remove()
    updatecart()
  })
}
// thay đổi số lượng
var quantity_input = document.getElementsByClassName("cart-quantity-input");
for (var i = 0; i < quantity_input.length; i++) {
  var input = quantity_input[i];
  input.addEventListener("change", function (event) {
    var input = event.target
    if (isNaN(input.value) || input.value <= 0) {
      input.value = 1;
    }
    updatecart()
  })
}

// Thêm vào giỏ
var add_cart = document.getElementsByClassName("btn-cart");
for (var i = 0; i < add_cart.length; i++) {
  var add = add_cart[i];
  add.addEventListener("click", function (event) {

    var button = event.target;
    var product = button.parentElement.parentElement;
    var img = product.parentElement.getElementsByClassName("img-prd")[0].src
    var title = product.getElementsByClassName("content-product-h3")[0].innerText
    var price = product.getElementsByClassName("price")[0].innerText
    var prodid = product.getElementsByClassName("content-product-h3")[0].getAttribute("data-id")
    addItemToCart(title, price, img, prodid)
    // Khi thêm sản phẩm vào giỏ hàng thì sẽ hiển thị modal
    modal.style.display = "block";
    
    updatecart()
  })
}

function addItemToCart(title, price, img, productid) {
  var cartRow = document.createElement('div');
  cartRow.classList.add('cart-row');
  var cartItems = document.getElementsByClassName('cart-items')[0];
  var cart_title = cartItems.getElementsByClassName('cart-item-title');
  let productList = productState == "pizza" ? pizzaItems : tradaItems;
  var cartData = productList[productid];

  let findItem = carts.find(item => item.title == title);

  if(!findItem) {
    let items= {
      name: cartData.name,
      title,
      price,
      amount: 1
    };

    carts.push(items);
  }

  for (var i = 0; i < cart_title.length; i++) {
    if (cart_title[i].innerText == title) {
      // alert('Sản Phẩm Đã Có Trong Giỏ Hàng')
      $.alert({
        boxWidth: '30%',
        title: 'Thông báo!',
        content: 'Sản Phẩm Đã Có Trong Giỏ Hàng!',
        animation: 'scale',
        closeAnimation: 'scale',
      });
      return
    }
  }

  var cartRowContents = `
  <div class="cart-item cart-column">
      <img class="cart-item-image" src="${img}" width="100" height="100">
      <span class="cart-item-title">${title}</span>
  </div>
  <span class="cart-price cart-column">${price}</span>
  <div class="cart-quantity cart-column">
      <input class="cart-quantity-input" type="number" value="1">
      <button class="btn btn-danger" type="button">Xóa</button>
  </div>`
  cartRow.innerHTML = cartRowContents
  cartItems.append(cartRow)
  cartRow.getElementsByClassName('btn-danger')[0].addEventListener('click', function () {
    var button_remove = event.target
    cart_row = button_remove.parentElement.parentElement
    var total = 0;
    var title = cart_row.getElementsByClassName("cart-item-title")[0].innerText

    let index = carts.findIndex(item => item.title == title);

    
    if(index !== -1) {
      carts.splice(index, 1);
    }

    button_remove.parentElement.parentElement.remove()
    updatecart()
  })
  cartRow.getElementsByClassName('cart-quantity-input')[0].addEventListener('change', function (event) {
    var input = event.target
    if (isNaN(input.value) || input.value <= 0) {
      input.value = 1;
    }
    updatecart()
  })
}

function refreshBills() {
  document.getElementsByClassName("bill-items")[0].innerText = ""
  productBills.sort(function (a, b) {
    return b.id - a.id;
  });

  $.each(productBills, function (i, item) {
    var cartRow = document.createElement('div');
    cartRow.classList.add('bill-row');
    var cartItems = document.getElementsByClassName('bill-items')[0];
    
    var cartRowContents = `
    <div class="bill-item bill-column">
        <span class="bill-item-title">${i + 1}</span>
    </div>
    <span class="bill-price bill-column">${item.label_note}</span>
    <div class="bill-quantity bill-column">
        <span class="bill-item-title">${item.target_name}</span>
        <button class="btn btn-warning" type="button">GPS</button>
    </div>
    <div class="bill-phone bill-column">
        <span class="bill-item-title">${item.phone}<br/>
        <button class="btn btn-success" type="button">Gọi</button>
        <button class="btn btn-accept" style="${item.created ? `display:none` : ``}" type="button">Nhận đơn</button></span>
        
    </div>
    `
    cartRow.innerHTML = cartRowContents
    cartItems.append(cartRow)

    cartRow.getElementsByClassName('btn-warning')[0].addEventListener('click', function () {
      setGPS(item.id);
    })

    cartRow.getElementsByClassName('btn-success')[0].addEventListener('click', function () {
      callPlayer(item.id);
    })
    cartRow.getElementsByClassName('btn-accept')[0].addEventListener('click', function () {
      acceptBill(item.id);
    })
  }); 
}

function refreshPendingBills() {
  document.getElementsByClassName("pendingbill-items")[0].innerText = ""
  productPendingBills.sort(function (a, b) {
    return b.id - a.id;
  });
  $.each(productPendingBills, function (i, item) {
    var cartRow = document.createElement('div');
    cartRow.classList.add('pendingbill-row');
    var cartItems = document.getElementsByClassName('pendingbill-items')[0];
    
    var cartRowContents = `
    <div class="pendingbill-item pendingbill-column">
        <span class="pendingbill-item-title">${i + 1}</span>
    </div>
    <span class="pendingbill-price pendingbill-column">${item.label_note}</span>
    <div class="pendingbill-quantity pendingbill-column">
        <span class="pendingbill-item-title">${item.target_name}</span>
        <button class="btn btn-warning" type="button">GPS</button>
    </div>
    <div class="pendingbill-phone pendingbill-column">
        <span class="pendingbill-item-title">${item.phone}<br/>
        <button class="btn btn-success" type="button">Gọi</button>
        <button class="btn btn-accept" style="${item.created ? `display:none` : ``}" type="button">Nhận đơn</button></span>
        
    </div>
    `
    cartRow.innerHTML = cartRowContents
    cartItems.append(cartRow)

    cartRow.getElementsByClassName('btn-warning')[0].addEventListener('click', function () {
      setGPS(item.id);
    })

    cartRow.getElementsByClassName('btn-success')[0].addEventListener('click', function () {
      callPlayer(item.id);
    })
    cartRow.getElementsByClassName('btn-accept')[0].addEventListener('click', function () {
      acceptBill(item.id);
    })
  }); 
}

function setGPS(i) {
  // productBills[i] = 
  $.post('https://kingwolf-shopping/action', JSON.stringify ({
    action: "setGPS",
    productId: i
  }));
  closeMenu()
}

function callPlayer(i) {
  // productBills[i] = 
  $.post('https://kingwolf-shopping/action', JSON.stringify ({
    action: "callPlayer",
    productId: i
  }));
  closeMenu()
}

function acceptBill(i) {
  // productBills[i] = 
  $.post('https://kingwolf-shopping/action', JSON.stringify ({
    action: "acceptBill",
    productId: i
  }));

  closeMenu()
}
// update cart 
function updatecart() {
  var cart_item = document.getElementsByClassName("cart-items")[0];
  var cart_rows = cart_item.getElementsByClassName("cart-row");
  var total = 0;
  for (var i = 0; i < cart_rows.length; i++) {
    var cart_row = cart_rows[i]
    var title = cart_row.getElementsByClassName("cart-item-title")[0].innerText

    let index = carts.findIndex(item => item.title == title);

    

    var price_item = cart_row.getElementsByClassName("cart-price ")[0]
    var quantity_item = cart_row.getElementsByClassName("cart-quantity-input")[0]
    if(index !== -1) {
      carts[index].amount = quantity_item.value;
    }
    var price = parseFloat(price_item.innerText)
    var quantity = quantity_item.value
      total = total + (price * quantity)
  }
  document.getElementsByClassName("cart-total-price")[0].innerText = total + '$'
}

// menu mobile
var btn_menu = document.getElementById("btnmenu");
btn_menu.addEventListener("click", function () {
  var item_menu = document.getElementById("menutop");
  if (item_menu.style.display === "block") {
    item_menu.style.display = "none";
  } else {
    item_menu.style.display = "block";
  }
})