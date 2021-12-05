// Selectors
let output = document.querySelector("p");

// Start Function
let numbers = Array.from(Array(60).keys()).map(String);
for (let i = 0; i < 10; i++) {
  numbers[i] = "0" + numbers[i];
}
numbers.push("00");

let time, loop;
let sec = "00",
  min = "00",
  s = 1,
  m = 1,
  startCheck = false,
  resetCheck = false;

function startFunc(m = 0, s = 3) {
  resetFunc();

  startCheck = true;


  loop = setInterval(function () {

    // if (m + s == 0) {
    //   stopFunc();
    //   return;
    // }
    sec = numbers[s];
    min = numbers[m];

    if (m > 0 && s == 59) {
      //m--;
    }

    if (m > 0 && s == 0) {
      s = 60;
      if (m > 0) {
        m--;
      }
    }
    s--;

    time = `${min}:${sec}`;
    output.textContent = time;

    if (min + sec == "0000") {
      resetFunc();
    }
  }, 1000);
}

// Stop Function
function stopFunc() {
  stopSong();
  clearInterval(loop);
  startCheck = false;
  output.style.border = "1px solid #b33939";
}

// Reset Function
function resetFunc() {
  clearInterval(loop);
  time = "00:00";
  output.textContent = time;
  resetCheck = true;
  startCheck = false;
  output.style.border = "1px solid #b33939";
}

var myAudio = new Audio('song.mp3');
function playSong() {
  try {
    myAudio.remove(); 
  } catch {
    
  }
  myAudio = new Audio('song.mp3');
  myAudio.play();

  output.style.border = "1px solid #00f00c"; // green
}

function stopSong() {
  try {
    myAudio.pause();
    myAudio = undefined;
  } catch {
    
  }

  output.style.border = "1px solid #b33939"; // red
}

window.addEventListener('message', function(event) {
  let item = event.data;

  if (item.show === true) {
    document.querySelector("body").style = "display: flex";
  }

  if (item.show === false) {
    document.querySelector("body").style = "display: none";
  }
  
  if (item.start) {
    return startFunc(item.m, item.s);
  }

  if (item.reset) {
    return resetFunc();
  }

  if (item.stop) {
    return stopFunc();
  }

  if (item.playSong) {
    return playSong();
  }

  if (item.stopSong) {
    return stopSong();
  }

});