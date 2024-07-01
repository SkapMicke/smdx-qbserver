local wordGuess

local function CloseGame()
    SendNUIMessage({
        action = 'closeWordGuess',
    })
end

RegisterNUICallback('wordGuessedCorrectly', function(_, cb)
    if not wordGuess then return cb('ok') end
    SetNuiFocus(false, false)
    wordGuess:resolve(true)
    wordGuess = nil
    CloseGame()
    cb('ok')
end)

RegisterNUICallback('tooManyGuesses', function(_, cb)
    if not wordGuess then return cb('ok') end
    SetNuiFocus(false, false)
    wordGuess:resolve(false)
    wordGuess = nil
    CloseGame()
    cb('ok')
end)

RegisterNUICallback('closeWordGuess', function(_, cb)
    if not wordGuess then return cb('ok') end
    SetNuiFocus(false, false)
    wordGuess:resolve(false)
    wordGuess = nil
    cb('ok')
end)

local function WordGuess(word, hint, guesses)
    wordGuess = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'wordGuess',
        word = word,
        hint = hint,
        maxGuesses = guesses
    })
    return Citizen.Await(wordGuess)
end
exports('WordGuess', WordGuess)
