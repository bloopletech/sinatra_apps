$(function()
{
  $("#fight").live('submit', function(event)
  {
    event.preventDefault();
    $("#replaceable").html("<img src='/loading.gif'>");
    $('#replaceable').load('/fight', $(this).serialize());
  });

  $("#new_fight").live('click', function(event)
  {
    event.preventDefault();
    $("#replaceable").html("<img src='/loading.gif'>");
    $('#replaceable').load('/form');
  });
});