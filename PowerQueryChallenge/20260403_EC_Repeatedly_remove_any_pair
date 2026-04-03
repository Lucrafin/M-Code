let
    // Read the Excel table named "Table1" from the current workbook
    // and extract its data as a table
    Source =
        Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],

    // Transform the column [Data] row by row
    R =
        List.Transform(
            Source[Data],

            each
                // Convert the transformed list of characters back into text
                Text.Combine(

                    // Accumulate over each character in the string
                    List.Accumulate(
                        // Convert the current value to text, then to a list of characters
                        Text.ToList(Text.From(_)),

                        // Initial state: empty list
                        {},

                        // Accumulator function
                        (s, c) =>
                            let
                                // i = 1 if the last character in the state equals the current
                                // character, otherwise 0
                                // Byte.From converts true/false to 1/0
                                i =
                                    Byte.From(
                                        List.Last(s, "") = c
                                    )
                            in
                                // If i = 1 (duplicate character):
                                //   remove the last character from the state
                                // If i = 0 (new character):
                                //   keep the state as is
                                { s, List.RemoveLastN(s) }{i}

                                // Then:
                                // If i = 1: add nothing (duplicate removed)
                                // If i = 0: append the current character
                                & { { c }, {} }{i}
                    )
                )
        )
in
    // Output the final transformed list
    R

//-------------------------------
//-------------------------------
// The same code with recursion
//-------------------------------
//-------------------------------

Source =
        Excel.CurrentWorkbook(){[Name = "Table1"]}[Content],

f = (input as any) as text =>
    let
        // Convert input to text and then to a list of characters
        chars =
            Text.ToList(Text.From(input)),

        // Recursive helper function
        // remaining : characters left to process
        // stack     : list acting as a stack of kept characters
        Recurse =
            (remaining as list, stack as list) as list =>
                if List.IsEmpty(remaining) then
                    // Base case: return final stack
                    stack
                else
                    let
                        current = remaining{0},
                        top     = if List.IsEmpty(stack) then null else List.Last(stack),

                        newStack =
                            if current = top then
                                // Duplicate found → remove BOTH characters
                                List.RemoveLastN(stack, 1)
                            else
                                // No duplicate → push character onto stack
                                stack & { current }
                    in
                        @Recurse(
                            List.Skip(remaining, 1),
                            newStack
                        ),

        // Combine final stack into text
        output =
            Text.Combine(
                Recurse(chars, {})
            )
    in
        output
R = Table.AddColumn(
    Source,
    "Answer Expected",
    each f([Data]),
    type text
)
in R
