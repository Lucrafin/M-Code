let IBUB = ( optional CheckFileName as logical ) as table =>

    let

        FolderPathStart = "\\office\aktiehandel\BackOffice Värdepapper Ekonomi\Filer\",
        FolderPath = FolderPathStart & FolderPathEnd,

        // Extract file path from metadata after applying filter to the 'Name' column
        // and take first row of table sorted by 'Date modified' column
        FilePath =
            Table.CombineColumns(
                Table.FirstN(
                    Table.Sort(
                        Table.SelectRows( 
                            Folder.Files( FolderPathStart & FolderPathEnd ), 
                            each if CheckFileName = true ?? false then Text.Contains( Text.Lower( [Name] ), "ib-ub" ) else true
                        ),
                        { "Date modified", Order.Descending }
                    ),
                    1
                ),
                { "Folder Path", "Name" },
                Combiner.CombineTextByDelimiter("", QuoteStyle.None),
                "File Path"
            ){0}[File Path],
        
        Source = 
            Excel.Workbook(
                File.Contents(FilePath), null, true
            ){0}[Data],

        FilterOutTotal = 
            Table.SelectRows( 
                Source, 
                each not Text.Contains( Text.Lower( [Column1] ), "total" ) and [Column2] <> "" 
                ),

        AddedEndBalance = 
            Table.AddColumn(
                FilterOutTotal, 
                "Ending Balance", 
                each if Value.Is( [Column15], type text ) and [Column15] <> ""
                        then Text.Start( [Column15], Text.Length( [Column15] ) - 11 )
                        else [Column15]
            ),
            
            // Extract date from column 15 and write it to all rows except header
        AddedDate = 
            Table.AddColumn(
                AddedEndBalance, 
                "Date", 
                each if Value.Is( [Column15], type text ) 
                    then "Date"
                    else Text.End( 
                            Text.Combine( 
                                List.Select( 
                                    Table.Column( 
                                        AddedEndBalance, "Column15" 
                                    ), 
                                    each Value.Is( _ , type text ) and _ <> "" 
                                ) 
                            ),  
                            10 
                        )
            ),

        SelectColumns = 
            Table.SelectColumns(
                Table.PromoteHeaders( 
                    AddedDate, 
                    [PromoteAllScalars=true] 
                ),
                {"Ledger Account Number", "Product Level 5", "Ending Balance", "Date" }
            ),
            
        ChangedType = 
            Table.TransformColumnTypes(
                SelectColumns,
                {
                    {"Ledger Account Number", Int64.Type}, 
                    {"Product Level 5", Int64.Type}, 
                    {"Ending Balance", type number}, 
                    {"Date", type date}
                }
            )
    in
        ChangedType,

        documentation = [
            Documentation.Name =             " fxKontoutdrag ",
            Documentation.Description =      " Work with Workday files and transform them into the appropriate format for later use. ",
            Documentation.LongDescription =  " The function extracts the file from this path '\\office\aktiehandel\BackOffice Värdepapper Ekonomi\Files\' along with FolderPathEnd. You must enter the valid FolderPathEnd parametar for the file you want to transform. CheckFileName is optional and has to be 'true' if you want to search after the word 'ib-ub' in the file name. ",
            Documentation.Category =         " Workday ",
            Documentation.Source =           " GitHub Lucrafin ",
            Documentation.Version =          " 1.0 ",
            Documentation.Author =           " Aleksandar Kovacevic "
        ]
in 
    Value.ReplaceType(IBUB, Value.ReplaceMetadata(Value.Type(IBUB), documentation) )
