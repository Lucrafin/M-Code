let
    // Read the Excel table named "Table1" from the current workbook
    // and return its contents as a table
    Source =
        Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],

    // Transform each value in the [Input] column
    R =
        List.Transform(
            Source[Input],

            each
                let
                    // Split the input text by commas
                    // Convert each resulting value to a number
                    l =
                        List.Transform(
                            Text.Split(_, ","),
                            Number.From
                        )
                in
                    // Repeatedly reduce the list using successive absolute differences
                    // until all values are identical
                    //
                    // {0 .. List.Count(l) - 2} simply controls
                    // how many reduction steps are executed
                    List.Accumulate(
                        {0 .. List.Count(l) - 2},

                        // Initial state is the original numeric list
                        l,

                        // Accumulator function
                        (s, c) =>
                            // Build a new list consisting of:
                            {
                                // 1. A list of absolute differences between
                                //    adjacent elements in the current list 's'
                                List.Transform(
                                    {0 .. List.Count(s) - 2},
                                    (i) => Number.Abs(s{i} - s{i + 1})
                                ),

                                // 2. A list holding the first element of 's'
                                //    (this preserves length alignment)
                                { s{0} }
                            }
                            // Select either element 0 or 1 from the structure above
                            // depending on whether all values in 's' are equal
                            {
                                // Byte.From returns:
                                // 1 if List.Min(s) = List.Max(s)
                                // 0 otherwise
                                Byte.From(List.Min(s) = List.Max(s))
                            }
                    )
                    // Extract the resulting list from the accumulator result
                    {0}
        )
in
    // Return the final transformed list
    R

//-------------------------------
//-------------------------------
// The same code with recursion
//-------------------------------
//-------------------------------

let 
    Source = Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],
    f = (l) => 
        let 
            
            // Base case:
            // If all values are equal (or list has 0–1 elements),
            // return the list as-is
            A = List.Min(l) = List.Max(l), 
            
            // Recursive step:
            // 1. Compute absolute differences of adjacent elements
            // 2. Call the function again with the reduced list
            B = if A then l else @f( List.Transform( {0 .. List.Count(l) - 2}, (i) => Number.Abs(l{i} - l{i + 1} ) ) ) 
        in 
            B,
    R = List.Transform( Source[Input], each f( List.Transform( Text.Split(_, ","), Number.From ) ){0} )
in
    R
