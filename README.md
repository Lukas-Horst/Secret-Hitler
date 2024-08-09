# Secret Hitler

Flutter project for the game Secret Hitler


## <u>Appwrite</u> 
Appwrite is used for the server-side part of the app.

## Authentication

## Database

### User
The user collection saves information for the authentication part.

### Game Room

### Game State
The game state is a collection in the database to synchronized all necessary information between the players.

#### isActive
A boolean which indicated whether the game is running.

#### playerNames
All names of the players in a list of strings.

#### playerOrder
All id'S of the player in a list of strings. The order of the list decides the order of the presidents.

#### playerRoles
The roles (Fascist, Liberal or Hitler) in a list of strings.

#### currentPresident
The index of the current president.

#### currentChancellor
The index of the current chancellor. (Is nullable)

#### formerPresident
The index of the last president. (Is nullable)

#### formerChancellor
The index of the last chancellor. (Is nullable)

#### regularPresident
A boolean which indicated whether the current president is regular or was picked.

#### killedPlayers
The indices of the player which are dead in a list of integers.

#### playState
The play state is an integer variable whereby all actions between the players are synchronized.

| Play State |                          Action                           |
|:----------:|:---------------------------------------------------------:|
|     0      |        The President decides a chancellor to vote.        | 
|     1      |             Voting phase for the chancellor.              |
|     2      | The president plays the first card from the drawing pile. |
|     3      |      The President draw 3 cards and discard on card.      |
|     4      |  The chancellor play on card and discard the other one.   |
|     5      |          The President examines the top 3 cards           |
|     6      |   The President investigates a player's identity card.    |
|     7      |          The President pick the next President.           |
|     8      |               The President kills a player.               |
