$(function(){
  $.phmItem = function(){
    this.box = $("#item");
  };
  $.extend($.phmItem, {
    prototype: {
      open: function(){
        this.img = $("figure img", this.box);
        var self = this;
        $("#image-thumbs li a, #video-thumbs li a").click(function(){
          self.img[0].src = $("img", this).attr("src");
          return false;
        });
        $("#related a").click(function(){
          
        });
        this.box.show();
      },
      close: function(){
        this.box.hide();
      }
    }
  });
  
  var item = new $.phmItem();
  item.open();
  $("#close a").click(function(){
    item.close();
    return false;
  })
});