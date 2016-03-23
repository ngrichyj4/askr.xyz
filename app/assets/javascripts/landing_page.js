var Askr = Askr || {};
Askr.LandingPage = (function() {
  function Init() {
    $("#start-poll").on('submit', function(e) {
      var slug = $("#slug").val();
      window.location = "/" + slug;
      e.preventDefault();
      return false;
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
