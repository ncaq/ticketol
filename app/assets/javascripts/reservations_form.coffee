# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

gradeTicket = [].reduce.call(JSON.parse(document.querySelector("#grade_ticket").getAttribute("data-grade-ticket")),
        (result, gt) -> result[gt["grade_id"]] = [].map.call(gt["tickets"], (t) -> new Option(t[0], t[1])); return result,
        {})

reservationsMain = ->
        g = gradeSelect()
        updateGradeTicketsAll(g)
        g.addEventListener("change", (e) -> updateGradeTicketsAll(e.target))
        $(document).on("fields_added.nested_form_fields", addTicketListener)

updateGradeTicketsAll = (gradeSelect) ->
        [].forEach.call(ticketSelects(), (ticketSelect) ->
                updateGradeTickets(gradeSelect, ticketSelect))

updateGradeTickets = (gradeSelect, ticketSelect) ->
        [].forEach.call(ticketSelect.querySelectorAll("option"), (o) ->
                ticketSelect.removeChild(o))
        [].forEach.call(gradeTicket[gradeSelect.value], (o) ->
                ticketSelect.appendChild(o.cloneNode(true)))

addTicketListener = (e) ->
        g = gradeSelect()
        t = ticketSelects()
        lastSelect = t[t.length - 1]
        updateGradeTickets(g, lastSelect)

gradeSelect = () -> document.querySelector("select[name$='[grade_id]']")
ticketSelects = () -> document.querySelectorAll("fieldset.nested_fields[class$=_tickets] select")

window.addEventListener("load", reservationsMain)
