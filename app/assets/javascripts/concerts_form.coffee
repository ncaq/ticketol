@clearTicket = (e) ->
        [].forEach.call(e.target.parentNode.querySelectorAll("span.nested_fields[class$=_tickets] input"),
                (i) -> i.parentNode.removeChild(i))

@importGradeTicket = (e) ->
        root = e.target.parentNode.parentNode
        file = e.target.files[0]
        reader = new FileReader()
        reader.onload = (l) -> importGradeTicketListener(root, l)
        reader.readAsText(file)

importGradeTicketListener = (root, loadFile) ->
        csv = loadFile.target.result
        lines = csv.match(/[^\n]+/g)
        removeGrades(root)
        addGradeButton = root.querySelector("a[data-object-class=grade]")
        addGradeButton.click() for [1..lines.length]
        gradeSets = root.querySelectorAll("fieldset.nested_fields[class$=_grades]")
        lines.forEach((line, index) ->
                cols = line.split(/,\s*/)
                grade = cols[0]
                price = cols[1]
                seats = cols.slice(2)
                addTicketButton = root.querySelectorAll("a[data-object-class=ticket]")[index]
                addTicketButton.click() for [1..seats.length]
                gradeSet = gradeSets[index]
                inputs = gradeSet.querySelectorAll("input")
                inputs[0].value = grade
                inputs[1].value = price
                [].slice.call(inputs, 2).forEach((input, inputIndex) -> input.value = seats[inputIndex]))

removeGrades = (root) ->
        [].forEach.call(root.querySelectorAll("fieldset.nested_fields[class$=_grades]"), (f) ->
                f.parentNode.removeChild(f))
