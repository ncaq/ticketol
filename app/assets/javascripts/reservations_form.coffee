# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gradeTickets = [].map.call(
        document.querySelector("#grade_ticket_tree").getAttribute("data-grade-ticket-tree"),
        (gtt) -> [].map.call(gtt, (t) -> new Option(t[0], t[1])))

reservationsMain = ->
        gradeSelect = document.querySelector("#grade_id")
        updateGradeTicketsAll(gradeSelect)
        gradeSelect.addEventListener("change", (e) -> updateGradeTicketsAll(e.target))
        $(document).on("fields_added.nested_form_fields", e => console.log(e))

updateGradeTicketsAll = (gradeSelect) ->
        ticketSelects = document.querySelectorAll(".nested_reservation_tickets select")
        [].forEach.call(ticketSelects, (ticketSelect) ->
                updateGradeTickets(gradeSelect, ticketSelect))

updateGradeTickets = (gradeSelect, ticketSelect) ->
        [].forEach.call(ticketSelect.querySelectorAll("option"), (o) ->
                ticketSelect.removeChild(o))
        [].forEach.call(gradeTickets[gradeSelect.selectedIndex], (o) ->
                ticketSelect.appendChild(o.cloneNode(true)))

addTicketListener = (e) ->
        gradeSelect = document.querySelector("#grade_id")
        selects = document.querySelectorAll(".nested_reservation_tickets select")
        lastSelect = selects[selects.length - 1]
        updateGradeTickets(gradeSelect, lastSelect)

window.addEventListener("load", reservationsMain)
