let
    // Input string to be processed
    S = "tralala",

    // Recursive function f
    // i = current string segment being processed
    f =
        (i as text) as text =>

            // Base case:
            // When the string is empty, return an empty string
            if i = "" then
                ""

            else
                // Recursive case:
                // - Call the function on the string without its first character
                // - Append the first character to the end
                // This effectively reverses the string
                @f(
                    Text.Middle(i, 1)   // substring without the first character
                )
                &
                Text.At(i, 0)         // first character of the current string
in
    // Invoke the function with the source string
    f(S)