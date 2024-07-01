# qb-minigames

I didn't make these, I'm just converting them from here because I was bored so credit to whoever this is https://www.codingnepalweb.com/best-javascript-games-for-beginners
I plan on doing the rest

## Quiz
```lua
  local success = exports['qb-minigames']:Quiz({
        { question = 'What color is a peach?', answer = 'pink', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
        { question = 'What color is an apple?', answer = 'red', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
        { question = 'What color is an orange?', answer = 'orange', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
        { question = 'What color is a banana?', answer = 'yellow', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
        { question = 'What color is a strawberry?', answer = 'red', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
        { question = 'What color is a blueberry?', answer = 'blue', options = { 'red', 'yellow', 'orange', 'blue', 'pink' } },
    }, 3, 15) -- required amount of correct answers & amount of time in seconds they have to answer each question

  if success then print('success') else print('fail') end
```

## Word Guess
```lua
  local success = exports['qb-minigames']:WordGuess('fivem', 'the game modification you are playing on', 5) -- how many wrong guesses allowed
  if success then print('success') else print('fail') end
```

## Word Scramble
```lua
  local success = exports['qb-minigames']:WordScramble('fivem', 'the game modification you are playing on', 30) -- how long they have to unscramble in seconds
  if success then print('success') else print('fail') end
```

## Key Minigame
```lua
  local result = exports['qb-minigames']:KeyMinigame(10) -- amount of presses they need to do
    -- Returns if user quit game
  if result.quit then print('User quit game early') return end
    -- Returns how many times user pressed wrong key
  if result.faults > 3 then print('User got more than 3 keys wrong') end
```

## Lockpick
```lua
  local success = exports['qb-minigames']:Lockpick(5) -- number of tries
  if success then print('success') else print('fail') end
```

## Hacking
```lua
  local success = exports['qb-minigames']:Hacking(5, 30) -- code block size & seconds to solve
  if success then print('success') else print('fail') end
```

## Skillbar
```lua
  local success = exports['qb-minigames']:Skillbar() -- calling like this will use default easy difficulty with 1234
  if success then print('success') else print('fail') end

  local success = exports['qb-minigames']:Skillbar('medium') -- calling like this will just change difficulty and still use 1234
  if success then print('success') else print('fail') end

  local success = exports['qb-minigames']:Skillbar('easy', 'wasdfgh') -- calling like this will set difficulty and keys to press
  if success then print('success') else print('fail') end
```

## Pinpad
```lua
  local result = exports['qb-minigames']:StartPinpad(1234) -- numbers available to use are 1-9
  if result.quit then print('User quit game early') end
  if not result.correct then print('User failed game') end
  if result.correct then print('User passed game') end
```