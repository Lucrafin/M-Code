let Calendar = ( StartDateTable as table, StartDateColumn as text , optional EndDateTable as table, optional EndDateColumn as text ) =>

    let
        // EndDateTable is optional. We take StartDateTable if it is omitted
        EndDateTbl = if EndDateTable = null then StartDateTable else EndDateTable,

        // EndDateColumn is optional. We take StartDateColumn if it is omitted
        EndDateCol = if EndDateColumn = null then StartDateColumn else EndDateColumn,

        MinYear = Date.Year( List.Min( List.Combine( Table.ToColumns( Table.SelectColumns( StartDateTable, { StartDateColumn } ) ) ) ) ),
                
        MaxYear = Date.Year( List.Max( List.Combine( Table.ToColumns( Table.SelectColumns( EndDateTbl, { EndDateCol } ) ) ) ) ),
        
    
        Source = { Number.From( #date( MinYear, 1, 1 ) ) .. Number.From( #date( MaxYear, 12, 31 ) ) },
        #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Changed Type" = Table.TransformColumnTypes(#"Converted to Table",{{"Column1", type date}}),
        #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Date"}}),
        #"Inserted Year" = Table.AddColumn(#"Renamed Columns", "Year", each Date.Year([Date]), Int64.Type),
        #"Inserted Month" = Table.AddColumn(#"Inserted Year", "Month", each Date.Month([Date]), Int64.Type),
        #"Inserted Month Name" = Table.AddColumn(#"Inserted Month", "Month Name", each Date.MonthName([Date]), type text),
        #"Inserted Quarter" = Table.AddColumn(#"Inserted Month Name", "Quarter", each Date.QuarterOfYear([Date]), Int64.Type),
        #"Inserted Week of Year" = Table.AddColumn(#"Inserted Quarter", "Week of Year", each Date.WeekOfYear([Date]), Int64.Type),
        #"Inserted Day Name" = Table.AddColumn(#"Inserted Week of Year", "Day Name", each Date.DayOfWeekName([Date]), type text),
        #"Added Custom" = Table.AddColumn(#"Inserted Day Name", "Quarter Order", each [Year] * 10 + [Quarter], Int64.Type ),
        #"Added Custom1" = Table.AddColumn(#"Added Custom", "Year-Quarter", each Number.ToText( [Year] ) & "Q" & Number.ToText( [Quarter] ), type text),
        #"Added Custom2" = Table.AddColumn(#"Added Custom1", "Month-Year Order", each [Year] * 100 + [Month], Int64.Type),
        #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Month-Year Short", each Date.ToText( [Date], "MMM" ) & "-" & Number.ToText( [Year] ), type text),
        #"Added Custom4" = Table.AddColumn(#"Added Custom3", "Month-Short", each Date.ToText( [Date], "MMM" ), type text),
        #"Capitalized Each Word" = Table.TransformColumns(#"Added Custom4",{{"Month-Year Short", Text.Proper, type text}}),
        #"Inserted Day of Week" = Table.AddColumn(#"Capitalized Each Word", "Day of Week", each Date.DayOfWeek([Date]), Int64.Type),
        #"Added Custom5" = Table.AddColumn(#"Inserted Day of Week", "Week Name", each "v-" & Number.ToText( [Week of Year] ), type text),
        #"Inserted End of Month" = Table.AddColumn(#"Added Custom5", "End of Month", each Date.EndOfMonth([Date]), type date),
        #"Inserted Day" = Table.AddColumn(#"Inserted End of Month", "Day", each Date.Day([Date]), Int64.Type),
        #"Inserted Start of Month" = Table.AddColumn(#"Inserted Day", "Start of Month", each Date.StartOfMonth([Date]), type date),
        Custom1 = Table.AddColumn( #"Inserted Start of Month", "Month-Year Long", each Date.ToText( [Date], "MMMM" ) & " - " & Number.ToText( [Year] ), type text),
        #"Inserted Start of Quarter" = Table.AddColumn(Custom1, "Start of Quarter", each Date.StartOfQuarter([Date]), type date),
        #"Inserted End of Quarter" = Table.AddColumn(#"Inserted Start of Quarter", "End of Quarter", each Date.EndOfQuarter([Start of Quarter]), type date) 
    in
        #"Inserted End of Quarter",
        
        documentation = [
            Documentation.Name =  " fxCalendar ",
            Documentation.Description = " Create a calendar table with input from a date column from another table. ",
            Documentation.LongDescription = " Create a calendar table with input from a date column from another table. ",
            Documentation.Category = " Calendar ",
            Documentation.Source = " GitHub Lucrafin ",
            Documentation.Version = " 1.0 ",
            Documentation.Author = " Aleksandar Kovacevic "
        ]

         //Table.FromRecords( { [myRecord] } )
        
in 

    Value.ReplaceType(Calendar, Value.ReplaceMetadata(Value.Type(Calendar), documentation) )
