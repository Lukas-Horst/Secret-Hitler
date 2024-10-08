# Secret Hitler

Flutter project for the game Secret Hitler

# Contents

1. [Backend](#backend)
2. [Appwrite](#appwrite)
3. [Custom Widgets](#custom-widgets) 
   - [playerWidget](#playerwidget)

## Backend

### BoardOverviewBackend

###### playCardState:
The state of the playing cards (the 3 top cards).

| State |                                                Action                                                 |
|:-----:|:-----------------------------------------------------------------------------------------------------:|
|  -2   | The chancellor played a card and isn't on the move anymore (important for the discoverCard() method). | 
|  -1   |                                            Initial value.                                             | 
|   0   |                          Drawing 3 cards from the draw pile (if president).                           | 
|   1   |                                    Discard 1 card (if president).                                     |
|   2   |                        Play 1 card and discard the other one (if chancellor).                         |
|   3   |                                 Playing the top card (if president).                                  |
|   4   |                               Examines the top 3 cards  (if president).                               |

###### drawPileCardAmount
Serves as a buffer between the frontend end the serverside backend.
Compared to the serverside variable, it saves the amount of the non playable cards.
For this purpose the value is decremented by 3 after the playable cards are visible (this happens in the updateDrawPile() method).
The value is important in the playCard() method to update the animation correctly.
If only the top card is played, the value will be incremented by 2, also for the correct animation.

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

###### isInvestigated
The indices of the player which are already investigated.

###### notHitlerConfirmed
The indices of the player which are not hitler confirmed.

###### playState:
The play state is an integer variable whereby all actions between the players are synchronized.

| State |                          Action                           |
|:-----:|:---------------------------------------------------------:|
|   0   |        The President decides a chancellor to vote.        | 
|   1   |             Voting phase for the chancellor.              |
|   2   | The president plays the first card from the drawing pile. |
|   3   |      The President draw 3 cards and discard on card.      |
|   4   |  The chancellor play one card and discard the other one.  |
|   5   |          The President examines the top 3 cards.          |
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

## Custom Widgets

### playerWidget
The playerWidget is used on the PlayersAndElectionPage to show the current role or former role of the player and his voting for a chancellor.
It is also used for the presidential actions, which means for nominating a chancellor, checking the role of an player and killing a player.

###### opacityKeys:
A list of global opacityAnimation keys to have access to following things:

| Index |                       Visibility                       |
|:-----:|:------------------------------------------------------:|
|   0   | Visibility of the divider and the presidential action. |
|   1   |           Visibility of the execution image.           |
|   2   |       Visibility of the special election image.        |
|   3   |      Visibility of the investigate loyalty image.      |
|   4   |             Visibility of the voting icon.             |
|   5   |       Visibility of the former chancellor card.        |
|   6   |        Visibility of the former president card.        |
|   7   |           Visibility of the chancellor card.           |
|   8   |           Visibility of the president card.            |
|   9   |              Visibility of the yes card.               |
|  10   |               Visibility of the no card.               |
|  11   |   Visibility of the whole widget excepts the cards.    |
|  12   |           Visibility of the not hitler sign.           |

###### initialOpacityValues:
A list of a list of two doubles. The first double is the begin value of the OpacityAnimation the second double is the end value.
The value are only important for the initial building of the widget and is synchronized with the server backend on the initState() method.

| Index |                           Visibility                           |
|:-----:|:--------------------------------------------------------------:|
|   0   | Initial visibility of the divider and the presidential action. |
|   1   |           Initial visibility of the execution image.           |
|   2   |       Initial visibility of the special election image.        |
|   3   |      Initial visibility of the investigate loyalty image.      |
|   4   |             Initial visibility of the voting icon.             |
|   5   |       Initial visibility of the former chancellor card.        |
|   6   |        Initial visibility of the former president card.        |
|   7   |           Initial visibility of the chancellor card.           |
|   8   |           Initial visibility of the president card.            |
|   9   |              Initial visibility of the yes card.               |
|  10   |               Initial visibility of the no card.               |
|  10   |               Initial visibility of the no card.               |
|  11   |   Initial visibility of the whole widget excepts the cards.    |
|  12   |           Initial visibility of the not hitler sign.           |

###### arePresidentialActionsVisible(GameState gameState):
Method which returns an integer to decide, whether a presidential action is visible or not.

| Int |             Visibility              |
|:---:|:-----------------------------------:|
|  0  | No presidential actions is visible. |
|  1  | The chancellor election is visible. |

###### presidentialActions
A list of booleans which indicate if a presidential action is visible.

| Index |                      Visibility                      |
|:-----:|:----------------------------------------------------:|
|   0   |     The President decides a chancellor to vote.      |
|   1   | The President investigates a player's identity card. |
|   2   |        The President pick the next President.        |
|   3   |            The President kills a player.             |

###### voted
A bool which indicate whether the voting card is visible or not.
