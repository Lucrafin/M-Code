let Kontoutdrag = ( optional CheckFileName as logical ) as table =>

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
                            each if CheckFileName = true ?? false then Text.Contains( Text.Lower( [Name] ), "kontoutdrag" ) else true
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
            Table.PromoteHeaders( 
                Excel.Workbook(
                    File.Contents(FilePath), null, true
                ){0}[Data],
                [PromoteAllScalars=true] 
            ),

        FilterOutTotal = 
            Table.SelectRows( 
                Table.FillDown( Source, { "Ledger Account" } ),
                each not Text.Contains( Text.Lower( [Ledger Account] ), "total" ) and [Accounting Date] <> null
            ),
            
        SplitLA = 
            Table.SplitColumn(
                FilterOutTotal, 
                "Ledger Account", 
                Splitter.SplitTextByDelimiter(":", QuoteStyle.Csv), 
                {"Account Number", "Account Name"}
            ),

        SelectColumns = 
            Table.SelectColumns(
                SplitLA,
                {"Account Number",  "Accounting Date",   "Journal Source", "Translated Amount",   "Product Level 5"}),
                
        ChangedType = 
            Table.TransformColumnTypes(
                SelectColumns,
                {
                    {"Account Number", Int64.Type}, 
                    {"Accounting Date", type date}, 
                    {"Journal Source", type text}, 
                    {"Translated Amount", type number}, 
                    {"Product Level 5", Int64.Type}
                }
            )
    
    in
        ChangedType,

        documentation = [
            Documentation.Name =  " fxKontoutdrag ",
            Documentation.Description = " Work with Workday files and transform them into the appropriate format for later use. ",
            Documentation.LongDescription = " The function extracts the file from this path '\\office\aktiehandel\BackOffice Värdepapper Ekonomi\Files\' along with FolderPathEnd. You must enter the valid FolderPathEnd parametar for the file you want to transform. CheckFileName is optional and has to be 'true' if you want to search after the word 'kontoutdrag' in the file name. ",
            Documentation.Category = " Workday ",
            Documentation.Source = " GitHub Lucrafin ",
            Documentation.Version = " 1.0 ",
            Documentation.Author = " Aleksandar Kovacevic "
        ]
in 
    Value.ReplaceType(Kontoutdrag, Value.ReplaceMetadata(Value.Type(Kontoutdrag), documentation) )
