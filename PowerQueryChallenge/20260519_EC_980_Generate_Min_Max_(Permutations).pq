let
    // Load table from Excel
    Source =
        Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],

    // Recursive function to generate all permutations of a list
    f =
        (l) =>
            let
                // Count number of elements in the list
                c = List.Count(l)
            in
                // Base case: if list has 0 or 1 element,
                // there is only one permutation → the list itself
                if c <= 1 then
                    { l }

                // Recursive case: build permutations
                else
                    List.Combine(

                        // Loop over each index in the list
                        List.Transform(
                            {0 .. c - 1},
                            (i) =>

                                // For each position i:
                                // 1) Remove element at index i
                                // 2) Recursively permute the remaining list
                                // 3) Prepend the removed element to each permutation
                                List.Transform(
                                    @f(List.RemoveRange(l, i, 1)),

                                    // Add current element in front of each smaller permutation
                                    each { l{i} } & _
                                )
                        )
                    ),

    // Transform each row of the table
    A =
        List.Transform(
            Table.ToRows(Source),

            each
                List.Transform(

                    // Remove null values from row
                    List.Select(_, (i) => i <> null),

                    (j) =>
                        let
                            // Convert value to text
                            t = Text.From(j)
                        in
                            // Conditional transformation:
                            // If value starts with "0.", remove leading "0"
                            // Otherwise keep full string
                            { t, Text.Middle(t, 1) }{
                                Byte.From(Text.StartsWith(t, "0."))
                            }
                )
        ),

    // Generate result table
    R =
        Table.FromRows(
            List.Transform(
                A,
                each
                    let
                        // Generate all permutations of the processed row
                        l =
                            List.Transform(
                                f(_),

                                // Convert each permutation (list of strings)
                                // → concatenate into one string
                                // → convert to number
                                (i) =>
                                    Number.From(
                                        Text.Combine(i)
                                    )
                            )
                    in
                        // For each row compute:
                        // max possible number and min possible number
                        {
                            List.Max(l),
                            List.Min(l)
                        }
            ),

            // Output column names
            { "MAX", "MIN" }
        )
in
    R