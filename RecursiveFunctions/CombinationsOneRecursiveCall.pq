let fnGetCombinations =
(sourceList as list, combinationSize as number) as list =>
let
    // Base cases
    Count = List.Count(sourceList),
    Result = 
        if combinationSize = 0 then {{}}
        else if combinationSize > Count or combinationSize < 0 then {}
        else if combinationSize = Count then {sourceList}
        
        // Single recursive path
        else
            let
                // Generate indices for the current loop
                MaxIndex = Count - combinationSize,
                Indices = {0 .. MaxIndex},
                
                // One recursive call inside a List.Transform loop
                Combined = List.Transform(Indices, (i) =>
                    let
                        CurrentItem = sourceList{i},
                        RemainingItems = List.Skip(sourceList, i + 1),
                        // The single recursive call
                        SubCombinations = @fnGetCombinations(RemainingItems, combinationSize - 1)
                    in
                        List.Transform(SubCombinations, each List.Combine({{CurrentItem}, _}))
                )
            in
                List.Combine(Combined)
in
    Result
in fnGetCombinations({"A","B","C","D"},2)