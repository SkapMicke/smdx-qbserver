const inputs = document.querySelector(".inputs"),
    hintTag = document.querySelector(".guess-hint span"),
    guessLeft = document.querySelector(".guess-left span"),
    wrongLetter = document.querySelector(".wrong-letter span"),
    typingInput = document.querySelector(".typing-input"),
    guessContainer = document.querySelector(".guess-container");

let word,
    maxGuesses,
    incorrectLetters = [],
    correctLetters = [];

const setupWordGuessGame = (receivedWord, receivedHint, maxAllowedGuesses) => {
    word = receivedWord.toLowerCase();
    maxGuesses = maxAllowedGuesses;
    correctLetters = Array(word.length).fill("");
    incorrectLetters = [];

    hintTag.textContent = receivedHint;
    guessLeft.textContent = maxGuesses;
    wrongLetter.textContent = incorrectLetters.join(", ");

    let html = "";
    for (let i = 0; i < word.length; i++) {
        html += `<input type="text" disabled>`;
    }
    inputs.innerHTML = html;
    guessContainer.style.display = "flex";
};

const initGuessGame = (key) => {
    if (!key.match(/^[A-Za-z]$/) || incorrectLetters.includes(key) || correctLetters.includes(key)) {
        return;
    }

    if (word.includes(key)) {
        word.split("").forEach((char, index) => {
            if (char === key) {
                correctLetters[index] = key;
                inputs.querySelectorAll("input")[index].value = key;
            }
        });
    } else {
        maxGuesses--;
        incorrectLetters.push(key);
    }

    guessLeft.textContent = maxGuesses;
    wrongLetter.textContent = incorrectLetters.join(", ");
    checkGameStatus();
    typingInput.value = "";
};

const checkGameStatus = () => {
    if (!correctLetters.includes("")) {
        fetch(`https://${GetParentResourceName()}/wordGuessedCorrectly`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
        }).catch((err) => console.error("Error with fetch:", err));
    } else if (maxGuesses <= 0) {
        fetch(`https://${GetParentResourceName()}/tooManyGuesses`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
        }).catch((err) => console.error("Error with fetch:", err));
        revealWord();
    }
};

const revealWord = () => {
    word.split("").forEach((char, index) => {
        inputs.querySelectorAll("input")[index].value = char;
    });
};

const resetGuessGame = () => {
    setupWordGuessGame("", "", 0);
    typingInput.value = "";
    guessContainer.style.display = "none";
};

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeWordGuess`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({}),
        }).catch((err) => console.error("Error with fetch:", err));
        resetGuessGame();
    }
});

window.addEventListener("message", (event) => {
    let data = event.data;
    if (data.action === "wordGuess") {
        setupWordGuessGame(data.word, data.hint, data.maxGuesses);
    } else if (data.action === "closeWordGuess") {
        resetGuessGame();
    }
});

typingInput.addEventListener("input", (e) => initGuessGame(e.target.value.toLowerCase()));
inputs.addEventListener("click", () => typingInput.focus());
