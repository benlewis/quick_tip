//This file is for all tip related javascript. It will be included in any page that uses the tip layout

$(function(){

  $('.cc-number').payment('formatCardNumber');
  $('.cc-exp').payment('formatCardExpiry');

  $('.cc-number').keypress(cc_number_input);
  $('.cc-number').keyup(function(e) {
    if (e.keyCode == 8) {
      cc_number_input();
    }
  });

  function cc_number_input() {
    var card_type = $.payment.cardType($("#stripe_card_credit_card_number").val());
    if (card_type != $("body").data("card_type")) {
      $("body").data("card_type", card_type);
      $("#cc-images > img").each(function(i,j) {
        if ($(this).attr("id") == card_type) {
          $(this).css({ 'opacity' : 1.0 })
        } else {
          $(this).css({ 'opacity' : 0.25 })
        }
      });
    }
  }

});