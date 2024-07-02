QBCore.Commands.Add('rob', 'Rob a Player', {}, false, function(source)
    TriggerClientEvent('police:client:RobPlayer', source)
end)

QBCore.Commands.Add('giveitem', 'Give An Item (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'item', help = 'Name of the item (not a label)' }, { name = 'amount', help = 'Amount of items' } },
    false, function(source, args)
    local id = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(id)
    local amount = tonumber(args[3]) or 1
    local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
    if Player then
        if itemData then
            local info = {}
            if itemData['type'] == 'weapon' then
                amount = 1
                info.serie = tostring(QBCore.Shared.RandomInt(2) ..
                QBCore.Shared.RandomStr(3) ..
                QBCore.Shared.RandomInt(1) ..
                QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                info.quality = 100
            elseif itemData['name'] == 'harness' then
                info.uses = 20
            elseif itemData['name'] == 'syphoningkit' then
                info.gasamount = 0
            elseif itemData['name'] == 'jerrycan' then
                info.gasamount = 0
            elseif itemData['name'] == 'markedbills' then
                info.worth = 10
            elseif QBCore.Shared.Items[itemData['name']]['decay'] and QBCore.Shared.Items[itemData['name']]['decay'] > 0 then
                info.quality = 100
            end

            if AddItem(id, itemData['name'], amount, false, info) then
                lib.notify(source, {
                    title = 'Inventory',
                    description = 'You Have Given: ' ..
                    GetPlayerName(id) .. ' Amount: ' .. amount .. ' Item: ' .. itemData['name'] .. '',
                    type = 'success',
                })
                TriggerEvent('qb-log:server:CreateLog', 'giveitem', 'Give Item Log', 'green',
                    '** Admin:  ' ..
                    GetPlayerName(source) ..
                    ' \n Added Item to: ' ..
                    GetPlayerName(tonumber(args[1])) ..
                    '[' ..
                    Player.PlayerData.citizenid ..
                    ']\n Item Name: [' .. itemData['name'] .. '] \n Amount : [' .. amount .. ']** ')
            else
                lib.notify(source, {
                    title = 'Inventory',
                    description = 'Can\'t give more items!',
                    type = 'error',
                })
            end
        else
            lib.notify(source, {
                title = 'Inventory',
                description = 'Item Does Not Exist!',
                type = 'error',
            })
        end
    else
        lib.notify(source, {
            title = 'Inventory',
            description = 'Player isn\'t online!',
            type = 'error',
        })
    end
end, 'god')

QBCore.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local playerId = args[1] ~= '' and tonumber(args[1]) or source
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        ClearInventory(playerId)
    else
        lib.notify(source, {
            title = 'Inventory',
            description = 'Player isn\'t online!',
            type = 'error',
        })
    end
end, 'god')

QBCore.Commands.Add('clearinvoffline', 'Clear Offline Players Inventory (Admin Only)', { { name = 'citizenid', help = 'Citizen ID' } }, false, function(source, args)
    local citizenId = args[1]
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenId)
    if Player then
        ClearInventory(Player.PlayerData.source)
    else
        MySQL.Async.fetchAll('SELECT * FROM players WHERE citizenid = @citizenid', { ['@citizenid'] = citizenId }, function(result)
            if result and result[1] then
                MySQL.Async.execute('UPDATE players SET inventory = \'{}\' WHERE citizenid = @citizenid', { ['@citizenid'] = citizenId })
                lib.notify(source, {
                    title = 'Inventory',
                    description = 'Player inventory successfully cleared!',
                    type = 'success',
                })
            else
                lib.notify(source, {
                    title = 'Inventory',
                    description = 'Player citizen id not found!',
                    type = 'error',
                })
            end
        end)
    end
end, 'admin')