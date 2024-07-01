local skillbar

RegisterNUICallback('skillbarFinish', function(data, cb)
    if not skillbar then return cb('ok') end
    SetNuiFocus(false, false)
    skillbar:resolve(data.success)
    skillbar = nil
    cb('ok')
end)

local function Skillbar(difficulty, validKeys)
    skillbar = promise.new()
    SetNuiFocus(true, false)
    SendNUIMessage({
        action = 'openSkillbar',
        difficulty = difficulty or 'easy',
        validKeys = validKeys or '1234'
    })
    return Citizen.Await(skillbar)
end
exports('Skillbar', Skillbar)
