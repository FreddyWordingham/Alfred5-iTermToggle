on run argv

    -- Get current application name
    tell application "System Events"
        set currApp to first application process whose frontmost is true
        set currAppName to name of currApp
    end tell


    -- Retrieve previous application name
    script theData
        property prevAppName : missing value
    end script

    set thePath to (path to desktop as text) & "myData.scpt"
    try
        set theData to load script file thePath
    on error
        set theData's prevAppName to currAppName
    end try


    if currAppName = "iTerm2" then -- Focus back to the previous application
        tell application "System Events"
            tell process (theData's prevAppName)
                set frontmost to true
            end tell
        end tell
    else -- Open iTerm2 and/or focus on the last active terminal window
        tell application "iTerm2"
            set c to count of windows
        end tell

        if c = 0 then
            tell application "iTerm2"
                create window with default profile
            end tell
        else
            tell application "iTerm2"
                activate
            end tell
        end if
    end if

    -- Store the current application name for next time unless we haven't changed apps
    if (theData's prevAppName) = currAppName then
    else
        set theData's prevAppName to currAppName
        store script theData in file thePath replacing yes
    end if

end run
