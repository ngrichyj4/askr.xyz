var Askr = Askr || {};

Askr.NewPage = (function () {
    function DeleteElementClick(buttonId) {
        // implement this here
        console.log("Deleting element " + buttonId);
    }

    function Init () {
        $( ".deleteButton" ).each(function () {
            $( this ).click(function(e) {
                e.preventDefault();
                DeleteElementClick(this.id);
                return false;
            });
            console.log("Did something with buttons" + this);
        });
    }

    return {
        Init: Init
    }
}());
