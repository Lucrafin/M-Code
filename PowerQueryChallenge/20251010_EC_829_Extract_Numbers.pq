let
    Source = Excel.CurrentWorkbook(){[Name="Table1"]}[Content],                     // Load the table named "Table1" from the current workbook
    R = List.Transform(                                                             
        Source[Strings],                                                            // For each value in the "Strings" column
        each List.Sum(                                                              // Sum the resulting numbers
            List.Transform(
                List.Split(                                                         
                    List.Transform(
                        List.Select(
                            List.Accumulate(
                                Text.ToList(_), {},                                  // Convert string to list of characters
                                (s, c) =>
                                    let
                                        l = List.Last(s, {}),                        // Last element in the list (or empty)
                                        i = List.Contains({"0".."9"}, c),            // Is current char a digit?
                                        j = List.Contains({"A".."z"}, List.Last(l)), // Is last char a letter?
                                        f = Byte.From(i <> j)                        // Flag if type changed (digit <-> letter)
                                    in
                                        List.RemoveLastN(s, f) &                     // Remove last if type changed
                                        {
                                            {
                                                {},
                                                {
                                                    {},
                                                    l
                                                }{f} & {c}                           // Append current char to group
                                            }{Byte.From(i)}                          // Choose group based on type
                                        }
                            ),
                            each _ <> {}                                             // Remove empty groups
                        ),
                        each Text.Combine(_)                                         // Combine characters into strings
                    ),
                    2                                                                // Split into pairs
                ),
                each Number.From(_)                                                  // Convert each string to number
            )
        )
    )
in
    R                                                                                // Return the final list of sums