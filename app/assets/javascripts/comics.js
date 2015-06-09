$(document).ready(function () {
  $('a.load-more').click(function (e) {
    e.preventDefault();

    $('.load-more').hide();

    var last_id = $('.abstract').last().attr('data-id');

    $.ajax({
      type: "GET",
      url: $(this).attr('href'),
      data: {
        id: last_id
      },
      dataType: "script",

      success: function () {
        $('.load-more').show();
      }
    });
  });
});