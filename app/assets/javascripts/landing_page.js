var Askr = Askr || {};
Askr.LandingPage = (function() {
  function Init() {
    $("#create-button").click(function() {
      var slug = $("#slug").val();
      window.location = "/" + slug;
    });

    $("#slug-check").click(function() {
      var slug = $("#slug").val();
      slug = encodeURIComponent(slug);
      console.log(slug);
      $("#slug-is-available").load("/api/1/slug_is_available/?slug=" + slug);
      $("#slug-is-valid").load("/api/1/slug_is_valid/?slug=" + slug);
    });
  }

  return {
    Init: Init
  }
}());
