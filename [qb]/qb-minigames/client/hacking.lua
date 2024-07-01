local hacking

RegisterNuiCallback('hackSuccess', function(_, cb)
    if not hacking then return cb('ok') end
    SetNuiFocus(false, false)
    hacking:resolve(true)
    hacking = nil
    cb('ok')
end)

RegisterNuiCallback('hackFail', function(_, cb)
    if not hacking then return cb('ok') end
    SetNuiFocus(false, false)
    hacking:resolve(false)
    hacking = nil
    cb('ok')
end)

RegisterNuiCallback('hackClosed', function(_, cb)
    if not hacking then return cb('ok') end
    SetNuiFocus(false, false)
    hacking:resolve(false)
    hacking = nil
    cb('ok')
end)

local function Hacking(solutionsize, timeout)
    hacking = promise.new()
    SetNuiFocus(true, false)
    SendNUIMessage({
        action = 'startHack',
        solutionsize = solutionsize,
        timeout = timeout
    })
    return Citizen.Await(hacking)
end
exports('Hacking', Hacking)
