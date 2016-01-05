# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

reservationsMain = ->
        setGradeTicketsEvent

setGradeTicketsEvent = ->
        gradeSelect = document.querySelector("#grade_id")
        updateGradeTicketsAll(gradeSelect)
        gradeSelect.addEventListener("change", (e) -> updateGradeTicketsAll(e.target))
        $(document).on "fields_added.nested_form_fields", addTicketListener

updateGradeTicketsAll = (gradeSelect) ->
        ticketSelects = document.querySelectorAll(".nested_reservation_tickets select")
        [].forEach.call(ticketSelects, (ticketSelect) -> updateGradeTickets(gradeSelect, ticketSelect))

updateGradeTickets = (gradeSelect, ticketSelect) ->
        [].forEach.call(ticketSelect.querySelectorAll("option"), (o) -> ticketSelect.removeChild(o))
        [].forEach.call(gradeTickets[gradeSelect.selectedIndex], (o) -> ticketSelect.appendChild(o.cloneNode(true)))

addTicketListener = (e) ->
        gradeSelect = document.querySelector("#grade_id")
        selects = document.querySelectorAll(".nested_reservation_tickets select")
        lastSelect = selects[selects.length - 1]
        console.log(lastSelect)
        updateGradeTickets(gradeSelect, lastSelect)

window.addEventListener("load", reservationsMain)
