let KoncFileLeafLevel = ( FilePath as text ) as table =>

    let

        FolderPathKoncFile = Folder.Files( "\\office\ekonomi\Filer\Konc\Konc_WD" ),

        // Extract file path from metadata after applying filter to the 'Name' column
        // and take first row of table sorted by 'Date modified' column
        FilePathKoncFile =
            Table.CombineColumns(
                Table.FirstN(
                    Table.Sort(
                        Table.SelectRows( 
                            FolderPathKoncFile, 
                            each  Text.Contains( Text.Lower( [Name] ), "konc" )
                        ),
                        { "Date modified", Order.Descending }
                    ),
                    1
                ),
                { "Folder Path", "Name" },
                Combiner.CombineTextByDelimiter("", QuoteStyle.None),
                "File Path"
            ){0}[File Path],

        ExcelKoncFile = Excel.Workbook( File.Contents(FilePathKoncFile), null, true ),

        Source = Table.SelectColumns( Table.SelectRows( ExcelKoncFile, each Text.Contains( Text.Lower( [Name] ), "rr" ) ), { "Name", "Data" } ),
        Source2 = Table.SelectColumns( Table.SelectRows( ExcelKoncFile, each List.Contains( { "br", "rr" },  Text.Lower( Text.Start( [Name], 2 ) ) ) ), { "Name", "Data" } ),

        AddHeader =   // Extract the first 2 columns and 6 first rows as file header
            Table.AddColumn( 
                Source2, 
                "Header", 
                each 
                Table.TransformColumns(
                    Table.PromoteHeaders(
                        Table.FromColumns(
                            List.FirstN( 
                                List.Skip( List.Zip( { [Data][Column1], [Data][Column2] } ) ), 
                                6
                            )
                        )
                    ),
                    { "Period", each Date.EndOfMonth( Date.FromText( Text.Combine( { Text.End( _, 3 ), Text.Start( _, 4 ) }, "-" ) ) ) }
                )
            ),

        AddBody =
                Table.AddColumn(
                    AddHeader,
                    "Body",
                        each
                            let
                                // Transform three-level nested header to one-line header
                                BaseHeader = 
                                        Table.TransformColumns(
                                            Table.CombineColumns(
                                                Table.FillDown( 
                                                    Table.FromColumns( 
                                                        List.Zip( 
                                                            Table.ToColumns( 
                                                                Table.FirstN( Table.SelectRows( [Data], each [Column5] <> null ), 3 ) 
                                                            ) 
                                                        ) 
                                                    ),
                                                    { "Column1" }
                                                ),
                                                { "Column1", "Column2", "Column3" },
                                                Combiner.CombineTextByDelimiter("|", QuoteStyle.None),
                                                "DataHeader"
                                            ),
                                            { "DataHeader", each if Text.Start( _, 2 ) = "||" then Text.RemoveRange( _, 0, 2 ) else _ }
                                        )[DataHeader],
                                        
                                NewColumnNames = List.Transform( List.InsertRange( List.Skip( BaseHeader ), 0, { "Account Name" } ), each Text.Remove( _, "/" ) ),

                                BaseTable = Table.RemoveFirstN( Table.SelectRows( [Data], each [Column5] <> null ), 3 ),

                                CombineColumnNames = List.Zip( { Table.ColumnNames( BaseTable ), NewColumnNames } ),

                                BodyTable = 
                                    Table.FromRecords(
                                        Table.TransformRows(
                                            Table.SelectRows( 
                                                Table.RenameColumns( BaseTable, CombineColumnNames ), 
                                                each 
                                                    Value.Is( try Number.From( Text.Start( [Account Name], 2 ) ) otherwise null, type number ) or 
                                                    List.Contains( { "MU", "IS", "VP" }, Text.Start( [Account Name], 2 ) )
                                            ),
                                            ( r ) => Record.TransformFields( r, { "SpendRevenueUKonto", each if _ = null and r[Product] = null then r[Ledger Account] else _ } )
                                        )
                                    ),

                                AddIndex = Table.FillDown( Table.AddIndexColumn( BodyTable, "Index", 0, 1, Int64.Type), { "Ledger Account", "SpendRevenueUKonto" } ),

                                FilterOutSubTotals = 
                                    Table.RemoveColumns(
                                        Table.SelectRows( 
                                            AddIndex, 
                                            each 
                                                ( try not (Text.Middle( [Account Name], 5, 1 ) = ":" and Text.Middle( AddIndex{[Index] + 1} [Account Name], 6, 1 ) = "-") otherwise true ) and
                                                ( try not (Text.Middle( [Account Name], 5, 1 ) = ":" and Text.Middle( AddIndex{[Index] + 1} [Account Name], 2, 1 ) = " ") otherwise true ) and 
                                                ( try not (Text.Middle( [Account Name], 6, 1 ) = "-" and AddIndex{[Index] + 1} [Product] <> null ) otherwise true )
                                        ),
                                        { "Index" }
                                    )
                            in
                                FilterOutSubTotals
                )

    in
        AddBody,

    documentation = [
        Documentation.Name =  " fxKoncFileLeafLevel ",
        Documentation.Description = " Work with Workday files and transform them into the appropriate format for later use. ",
        Documentation.LongDescription = " The function extracts the Konc File from the specified path (parameter), for example '\\office\ekonomi\Filer\Konc\Konc_WD' at the leaf level. You can then expand the columns you want to use ",
        Documentation.Category = " Workday ",
        Documentation.Source = " GitHub Lucrafin ",
        Documentation.Version = " 1.0 ",
        Documentation.Author = " Aleksandar Kovacevic "
    ]

in 
    Value.ReplaceType(KoncFileLeafLevel, Value.ReplaceMetadata(Value.Type(KoncFileLeafLevel), documentation) )
