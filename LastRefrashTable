let
    Source = ( optional sourceName as text ) as table => 
    let
        Now = DateTimeZone.UtcNow(),
        lastRefresh = #table(
            type table [
                Last Refresh UTC = datetimezone,
                Source Name = text,
                Date UTC = date,
                Time UTC = time
            ],
            {
                {
                    Now,
                    sourceName,
                    DateTime.Date( Now ),
                    DateTime.Time( Now )
                }
            }
        )

    in 
        lastRefresh
in
    Source
