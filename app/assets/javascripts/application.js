// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require select2
//= require_self

$(document).ready(function() {
  $(".select2").select2();

  $("#transaction_search").on("change", ":input", function() {
    $("#transaction_search").submit()
  });

  $("#search").affix();

  $("#transactions input[type=checkbox]").change(function() {
    $(this).parents("tr").toggleClass("info", $(this).is(":checked"))
  });

  $("#transferize").click(function() {
    var $this = $(this);
    var checked = $("#transactions input[type=checkbox]:checked");

    if(checked.length !== 2) {
      alert("Must select exactly two transactions");
      return false;
    }

    var from_id = $("#transactions tr:has(.negative):has(:input:checked)").attr("data-id");
    var to_id = $("#transactions tr:has(.positive):has(:input:checked)").attr("data-id");

    if(!from_id || !to_id) {
      alert("Select one positive transaction and one negative transaction");
      return false;
    }

    $this.addClass("disabled");

    $.ajax({
      url: $this.attr("href").replace(":from_id", from_id).replace(":to_id", to_id),
      type: "PATCH",
      dataType: "json",
      success: function() {
        window.location.reload();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log(arguments);
        alert("no go :(");
      },
      complete: function() {
        $this.removeClass("disabled");
      }
    })

    return false;
  });
});
