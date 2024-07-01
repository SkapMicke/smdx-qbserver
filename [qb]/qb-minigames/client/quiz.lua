local quiz
local required = 0

RegisterNUICallback('exitQuiz', function(_, cb)
    if not quiz then return cb('ok') end
    SetNuiFocus(false, false)
    quiz:resolve(false)
    quiz = nil
    required = 0
    cb('ok')
end)

RegisterNUICallback('quitQuiz', function(data, cb)
    if not quiz then return cb('ok') end
    if data.score >= required then
        quiz:resolve(true)
    else
        quiz:resolve(false)
    end
    SetNuiFocus(false, false)
    quiz = nil
    required = 0
    cb('ok')
end)

local function Quiz(questions, correctRequired, timer)
    for i, question in ipairs(questions) do
        question.numb = i
    end
    required = correctRequired
    quiz = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'startQuiz',
        questions = questions,
        timer = timer
    })
    return Citizen.Await(quiz)
end
exports('Quiz', Quiz)
