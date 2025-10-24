let
    Source = Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],     // Load "Table1" from workbook

    R = Table.FromRows(                                               // Build new table from rows
        List.Accumulate(
            Table.ToRows(Source),                                     // Convert table to list of rows
            {},                                                       // Start with empty list
            (s, c) =>
                let
                    l = List.Last(s),                                 // Last row in accumulator
                    i = Byte.From(c{2} = null)                        // 1 if Task is null, else 0
                in
                    List.RemoveLastN(s, i) &                          // Remove last row if Task is null
                    {
                        {
                            {c{0}, c{1}, c{2}, 0},                     // New task row
                            {l{0}, l{1}, l{2}, l{3} + c{1}}            // Add Date to previous Amount
                        }{i}                                          // Pick row based on i
                    }
        ),
        {"Store", "Date", "Task", "Amount"}                           // Column names
    )
in
    R                                                                 // Return final table