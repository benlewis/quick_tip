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

  $('.dollar')


  $('#other-input').keyup(function() {
    var hidden  = $('#charge-amount');
    hidden.val($(this).val() * 100).trigger('change');
  }).blur(function() {
    var hidden  = $('#charge-amount');
    hidden.val($(this).val() * 100).trigger('change');
    $(this).formatCurrency();
    $(this).formatCurrency('.currencyLabel');
  }).focus(function () {
    $(this).val('');
  });

  $('#charge-amount').change(function() {
    console.log('Charge amount changed to ' + $(this).val());
  });

  $('#charge-amount-selector').children('a').each(function(){
    var button  = $(this);
    var group   = button.parents('#charge-amount-selector');
    var form    = button.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
    var value   = $(button).attr('data-value');

    button.click(function() {
      console.log('Clicked ' + value);
      hidden.val(value).trigger('change');

      group.children('a').each(function() {
        if (hidden.val() == $(this).attr('data-value')) {
          button.addClass('active');
        } else {
          $(this).removeClass('active');
        }
      })

      input = $('#other-input');
      if (value.indexOf("-") != -1) { //Other
        parts = value.split('-');
        input.attr('min', parts[0]);
        input.val(parts[1] / 100); //default
        input.attr('max', parts[2]);
        input.formatCurrency();
        input.formatCurrency('.currencyLabel');
        input.css('display', 'inline');
      } else {
        input.css('display', 'none');
      }
    });

  });
});