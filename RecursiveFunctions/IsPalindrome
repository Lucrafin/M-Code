let
    // Input text to check for palindrome
    Source = "abcba",

    // Recursive function f
    // i = current text being evaluated
    f =
        (i as text) as logical =>
            
            // Base case:
            // A string of length 0 or 1 is always a palindrome
            if Text.Length(i) = 0 or Text.Length(i) = 1 then
                true

            // Recursive case:
            // Compare first and last characters
            else if Text.Start(i, 1) = Text.End(i, 1) then
                
                // Characters match:
                // Remove first and last character
                // and recurse on the remaining middle portion
                @f(
                    Text.Middle(
                        i,                      // original string
                        1,                      // start at index 1 (second character)
                        Text.Length(i) - 2      // exclude first and last characters
                    )
                )

            // Mismatch case:
            // If first and last characters differ,
            // the string is not a palindrome
            else
                false
in
    // Invoke the function with the source input
    f(Source)