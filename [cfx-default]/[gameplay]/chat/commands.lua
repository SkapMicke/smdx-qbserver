local QBCore = exports['qb-core']:GetCoreObject()

-- Functions --

local function GetRealPlayerName(source)
    local src = source
    PlayerData = PlayerData or {}
	PlayerData.name = GetPlayerName(src)

	if PlayerData then
		return PlayerData.name
	end
end

-- Roleplay Commands Start --
QBCore.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
    if #args < 1 then TriggerClientEvent('QBCore:Notify', source, '¡Todos los argumentos deben estar presentes!', 'error') return end
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local msg = "* " .. 'ME | ' .. table.concat(args, ' '):gsub('[~<].-[>~]', '') .. " *"
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players do
        local Player = Players[i]
        local target = GetPlayerPed(Player)
        local tCoords = GetEntityCoords(target)
        if target == ped or #(pCoords - tCoords) < 20 then
            TriggerClientEvent('QBCore:Command:3dMe', Player, source, msg)
        end
    end
end, 'user')

QBCore.Commands.Add("say", "Though Command",  { }, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local playerName = GetRealPlayerName(source)
    local msg = rawCommand:sub(5)
    local time = os.date('%I:%M')
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-say say"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
        args = { playerName, msg, time }
    })
end, "user")

QBCore.Commands.Add("twt", "Tweet Command",  { }, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local playerName = GetRealPlayerName(source)
    local msg = rawCommand:sub(5)
    local time = os.date('%I:%M')
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-tweet twt"><i class="fab fa-twitter"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
        args = { playerName, msg, time }
    })
end, "user")

QBCore.Commands.Add("twta", "Anonymous Tweet Command",  { }, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local playerName = GetRealPlayerName(source)
    local msg = rawCommand:sub(5)
    local time = os.date('%I:%M')
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-tweet twt"><i class="fab fa-twitter"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">Anonymous Msg:</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
        args = { playerName, msg, time }
    })
end, "user")


-- Roleplay Commands End --



-- Job Commands Start --

QBCore.Commands.Add("pol", "Police Ad Command",  { }, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local msg = rawCommand:sub(5)
    local time = os.date('%I:%M')
    if Player.PlayerData.job.name =="police" and Player.PlayerData.job.onduty  then
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-police pol"><i class="fas fa-user-shield"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not a cop or not on duty', 'error', 4000)
    end
end, "user")

QBCore.Commands.Add("ems", "EMS Ad Command",  { }, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local msg = rawCommand:sub(5)
    local time = os.date('%I:%M')
    if Player.PlayerData.job.name =="ambulance" and Player.PlayerData.job.onduty then -- job check and duty check
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-ems ems"><i class="fas fa-heartbeat"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not a ems or not on duty', 'error', 4000)
    end
end, "user")

QBCore.Commands.Add('mechanic', 'Mechanic Ad Command', {}, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local msg = rawCommand:sub(9)
    local time = os.date('%I:%M')
    if Player.PlayerData.job.name =="mechanic" and Player.PlayerData.job.onduty then -- job check and duty check
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-mechanic mechanic"><i class="fas fa-cogs"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not a mechanic or not on duty', 'error', 4000)
    end

end, "user")
-- Job Commands End --

-- Admin Chat | Commands --

QBCore.Commands.Add("clearall", "Clear Chat to all the players",  { }, true ,function()
    TriggerClientEvent('chat:clear', -1)
end, "god")

-- Admin Chat | Commands End--QBCore.Functions.LoadParticleDictionary(dictionary)