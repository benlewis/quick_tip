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

  $('#other-input').keyup(function() {
    var hidden  = $('#charge-amount');
    hidden.val($(this).val() * 100);
  }).blur(function() {
    var hidden  = $('#charge-amount');
    var new_val = $(this).val();
    var min     = $(this).attr('min');
    var max     = $(this).attr('max');
    if (new_val < min) {
      show_qtip($(this));
      new_val = min;
    } else if (new_val > max) {
      show_qtip($(this));
      new_val = max;
    }
    hidden.val(new_val * 100);
    $(this).val(new_val);
    $(this).formatCurrency();
    $(this).formatCurrency('.currencyLabel');
  }).focus(function () {
    console.log('fc');
    $(this).val('');
  });

  function create_qtip(input, min, max) {
    input.qtip({
      content: 'Donate $' + min + ' - $' + max,
      position: {
        my: 'bottom center',
        at: 'top center'
      },
      show: {
        ready: false
      },
      style: {
        classes: 'qtip-light'
      }
    });
  }

  function show_qtip(input) {
    input.qtip('api').set({
      'style.classes': 'qtip-red',
      'show.ready': true
    });
    setTimeout(hide_qtip,1000);
  }

  function hide_qtip() {
    input = $('#other-input');
    if (input.qtip('api')) {
      input.qtip('api').hide();
    }
  }


  $('#charge-amount-selector').children('a').each(function(){
    var button  = $(this);
    var group   = button.parents('#charge-amount-selector');
    var form    = button.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
    var value   = $(button).attr('data-value');

    button.click(function() {
      hide_qtip();
      hidden.val(value).trigger('change');

      group.children('a').each(function() {
        if (hidden.val() == $(this).attr('data-value')) {
          button.addClass('active');
        } else {
          $(this).removeClass('active');
        }
      })

      var input = $('#other-input');
      if (value.indexOf("-") != -1) { //Other
        var parts = value.split('-');

        var min = parts[0];
        var default_val = parts[1];
        var max = parts[2];

        input.attr('min', min);
        input.val(default_val);
        input.attr('max', max);

        if (!input.qtip('api')) {
          create_qtip(input, min, max);
        } else {
          input.qtip('api').set({
            'style.classes': 'qtip-light',
          });
        }

        input.formatCurrency();
        input.formatCurrency('.currencyLabel');
        input.css('display', 'inline');
        input.focus();
        input.qtip('api').show();
      } else {
        input.qtip('api').hide();
        input.css('display', 'none');
      }
    });

  });
});