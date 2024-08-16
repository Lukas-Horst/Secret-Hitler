# Secret Hitler

Flutter project for the game Secret Hitler

## Backend

### BoardOverviewBackend

###### playCardState:
The state of the playing cards (the 3 top cards).

| State |                         Action                         |
|:-----:|:------------------------------------------------------:|
|   0   |   Drawing 3 cards from the draw pile (if president).   | 
|   1   |             Discard 1 card (if president).             |
|   2   | Play 1 card and discard the other one (if chancellor). |
|   3   |          Playing the top card (if president).          |


## Appwrite
Appwrite is used for the server-side part of the app.

### Authentication

### Database

#### User
The user collection saves information for the authentication part.

#### Game Room

#### Game State
The game state is a collection in the database to synchronized all necessary information between the players.

###### isActive:
A boolean which indicated whether the game is running.

###### playerNames:
All names of the players in a list of strings.

###### playerOrder:
All id'S of the player in a list of strings. The order of the list decides the order of the presidents.

###### playerRoles:
The roles (Fascist, Liberal or Hitler) in a list of strings.

###### currentPresident:
The index of the current president.

###### currentChancellor:
The index of the current chancellor. (Is nullable)

###### formerPresident:
The index of the last president. (Is nullable)

###### formerChancellor:
The index of the last chancellor. (Is nullable)

###### regularPresident:
A boolean which indicated whether the current president is regular or was picked.

###### killedPlayers:
The indices of the player which are dead in a list of integers.

###### playState:
The play state is an integer variable whereby all actions between the players are synchronized.

| State |                          Action                           |
|:-----:|:---------------------------------------------------------:|
|   0   |        The President decides a chancellor to vote.        | 
|   1   |             Voting phase for the chancellor.              |
|   2   | The president plays the first card from the drawing pile. |
|   3   |      The President draw 3 cards and discard on card.      |
|   4   |  The chancellor play one card and discard the other one.  |
|   5   |          The President examines the top 3 cards           |
|   6   |   The President investigates a player's identity card.    |
|   7   |          The President pick the next President.           |
|   8   |               The President kills a player.               |
|   9   |                   The liberal team won.                   |
|  10   |                   The fascist team won.                   |

###### chancellorVoting:
A list of integers which shows the voting of a player.

| int |    Status     |
|:---:|:-------------:|
|  0  | Not yet voted |
|  1  |      No       |
|  2  |      Yes      |

###### electionTracker:
The position of the election tracker which is an int between 0 and 3.

###### fascistBoardCardAmount:
The amount of player fascist card which can between 0 and 6.

###### liberalBoardCardAmount:
The amount of player liberal card which can between 0 and 5.

###### cardColors:
A list of booleans to save all color values (false = fascist; true = liberal) of the cards on the draw pile.

###### drawPileCardAmount:
The amount of cards on the draw pile which is an int between 0 and 14.

###### discardedPresidentialCard:
The card index of the card which was discarded by the president. This can be an int between 0 and 2.