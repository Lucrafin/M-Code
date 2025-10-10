let fxSplitText = ( ListToTransform as list, FirstListOfCharacters as list, SecundListOfCharacters as list ) =>
    let
      R = List.Transform(
          ListToTransform,
          each List.Transform(
              List.Accumulate(
                  Text.ToList(Text.From(_)),
                  {},
                  (s, c) =>
                      let
                          l = List.Last(s, {}),
                          i = List.Contains(FirstListOfCharacters, c),
                          j = List.Contains(SecundListOfCharacters, List.Last(l)),
                          f = Byte.From(i <> j)
                      in
                          List.RemoveLastN(s, f) & {{{}, l}{f} & {c}}
              ),
              Text.Combine
          )
      )
    in 
        R
in
    fxSplitText
