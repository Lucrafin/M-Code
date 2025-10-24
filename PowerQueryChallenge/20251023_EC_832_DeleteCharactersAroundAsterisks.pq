let
    Source = Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],       // Load "Table1" from workbook
    R = List.Transform(                                                 // Transform each string in the 'String' column
        Source[String],
        each
            let
                l = Text.ToList(_)                                      // Convert string to list of characters
            in
                Text.Combine(                                           // Rebuild string after transformation
                    List.Accumulate(
                        {l, l & {"a"}}{Byte.From(List.Last(l) = "*")},  // Choose original or extended list based on last char
                        {{}, {}},                                       // Initial state: two empty lists
                        (s, c) =>
                        {
                            {
                                {
                                    s{0} & {c},                        // Append current char
                                    List.RemoveLastN(s{0}, 1)          // Remove last char
                                }{Byte.From(List.Last(s{1}) = "*")},   // Choose based on last char in second list
                                s{0}                                   // Keep current list
                            }{Byte.From(c = "*")},                     // Choose based on current char
                            s{1} & {c} 
                        }                                              // Append to second list
                    ){0}                                               // Return first list
                )
    )
in
    R                                                                  // Return transformed list