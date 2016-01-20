# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gradeTickets = [].map.call(
        JSON.parse(document.querySelector("#grade_ticket").getAttribute("data-grade-ticket")),
        (gt) -> [].map.call(gt["tickets"], (t) -> new Option(t[0], t[1])))

reservationsMain = ->
        gradeSelect = document.querySelector("#grade_id")
        updateGradeTicketsAll(gradeSelect)
        gradeSelect.addEventListener("change", (e) -> updateGradeTicketsAll(e.target))
        $(document).on("fields_added.nested_form_fields", addTicketListener)

updateGradeTicketsAll = (gradeSelect) ->
        [].forEach.call(ticketSelects(), (ticketSelect) ->
                updateGradeTickets(gradeSelect, ticketSelect))

ticketSelects = () -> document.querySelectorAll("fieldset.nested_fields[class$=_tickets] select")

updateGradeTickets = (gradeSelect, ticketSelect) ->
        [].forEach.call(ticketSelect.querySelectorAll("option"), (o) ->
                ticketSelect.removeChild(o))
        [].forEach.call(gradeTickets[gradeSelect.selectedIndex], (o) ->
                ticketSelect.appendChild(o.cloneNode(true)))

addTicketListener = (e) ->
        gradeSelect = document.querySelector("#grade_id")
        selects = ticketSelects()
        lastSelect = selects[selects.length - 1]
        updateGradeTickets(gradeSelect, lastSelect)

window.addEventListener("load", reservationsMain)
