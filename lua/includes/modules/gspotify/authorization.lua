function gspotify.Authorize(cb)
    local state = gspotify.GenerateRandomString(16)

    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 600)
    frame:SetTitle("Spotify authorization")
    frame:SetDeleteOnClose(true)
    frame:SetScreenLock(true)
    frame:SetSizable(true)
    frame.OnClose = function(self)
        cb(false, "cancelled")
    end
    frame:Center()
    frame:MakePopup()

    local window = vgui.Create("DHTML", frame)
    window:Dock(FILL)
    window:AddFunction("gspotify", "authorize", function(data)
        frame:Remove()

        if data.state ~= state then
            cb(false, "invalid_state")
            return
        end

        if data.error then
            cb(false, "failed_authorization", data.error)
            return
        end

        http.Fetch("https://gspotify.metaman.xyz/token?code=" .. data.code,
        function(body, size, headers, code)
            if code == 200 then
                cb(true, util.JSONToTable(body))
            else
                cb(false, "invalid_token_response", {code = code, body = body, headers = headers})
            end
        end,
        function(error)
            cb(false, "failed_token_request", error)
        end)
    end)
    window:OpenURL("https://accounts.spotify.com/authorize?client_id=" .. gspotify.ClientID .. "&response_type=code&redirect_uri=https%3A%2F%2Fgspotify.metaman.xyz%2Fauthorize&scope=user-read-currently-playing%20user-read-playback-state%20user-modify-playback-state&state=" .. state)
end
