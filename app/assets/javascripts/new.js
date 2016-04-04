var Askr = Askr || {};

Askr.NewPage = (function () {
    // Delete element function
    function DeleteElementClick(buttonId) {
        $( '#option_row_'+buttonId ).remove();
        console.log("Deleting element " + buttonId);
    }

    var elementCounter = 10;
    // Add option button
    function AddOptionClick() {
        // implement addint option here
        console.log("Adding "+ elementCounter + "th option.");
        $( '#add_option_li' ).before(
            "<li id='option_row_" + elementCounter + "'></li>"
        );
        $( '<span></span>')
            .attr("id", "option_span_"+elementCounter)
            .attr("class", "input-group")
            .appendTo($( '#option_row_'+elementCounter ));

        $( '<input type="text"></input>')
            .attr("name", "poll[options_attributes][" + elementCounter + "][text]")
            .attr("class", "form-control")
            .appendTo($( '#option_span_'+elementCounter ));

        $( '<span type="text"></span>')
            .attr("name", "poll[option_attributes][" + elementCounter + "][text]")
            .attr("id", "option_button_span_"+elementCounter)
            .attr("class", "input-group-btn")
            .appendTo($( '#option_span_'+elementCounter ));

        $( '<button id="' + elementCounter + '" class ="btn btn-danger deleteButton">' +
                '<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>' +
            '</button>').appendTo( '#option_button_span_'+elementCounter );

        InitDeletes();

        elementCounter ++;
    }

    // validate form input
    function ValidateQuestionForm() {
        // implement form validation
        console.log("Validating input");
        //if ($( '#poll_question' ).text() == '') {
        //    poll question text is empty
        //    console.log("Missing poll question!");
        //    return false;
        //}
        return true;
    }

    function InitDeletes() {
        // delete option function binding
        $( ".deleteButton" ).each(function () {
            $( this ).click(function(e) {
                e.preventDefault();
                DeleteElementClick(this.id);
                return false;
            });
        });
    }
    function Init () {
        InitDeletes();

        // add option function binding
        $( "#addOptionBtn" ).click(function(e) {
            e.preventDefault();
            AddOptionClick();
            return false;
        });

        // submit form validation function binding
        $( 'input[name=commit]' ).click(function(e){
            if (!ValidateQuestionForm()) {
                e.preventDefault();
                return false;
            }
        });

    }

    return {
        Init: Init
    }
}());
