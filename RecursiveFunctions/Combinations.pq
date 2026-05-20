let
    S = {"A","B","C","D"},
    // Recursive function definition
    f = (l, k) =>
        if k = 0 then 
            {{}} // Base case: one empty combination found
        else if List.Count(l) < k then 
            {}   // Base case: not enough items left
        else
            let
                s = List.Skip(l),
                // Recursive call: items including 'first'
                i = List.Transform( @f(s, k - 1), each {l{0}} & _ ),
                // Recursive call: items excluding 'first'
                e = @f(s, k)
            in
                i & e
in 
    f(S,2)