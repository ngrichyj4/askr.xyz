var Askr = Askr || {};
Askr.LandingPage = (function() {
  function Init() {
    $("#create-button").click(function() {
      var slug = $("#slug").val();
      window.location = "/" + slug;
    });
  }

  return {
    Init: Init
  }
}());
