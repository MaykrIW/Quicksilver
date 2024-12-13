// Contains non specific util and helper functions.
// As more functions are created they will be grouped as required
QS.Utils = {}


function QS.Utils.GetDateString() 
    return os.date("%m-%d-%y")
end

function QS.Utils.GetTimeStamp()
    return os.date("[%H:%M] ")
end

// String Parser takes a string and returns a table of segments.
function QS.Utils.ParseArguments(string)
    local parsedArguments = {}
    local isQuoteOpen = false
    local wasQuoteJustOpened = false
    
    local segments = string.Explode(" ", string)
    
    // Iterate through each word in the input
    for _, word in pairs(segments) do
        word = string.Trim(word)
        wasQuoteJustOpened = false
        // Does the word contain a double quote? Used to avoid odd string behavior
        if word[1] == '"' and !isQuoteOpen then
            isQuoteOpen = true
            // Start a new argument for quoted text
            parsedArguments[#parsedArguments + 1] = ""  
            wasQuoteJustOpened = true
        end

        if !isQuoteOpen then
            local word = string.Trim(word, " ")
            word = string.Trim(word, [["]])
            parsedArguments[#parsedArguments + 1] = word
        end
        // If inside quotes, accumulate segments into one
        if isQuoteOpen then
            parsedArguments[#parsedArguments] = parsedArguments[#parsedArguments] .. " " .. word
            // Check if this word closes the quote block
            if word[#word] == [["]] or (word[1] == [["]] and not wasQuoteJustOpened) then
                isQuoteOpen = false
                parsedArguments[#parsedArguments] = string.Trim(parsedArguments[#parsedArguments], " ")
                parsedArguments[#parsedArguments] = string.Trim(parsedArguments[#parsedArguments], [["]])
            end
        end
    end
    // Final cleanup of each argument (trim spaces and quotes)
    for index, argument in pairs(parsedArguments) do
        parsedArguments[index] = string.Trim(argument, " ")
        parsedArguments[index] = string.Trim(parsedArguments[index], [["]])
    end

    return parsedArguments
end

// Takes a table and combines all values into a single string seperated user defined value.
// Optionally can set different starting point
function QS.Utils.TableConcatToString(inputTable, separator, startIndex)
    if !startIndex then startIndex = 1 end

    local concatenatedString = tostring(inputTable[startIndex])

    for currentIndex = startIndex + 1, #inputTable do
        concatenatedString = concatenatedString .. separator .. tostring(inputTable[currentIndex])
    end

    return concatenatedString
end

// Returns a random string of the provided length
// types are > lower (l), upper (u), mixed (m). Defaults to Upper
function QS.Utils.RandomChars(length, typeString)
    local set = ""
    local randomChars =""
    
    if typeString == "m" then
        set = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"
    elseif typeString == "l" then
        set = "abcdefghijklmnopqrstuvwxyz"
    else
        set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end
    
    for i = 1, length do
        local c = math.random(#set)
        randomChars = randomChars .. string.sub(set, c, c)
    end
    return randomChars
end