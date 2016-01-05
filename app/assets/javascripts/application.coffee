//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require nested_form_fields
//= require_tree .

@clearTicket = (e) ->
        [].forEach.call(e.target.parentNode.querySelectorAll("span.nested_fields[class$=_tickets] input"),
                (i) -> i.parentNode.removeChild(i))
