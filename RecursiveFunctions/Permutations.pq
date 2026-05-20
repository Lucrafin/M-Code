let 
    S = {"A","B","C"},
    f = (items as list) =>
        List.Accumulate(
            {1 .. List.Count(items)},
            {{}},
            (b, n) =>
                List.TransformMany(
                    b,
                    each List.RemoveItems(items, _),
                    (i, _) => i & {_}
                )
        ),
    r = (l) => 
        let 
            c = List.Count(l) 
        in 
            if c <= 1 then {l} else 
                List.TransformMany( {0..c-1}, 
                    each @f( List.RemoveRange( l, _ ) ), 
                    (x, y) => {l{x}} & y 
                )
in 
    Table.FromRows( r(S) )