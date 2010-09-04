require 'open-uri'

module RSS
end


class RSS::RSS < Sinatra::Base
  get '/' do
    return failed("Invalid URL") unless params[:url] =~ /^http:/
    
    response.headers['Content-Type'] = "text/html; charset=utf-8"
    
    xml = Nokogiri::XML.parse(open(params[:url]).read)
    puts xml.inspect
    #<script id="feed-1282223889365929" type="text/javascript" src="http://rss.bloople.net/?url=URL&detail=25&limit=10&showicon=true&striphtml=true&type=js&id=1282223889365929"></script>
   
   url = params[:url]
   detail = params[:detail] ? params[:detail].to_i : 2147483647
   limit = params[:limit] ? params[:limit].to_i : 2147483647
   striphtml = params[:striphtml] && params[:striphtml] == "true"
   showtitle = params[:showtitle] ? (params[:showtitle] == "true") : true
   showtitledesc = params[:showtitledesc] && params[:showtitledesc] == "true"
   titleprefix = (params[:titleprefix]) ? params[:titleprefix] : ""
   #titlereplacement = (params[:titlereplacement]) ? params[:titlereplacement] : ""
   #titledescprefix = (params[:titledescprefix]) ? params[:titledescprefix] : ""
   #itemtitleprefix = (params[:itemtitleprefix]) ? params[:itemtitleprefix] : ""
   itemdescprefix = (params[:itemdescprefix]) ? params[:itemdescprefix] : ""
   showicon = (params[:showicon]) ? (params[:showicon] == "true") : false
   showempty = (params[:showempty]) ? (params[:showempty] == "true") : false
   type = (params[:type]) ? params[:type] : "php"
   id = (params[:id]) ? ereg_replace("[^0-9]*", "", params[:id]) : ""
   fixbugs = (params[:fixbugs]) ? (params[:fixbugs] == "true") : false
   forceutf8 = (_GET["forceutf8"]) ? (_GET["forceutf8"] == "true") : false
   cache = !(params[:nocache]) ? (params[:nocache] == "true") : false

    
    if show_title
      @feed_title = ...
      @feed_link
      @feed_description
      @feed_image
      
    
   if($showtitle == true)
   {
      $channel = $doc->get_elements_by_tagname("channel");
      $channel = $channel[0];
   
      $title = $channel->get_elements_by_tagname("title");
      $title = eschtml((count($title) > 0 ? $titleprefix.$title[0]->get_content() : "(No feed title)"));
      if($titlereplacement) $title = $titlereplacement;
      if($striphtml) $title = remtags($title);


      $link = $channel->get_elements_by_tagname("link");
      $link = (count($link) > 0 ? ($eschtml ? eschtml($link[0]->get_content()) : $link[0]->get_content()) : "");
      if($link != "") $title = "<a href=\"$link\">$title</a>";
      if($striphtml) $link = remtags($link);

   
      $desc = $channel->get_elements_by_tagname("description");
      $desc = eschtml(count($desc) > 0 ? $desc[0]->get_content() : "");
      if($striphtml) $desc = remtags($desc);

   
      $image = $channel->get_elements_by_tagname("image");
      if(count($image) > 0)
      {
         $image = $image[0];
         $image = $image ->get_elements_by_tagname("url");
         $image = (count($image) > 0 ? $image[0]->get_content() : "");
      }


      if($showicon && $image != "") $title = "<img class=\"feed-title-image\" src=\"$image\" />$title";
   
      if($showempty || (!$showempty && $title != "")) echo "<h3 class=\"feed-title\">$title</h3>\n";
      if($showtitledesc && ($showempty || (!$showempty && $desc != ""))) echo "<p class=\"feed-desc\">$titledescprefix$desc</p>\n";
   }
   
      
    
  end

  def failed(reason)
    puts "FAILED: #{reason}"
  end
end