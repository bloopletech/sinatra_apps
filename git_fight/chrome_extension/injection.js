if($("body").hasClass("page-profile"))
{
  $("body").append('<script>\
  function gitfight_process_user(user)\
  {\
    $(".vcard").append("<dl><dt>GitFight score</dt><dd>" + user["score"] + "</dd></dl>");\
  };\
  </script>\
  <script src="http://gitfight.bloople.net/user/' + location.href.match(/\/([^\/]+)\/?$/)[1] + 
   '?callback=gitfight_process_user&commas=true"></script>');
}