//= require store/spree_core

$(function() {
  if ($(".select_address").length) {
    $('input#order_use_billing').unbind("click")
    $(".inner").hide();
    $(".inner input").prop("disabled", true);
    $(".inner select").prop("disabled", true);

    $('input#order_use_billing').click(function() {
      if ($(this).is(':checked')) {
        $(".shipping-with-select-address").hide();
      } else {
        $(".shipping-with-select-address").show();
      }
    }).triggerHandler('click');

    $("input[name='order[bill_address_id]']:radio").change(function(){
      if ($("input[name='order[bill_address_id]']:checked").val() == '0') {
        $("#billing .inner").show();
        $("#billing .inner input").prop("disabled", false);
        $("#billing .inner select").prop("disabled", false);
      } else {
        $("#billing .inner").hide();
        $("#billing .inner input").prop("disabled", true);
        $("#billing .inner select").prop("disabled", true);
      }
    });

    $("input[name='order[ship_address_id]']:radio").change(function(){
      if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
        $("#shipping .inner").show();
        $("#shipping .inner input").prop("disabled", false);
        $("#shipping .inner select").prop("disabled", false);
      } else {
        $("#shipping .inner").hide();
        $("#shipping .inner input").prop("disabled", true);
        $("#shipping .inner select").prop("disabled", true);
      }
    });
  }
});