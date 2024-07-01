const inputField = document.querySelector("input"),
    wordText = document.querySelector(".word"),
    hintText = document.querySelector(".hint span"),
    timeText = document.querySelector(".time b"),
    scrambleContainer = document.querySelector(".scramble-container"),
    checkBtn = document.querySelector(".buttons .check-word");

let correctWord, timer;

const checkWord = () => {
    let userWord = inputField.value.toLowerCase();
    if (!userWord) return alert("Please enter the word to check!");

    const action = userWord === correctWord ? "scrambleCorrect" : "scrambleIncorrect";

    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify({}),
    }).catch((err) => console.error("Error with fetch:", err));
};

const initTimer = (maxTime) => {
    clearInterval(timer);
    timer = setInterval(() => {
        if (maxTime > 0) {
            maxTime--;
            timeText.textContent = maxTime;
        } else {
            clearInterval(timer);
            fetch(`https://${GetParentResourceName()}/scrambleTimeOut`, {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({}),
            }).catch((err) => console.error("Error with fetch:", err));
        }
    }, 1000);
};

const shuffleWord = (word) => {
    let wordArray = word.split("");
    for (let i = wordArray.length - 1; i > 0; i--) {
        let j = Math.floor(Math.random() * (i + 1));
        [wordArray[i], wordArray[j]] = [wordArray[j], wordArray[i]];
    }
    return wordArray.join("");
};

const initGame = (scrambledWord, gameHint, gameTime) => {
    const shuffledWord = shuffleWord(scrambledWord);
    wordText.textContent = shuffledWord;
    hintText.textContent = gameHint;
    correctWord = scrambledWord.toLowerCase();
    inputField.value = "";
    inputField.setAttribute("maxlength", correctWord.length);
    initTimer(gameTime);
    scrambleContainer.style.display = "flex";
};

checkBtn.addEventListener("click", checkWord);

const resetGame = () => {
    scrambleContainer.style.display = "none";
    clearInterval(timer);
    correctWord = "";
    wordText.textContent = "";
    hintText.textContent = "";
    inputField.value = "";
    inputField.setAttribute("maxlength", 0);
    timeText.textContent = 0;
};

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeScramble`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({}),
        }).catch((err) => console.error("Error with fetch:", err));
        resetGame();
    }
});

window.addEventListener("message", (event) => {
    let data = event.data;
    if (data.action === "wordScramble") {
        initGame(data.word, data.hint, data.time);
    } else if (data.action === "close") {
        resetGame();
    }
});
