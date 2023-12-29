class Player {
    constructor (name, score) {
        this.name = name;
        this.score = score;
    }

    addOneScore() {
        this.score += 1;
    }
}
// Prototype for types of cards
const SHAPES = ['diamond', 'squiggle', 'oval'];
const NUMBERS = ['one', 'two', 'three'];
const SHADINGS = ['solid', 'striped', 'open'];
const COLORS = ['red', 'green', 'purple'];

// Create global players
let player1, player2;

// Get player names and save them
const submitButton = document.getElementById('submit-button');
submitButton.addEventListener("click", function() {
    [player1, player2] = getPlayers();
});

// SelectedCards are empty at first
let selectedCards = [];
let deck = [];
let hand = [];

// Event listener to start game
const newGameButton = document.getElementById('new-game-button');
newGameButton.addEventListener("click", freshNewGame);

function freshNewGame() {
    // Reset selectedCards when new game starts
    //Logic to reset the player scores
    const player1Name = document.getElementById('player1').value;
    const player2Name = document.getElementById('player2').value;
    if (player1Name != '' && player2Name != '') {
        player1.score = 0;
        player2.score = 0;
        updateScores();
    }

    selectedCards = [];
    deck = [];
    hand = [];
    player1.score = 0;
    player2.score = 0;
    document.getElementById('selectedCards').textContent = "";

    // Set up initial deck and board to screen
    deck = getDeck();
    const gameBoard = document.getElementById('gameBoard');
    gameBoard.innerHTML = '';

    // Deal initial hand
    hand = dealHand(deck, 12);
    displayCards(hand, gameBoard);

    // Create button for checking set for each player
    const checkSetButtonPlayer1 = document.createElement('button');
    checkSetButtonPlayer1.textContent = 'Check Set: Player 1';
    checkSetButtonPlayer1.id = 'check-set-1';
    const checkSetButtonPlayer2 = document.createElement('button');
    checkSetButtonPlayer2.textContent = 'Check Set: Player 2';
    checkSetButtonPlayer2.id = 'check-set-2';

    //Populate end game button
    const endOfGameButton = document.getElementById('end-of-game');
    endOfGameButton.style.display = 'block';
    endOfGameButton.onclick = () => endOfGame();

    // Handle checking for each player
    checkSetButtonPlayer1.onclick = () => checkSet(player1);
    checkSetButtonPlayer2.onclick = () => checkSet(player2);

    // Print buttons to screen
    const buttonContainer1 = document.getElementById('buttonContainer');
    const buttonContainer2 = document.getElementById('buttonContainer');
    buttonContainer1.innerHTML = '';
    buttonContainer2.innerHTML = '';
    buttonContainer1.appendChild(checkSetButtonPlayer1);
    buttonContainer2.appendChild(checkSetButtonPlayer2);
}

function getPlayers() {
    const player1Name = document.getElementById('player1').value;
    const player2Name = document.getElementById('player2').value;

    // Create 2 new players with no points to start
    if (player1Name != '' && player2Name != '') {
        player1 = new Player(player1Name, 0);
        player2 = new Player(player2Name, 0);

        // Remove form after input
        const playerInputForm = document.getElementById('player_input');
        playerInputForm.style.display = 'none';

        // Show the previously hidden div to welcome players
        const welcomeMessage = document.getElementById('welcome-message');
        const hidden = document.getElementById('hidden');
        welcomeMessage.textContent = `Prepare for an epic game, ${player1.name} and ${player2.name}!`;
        hidden.style.display = 'block';

        updateScores();

        return [player1, player2];
    } else {
        alert('You must enter valid names to begin');
    }    
}

function updateScores() {
    const scorePlayer1 = document.getElementById('score-player1');
    const scorePlayer2 = document.getElementById('score-player2');
    scorePlayer1.textContent = `${player1.name}'s Score: ${player1.score}`;
    scorePlayer2.textContent = `${player2.name}'s Score: ${player2.score}`;
}

function getDeck() {
    SHAPES.forEach(shape => {
        NUMBERS.forEach(number => {
            SHADINGS.forEach(shading => {
                COLORS.forEach(color => {
                    deck.push({ shape, number, shading, color });
                });
            });
        });
    });
    return shuffle(deck);
}

function shuffle(array) {
    return array.sort(() => Math.random() - 0.5);
}

function handHasSet(hand) {
    const handSize = hand.length;
  
    for (let i = 0; i < handSize - 2; i++) {
      for (let j = i + 1; j < handSize - 1; j++) {
        for (let k = j + 1; k < handSize; k++) {
          if (isSet(hand[i], hand[j], hand[k])) {
            return true;
          }
        }
      }
    }
  
    return false;
}

function dealHand(deck, numCards) {
    if (deck.length == 0) {
        alert('There are no more cards so the game must come to an end...');
        endOfGame();
    }

    for (let i = 0; i < numCards && deck.length > 0; i++) {
        const drawnCard = deck.shift(); 
        hand.push(drawnCard);
    }  

    // Check if the hand contains at least one set
    while (!handHasSet(hand) && deck.length >= 3) {
        alert('There are currently no sets in the face up deck, let us draw three more cards');
        
        // If there is no set found in the hand, draw three more cards
        for (let i = 0; i < 3; i++) {
            const randomIndex = Math.floor(Math.random() * deck.length);
            const drawnCard = deck.splice(randomIndex, 1)[0];
            hand.push(drawnCard);
        }
    }
  
    // If there are no more sets to be made from remaining cards, end game
    if (deck.length < 3 && !handHasSet(hand)) {
        alert('There are no more sets in the remaining deck, start a new game if you would like to play again!');
        endOfGame();
    }
    return hand;
}

function displayCards(cards, container) {
    container.innerHTML = '';
    cards.forEach((card, index) => {
        const cardDiv = document.createElement('div');
        cardDiv.classList.add('card');
        cardDiv.id = 'card-look';

        // Make an image URL with the attrivutes on the cards like how they are on the .png
        const imageUrl = `cards/${card.shape}_${card.number}_${card.shading}_${card.color}.png`;

        // Create <img> element with URL
        const cardImage = document.createElement('img');
        cardImage.src = imageUrl;

        // Add element to screen
        cardDiv.addEventListener('click', () => handleCardClick(cardDiv, card, container));
        cardDiv.appendChild(cardImage);
        container.appendChild(cardDiv);
    });
}

function isSet(card1, card2, card3) {
    const shapes = [card1.shape, card2.shape, card3.shape];
    const numbers = [card1.number, card2.number, card3.number];
    const shadings = [card1.shading, card2.shading, card3.shading];
    const colors = [card1.color, card2.color, card3.color];

    return (
        (allSameOrAllDifferent(shapes) &&
        allSameOrAllDifferent(numbers) &&
        allSameOrAllDifferent(shadings) &&
        allSameOrAllDifferent(colors))
    );
}

function allSameOrAllDifferent(arr) {
    const uniqueValues = new Set(arr);
    return uniqueValues.size === 1 || uniqueValues.size === arr.length;
}

// Get the attributes from the image URL for the cards
function parseAttributes(imageURL) {
    // Get the filename from the URL
    const filename = imageURL.split('/').pop(); 
    const [shape, number, shading, color] = filename.replace('.png', '').split('_');

    return {
        shape,
        number,
        shading,
        color,
    };
}

function handleCardClick(cardDiv, selectedCard, container) {
    if (cardDiv.classList.contains('selected')) {
        // Remove select from card
        cardDiv.classList.remove('selected');
        selectedCards = selectedCards.filter(card => card !== selectedCard);
    } else {
        // Add selected to card
        cardDiv.classList.add('selected');
        selectedCards.push(selectedCard);
    }

    // Update "selectedCards" div
    const selectedCardsContainer = document.getElementById('selectedCards');
    selectedCardsContainer.textContent = `Selected Cards: ${selectedCards.map(card => formatCardName(card)).join(', ')}`;
}

function formatCardName(card) {
    return `${card.shape} - ${card.number} - ${card.shading} - ${card.color}`;
}

function checkSet(currentPlayer) {
    if (selectedCards.length === 3) {
        if (isSet(selectedCards[0], selectedCards[1], selectedCards[2])) {
            alert('Correct! You found a set.');

            // Award points accordingly
            currentPlayer.addOneScore();
            updateScores();
            
            // Remove selected, deal 3 new and display
            removeCards();
            hand = dealHand(deck, 3);
            displayCards(hand, document.getElementById('gameBoard'));

        } else {
            alert('Incorrect! The selected cards do not form a valid set.');
            
            // Remove selection and keep original cards
            deselectCards();
        }
    } else {
        alert('Please select 3 cards before checking.');
        deselectCards();
    }
}

function deselectCards() {
    while (document.querySelector('.selected') !== null) {
        document.querySelector('.selected').classList.remove("selected");
    }
    selectedCards = [];
    document.getElementById('selectedCards').textContent = "";
}

function removeCards() {
    while (document.querySelector('.selected') !== null) {
        document.querySelector('.selected').remove();
    }
    hand = hand.filter(card => !selectedCards.includes(card));
    selectedCards = [];
    document.getElementById('selectedCards').textContent = "";
}

function endOfGame() {
    let winnerName = '';
    let winnerScore = 0;
    if (player1.score > player2.score) {
        winnerName = player1.name;
        winnerScore = player1.score;
    } else if (player2.score > player1.score) {
        winnerName = player2.name;
        winnerScore = player2.score;
    }
    else {
        winnerName = "tie";
        winnerScore = player1.score;
    }
    if (winnerName == "tie") {
        alert('Thank you for playing.\nIt\'s a tie with a score of ' + winnerScore + '.\n\nClick "New Game" to start a new game.');
    }
    else {
    alert('Thank you for playing and congratulations to ' + winnerName + ' for winning with a score of ' + winnerScore + '!\nClick "New Game" to start a new game.');
    }
    const endOfGameButton = document.getElementById('end-of-game');
    endOfGameButton.style.display = 'none';
}
