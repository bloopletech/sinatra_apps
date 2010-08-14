function loading()
{
  $("#replaceable").html("<img src='/loading.gif'><br>May take up to 10 seconds");
}

$(function()
{
  $("#fight").live('submit', function(event)
  {
    event.preventDefault();
    loading();
    $('#replaceable').load('/fight', $(this).serialize());
  });

  $("#new_fight").live('click', function(event)
  {
    event.preventDefault();
    loading();
    $('#replaceable').load('/form');
  });
});