gspotify = gspotify or {}

-- The client ID of the Spotify app (the secret will never be public)
gspotify.ClientID = "5b94f2519b444963b0a05f93090a4c99"

include("authorization.lua")

gspotify.RandomCharSet = {}
local charset = gspotify.RandomCharSet
do
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end

    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end

    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
end
function gspotify.GenerateRandomString(length)
    if not length or length <= 0 then
        return ""
    end

    math.randomseed(os.clock() ^ 2)
    local res = ""
    for i = 1, length do
        res = res .. charset[math.random(1, #charset)]
    end

    return res
end
