local wordScramble

local function CloseGame()
    SendNUIMessage({
        action = 'close',
    })
end

RegisterNUICallback('scrambleIncorrect', function(_, cb)
    if not wordScramble then return cb('ok') end
    TriggerEvent('QBCore:Notify', 'Incorrect word', 'error', 2500)
    cb('ok')
end)

RegisterNUICallback('scrambleCorrect', function(_, cb)
    if not wordScramble then return cb('ok') end
    TriggerEvent('QBCore:Notify', 'Guessed correctly!', 'success', 2500)
    SetNuiFocus(false, false)
    wordScramble:resolve(true)
    wordScramble = nil
    CloseGame()
    cb('ok')
end)

RegisterNUICallback('scrambleTimeOut', function(_, cb)
    if not wordScramble then return cb('ok') end
    SetNuiFocus(false, false)
    wordScramble:resolve(false)
    wordScramble = nil
    CloseGame()
    cb('ok')
end)

RegisterNUICallback('closeScramble', function(_, cb)
    if not wordScramble then return cb('ok') end
    SetNuiFocus(false, false)
    wordScramble:resolve(false)
    wordScramble = nil
    CloseGame()
    cb('ok')
end)

local function WordScramble(word, hint, timer)
    wordScramble = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'wordScramble',
        word = word,
        hint = hint,
        time = timer
    })
    return Citizen.Await(wordScramble)
end
exports('WordScramble', WordScramble)
