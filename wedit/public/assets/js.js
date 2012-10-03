$(function() {
  function get_key_local(key) {
    return localStorage.getItem(key);
  }

  function set_key_local(key, value) {
    localStorage.setItem(key, value);
  }

  function get_key_remote(key, callback) {
    $.ajax({
      url: "/s/" + encodeURIComponent(key),
      failure: function() {
        $("#sync-status").html("Sync Failed <i class='icon-warning-sign'></i>");
      },
      success: callback
    });
  }

  function set_key_remote(key, value, callback) {
    $.ajax({
      url: "/s/" + encodeURIComponent(key),
      data: value,
      type: "PUT",
      failure: function() {
        $("#sync-status").html("Sync Failed <i class='icon-warning-sign'></i>");
      },
      success: callback
    });
  }

  function generate_key() {
    var out = "";
    var rand_chars = "ABCDEFGHIJKMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789";
    for(var i = 0; i < 7; i++) out += rand_chars.charAt(Math.floor(Math.random() * rand_chars.length + 1) - 1);
    return out;
  }

  function document_id() {
    return "document-" + $("#key").val();
  }

  var document_last_text = null;
  var currently_saving = false;

  function sync() {
    if($("#key").val() == "") return;

    if($("#editor").val() == document_last_text) load_document_online();
    else save_document_online();
  }

  function edit_document(text) {
    $("#editor").val(text).focus().caretToEnd().scrollTop(214748364);
    set_key_local(document_id(), text);
    document_last_text = text;
  }

  function load_document_locally() {
    var text = get_key_local(document_id());
    if(text == null) {
      load_document_online();
    }
    else {
      edit_document(text);
      $("#sync-status").html("Loaded <i class='icon-ok-sign'></i>");
    }
  }

  function load_document_online() {
    var text = get_key_local(document_id()) || "";

    get_key_remote(document_id() + "-last-modified", function(text) {
      var llm = parseFloat(get_key_local(document_id() + "-last-modified")); 
      if(isNaN(llm) || (llm > parseFloat(text))) {
        get_key_remote(document_id(), function(text) {
          edit_document(text);
        });
      }
      $("#sync-status").html("Loaded <i class='icon-ok-sign'></i>");
    });
  }

  function finish_edit_document() {
    var text = $("#editor").val();
    set_key_local(document_id(), text);
    set_key_local(document_id() + "-last-modified", (new Date().getTime()));
  }

  function save_document_locally() {
    if($("#editor").val() == document_last_text) return;
    finish_edit_document();
  }

  window.setInterval(save_document_locally, 5000);

  function save_document_online() {
    currently_saving = true;
    save_document_locally();
    var text = $("#editor").val();
    if(text == document_last_text) return;

    $("#sync-status").html("Syncing... <i class='icon-time'></i>");
    set_key_remote(document_id(), text, function(text) {
      set_key_remote(document_id() + "-last-modified", get_key_local(document_id() + "-last-modified"), function(text) {
        $("#sync-status").html("Saved <i class='icon-ok-sign'></i>");
        document_last_text = text;
        currently_saving = false;
      });
    });
  }

  function export_document() {
    location.href = "/api.php?action=export&key=" + encodeURIComponent($("#key").val());
  }

  $(document).keydown(function(e) {
    if(!(String.fromCharCode(e.which).toLowerCase() == 's' && e.ctrlKey) && !(e.which == 19)) return;
    sync();
    e.preventDefault();
  });

  function check_save_document() {
    if(!currently_saving && $("#editor").val() != document_last_text) $("#sync-status").html("Editing <i class='icon-edit'></i>");
  }

  window.setInterval(check_save_document, 1000);

  window.onbeforeunload = function() {
    return ($("#editor").val() != document_last_text) ? "Your document is unsaved, please save it before leaving this page." : null;
  };

  function statistics() {
    var s = $("#editor").val();
    var wc = !s ? 0 : (s.split(/^\s+$/).length === 2 ? 0 : 2 + s.split(/\s+/).length - s.split(/^\s+/).length - s.split(/\s+$/).length);
    $("#statistics").text(($.digits(wc) + (wc == 1 ? " word" : " words")) + " / " + $.format_bytes($.bytesize(s)));
  }

  window.setInterval(statistics, 1000);
  statistics();

  $(window).resize(function() {
    $("#editor").css("height", $(window).height() - 28);
  }).resize();

  $("#key").change(function() {
    var key = $("#key").val();
    if(key.length < 7) {
      alert("Please enter a key of at least 7 characters (letters and numbers); please make it hard to guess.\n" +
       "Your document key is like a password; with this, anyone can access and edit your document.");
      return;
    }
    set_key_local("key", key);
    load_document_locally();
  });

  $("#key-new").click(function(e) {
    $("#key").val(generate_key()).change();
    e.preventDefault();
  });

  $("#sync").click(function(e) {
    sync();
    e.preventDefault();
  });

  $("#key-export").click(function(e) {
    export_document();
    e.preventDefault();
  });

  $("#key").val(get_key_local("key") || generate_key()).change();
});
