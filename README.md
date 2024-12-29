# M-Code
M-Code to reuse

In this section you will find examples of reusable M-code. Some of these are custom functions you can invoke, and others are code that you can customize for your project.
A simple function below can be used to create a refresh table for different sources and add one table to another.

```
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
```


