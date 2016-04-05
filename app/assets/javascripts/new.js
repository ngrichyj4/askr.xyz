var Askr = Askr || {};

Askr.NewPage = (function () {
    // Delete element function
    function DeleteElementClick(buttonId) {
        $( '#option_row_'+buttonId ).remove();
    }

    var elementCounter = 1;
    // Add option button
    function AddOptionClick() {
        // implement addint option here
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
            .attr("id", "poll_options_attributes_" +elementCounter+"_text")
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
    function ValidateQuestionField()
    {
        $( '#question_error_message' ).hide();
        if ($( '#poll_question' ).val() == '') {
            // poll question text is empty
            //console.log("Missing poll question!");
            $( '#question_error_message' ).show();
            return false;
        }
        return true;
    }

    function ValidateOptionFields()
    {
        $( '#option_error_message' ).hide();

        if ($( 'input[id^="poll_options_attributes_"]' )
                .filter(function() { return $(this).val(); }).length <= 1) {
            // all options are empty
            $( '#option_error_message' ).show();
            return false;
        }
        return true;
    }

    function ValidateQuestionForm() {
        // check question fields
        return ValidateQuestionField()
            && ValidateOptionFields();
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

        $( '#poll_question' ).blur(function () {
            ValidateQuestionField();
        });
    }

    return {
        Init: Init
    }
}());
