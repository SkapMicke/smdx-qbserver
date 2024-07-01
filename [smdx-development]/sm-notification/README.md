Heeey! Thanks for using my notify script!
if you got any questions, Feel free to contact me on discord. skapmicke

# Install guide.

in qb-core/client/functions.lua line 179 to 202, You have this:

RegisterNUICallback('getNotifyConfig', function(_, cb)
    cb(QBCore.Config.Notify)
end)

function QBCore.Functions.Notify(text, texttype, length, icon)
    local message = {
        action = 'notify',
        type = texttype or 'primary',
        length = length or 5000,
    }

    if type(text) == 'table' then
        message.text = text.text or 'Placeholder'
        message.caption = text.caption or 'Placeholder'
    else
        message.text = text
    end

    if icon then
        message.icon = icon
    end

    SendNUIMessage(message)
end

# Change that to this:

function QBCore.Functions.Notify(text, texttype, length)
    if type(text) == "table" then
        local ttext = text.text or 'Placeholder'
        local caption = text.caption or 'Placeholder'
        texttype = texttype or 'success'
        length = length or 5000
        exports['sm-notify']:sm_SendNotify({
            ["label"] = caption,
            ["text"] = ttext,
            ["time"] = length,
            ["type"] = texttype
        })
    else
        texttype = texttype or 'success'
        length = length or 5000
        exports['sm-notify']:sm_SendNotify({
            ["label"] = label,
            ["text"] = text,
            ["time"] = length,
            ["type"] = texttype
        })
    end
end

If you wanna do changes by your self and need this. Put it in the end of the client file, And restart the script.

RegisterCommand('test', function()
    exports['sm-notify']:sm_advanced("TEST", "SUBJECT", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", "CHAR_BANK_MAZE", 1, 5000, 'warning')
end)

 RegisterCommand('success', function()
     exports['sm-notify']:sm_alert("SUCCESS", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'success')
 end)

 RegisterCommand('info', function()
     exports['sm-notify']:sm_alert("INFO", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'info')
 end)

 RegisterCommand('error', function()
     exports['sm-notify']:sm_alert("ERROR", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'error')
 end)

 RegisterCommand('warning', function()
     exports['sm-notify']:sm_alert("WARNING", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'warning')
 end)
 RegisterCommand('allnotify', function()
    exports['sm-notify']:sm_alert("SUCCESS", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'success')
    exports['sm-notify']:sm_alert("WARNING", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'warning')
    exports['sm-notify']:sm_alert("ERROR", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'error')
    exports['sm-notify']:sm_alert("INFO", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'info')
end)