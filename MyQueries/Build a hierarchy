let
    Source = Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],     // Load the source table named "Table1" from the current workbook

    A = List.Transform(                                               // Split each row into a list: {number, name}
        Source[Text],
        each Text.Split(Text.Remove(_, "."), " : ")
    ),

    N = List.Max(                                                     // Determine the maximum hierarchy depth
        List.Transform(A, each Text.Length(_{0}))                     // Based on the length of the number part
    ),

    R = Table.FromRows(                                               // Build the result table by accumulating rows
        List.Accumulate(
            A,
            {{}, {List.Repeat({null}, N)}},                           // Initial state: empty list and one null-filled row
            (s, c) =>
                let
                    f = Byte.From(Text.End(c{0}, 1) = "1"),           // Check if the number ends with "1"
                    i = Text.Length(c{0})                             // Determine the level based on number length
                in {
                    s{0} & {c{0}},                                    // Append number to first accumulator (not used later)

                    List.RemoveLastN(s{1}, f) & {                     // Update second accumulator with new/modified row
                        {
                            List.ReplaceRange(                        // Create new row with name at correct level
                                List.Repeat({null}, N),
                                i - 1,
                                1,
                                {c{1}}
                            ),
                            List.ReplaceRange(                        // Or update last row with name at correct level
                                List.Last(s{1}),
                                i - 1,
                                1,
                                {c{1}}
                            )
                        }{f}                                          // Choose new or updated row based on f
                    }
                }
        ){1},                                                         // Take the second accumulator as final result

        List.Transform({1..N}, each "Level" & Text.From(_))           // Generate column names: Level1, Level2, ..., LevelN
    )
in
    R                                                                 // Return the final table