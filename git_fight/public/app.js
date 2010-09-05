$(function()
{
  $("#fight").live('submit', function(event)
  {
    event.preventDefault();
    $("#replaceable").html("<img src='/loading.gif'><br>May take up to 30 seconds");
    $('#replaceable').load('/fight', $(this).serialize());
  });

  $("#new_fight").live('click', function(event)
  {
    event.preventDefault();
    $("#replaceable").html('');
    $("#user_1").focus();
  });
});