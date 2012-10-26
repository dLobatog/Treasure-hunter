var array_length;

$( function() { 
  var counter = 0;
  
  set_attributes(counter);

  $('#left-arrow').click( function() {
    if(counter == 0){
      counter = array_length;
      set_attributes(counter);
    } else {
      counter--;
      set_attributes(counter);
    }
  });

  $('#right-arrow').click( function() {
    if(counter == array_length){
      counter = 0;
      set_attributes(counter);
    } else {
      counter++;
      set_attributes(counter);
    } 
  });        
} ); 

function set_attributes(counter) { 
  $.vegas({ src:backgrounds[counter], fade:1000 })('overlay', { src:'/overlays/11.png' });
  $(".product").attr("href", urls[counter]);
  $('#title').html('<h1>' + titles[counter] + '<h1>');
  $('#price').html(prices[counter]);
  $('#availability').html(availabilities[counter]);
  $('#description').html(descriptions[counter]);
} 
