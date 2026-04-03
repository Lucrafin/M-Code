let
    // Input number that will be converted to binary
    Source = 233,

    // Recursive function f
    // i = the number being converted
    // s = accumulator string that builds the binary result
    f =
        (i as number, s as text) as text =>
            // Base case: when i reaches 0, return the accumulated result
            if i = 0 then
                s
            else
                let
                    // Compute the least significant bit (0 or 1)
                    // and prepend it to the result string
                    l = Text.From(Number.Mod(i, 2)) & s
                in
                    // Recursive call:
                    // Divide i by 2 (integer division)
                    // Carry forward the updated binary string
                    @f(
                        Number.IntegerDivide(i, 2),
                        l
                    )
in
    // Start the recursion with the source number
    // and an empty binary string accumulator
    f(Source, "")