local pinpadPromise

RegisterNUICallback('pinpadExit', function(_, cb)
    if not pinpadPromise then return cb('ok') end
    SetNuiFocus(false, false)
    pinpadPromise:resolve({ quit = true })
    pinpadPromise = nil
    cb('ok')
end)

RegisterNUICallback('pinpadFinish', function(data, cb)
    if not pinpadPromise then return cb('ok') end
    SetNuiFocus(false, false)
    pinpadPromise:resolve({ quit = false, correct = data.correct })
    pinpadPromise = nil
    cb('ok')
end)

local function StartPinpad(numbers)
    pinpadPromise = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openPinpad',
        numbers = numbers
    })
    return Citizen.Await(pinpadPromise)
end

exports('StartPinpad', StartPinpad)
