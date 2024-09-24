// author: Lukas Horst

mixin LocaleData {
  static const Map<String, dynamic> EN = {
    'Login': 'Login',
    'Register': 'Register',
    'E-Mail': 'E-Mail',
    'Password': 'Password',
    'Enter your e-mail': 'Enter your e-mail',
    'Enter your password': 'Enter your password',
    'Forgot password?': 'Forgot password?',
    'Continue as guest': 'Continue as guest',
    'OR CONTINUE WITH': 'OR CONTINUE WITH',
    'No Account yet?': 'No Account yet?',
    'Confirm password': 'Confirm password',
    'Confirm your password': 'Confirm your password',
    'Already have an account?': 'Already have an account?',
    'Reset password': 'Reset password',
    'Enter your e-mail to reset your password.': 'Enter your e-mail to reset your password.',
    'Continue': 'Continue',
    'New password': 'New password',
    'Enter your new password': 'Enter your new password',
    'Save': 'Save',
    'New Game': 'New Game',
    'Join Game': 'Join Game',
    'Rules': 'Rules',
    'User data': 'User Data',
    'Statistics': 'Statistics',
    'Logout': 'Logout',
    'Settings': 'Settings',
    'Language': 'Language',
    'Design': 'Design',
    'Imprint': 'Imprint',
    'Choose your language.': 'Choose your language.',
    'German': 'German',
    'English': 'English',
    'Choose theme.': 'Choose whether you want a liberal theme or a fascist theme.',
    'Fascist': 'Fascist',
    'Liberal': 'Liberal',
    'Name': 'Name',
    'Enter your name': 'Enter your name',
    'Change password': 'Change password',
    'Delete account': 'Delete account',
    'Old password': 'Old password',
    'Enter your old password': 'Enter your old password',
    'Delete': 'Delete',
    'Please enter "DELETE"': 'Please enter "DELETE" in the text field to delete your account.',
    'Enter "DELETE"': 'Enter "DELETE"',
    'Confirm E-Mail': 'Confirm E-Mail',
    'Send confirmation e-mail': 'Send confirmation e-mail',
    'Confirm your current email': 'Please confirm your current email or change it.',
    'Continue without confirmation': 'Continue without confirmation',
    'OR': 'OR',
    'Confirmation email sent': 'Confirmation email sent.',
    'Confirmation email could not be sent': 'Confirmation email could not be sent.',
    'Email already sent': 'Email already sent.',
    'Passwords do not match': 'Passwords do not match',
    'Invalid email format': 'Invalid email format',
    'Less than 8 characters': 'Less than 8 characters',
    'More than 256 characters': 'More than 256 characters',
    'Field is empty': 'Field is empty',
    'Invalid credentials': 'Invalid credentials',

    // Rules Pages
    'RulePage1Section1': 'The year is 1932. The place is pre-WWII Germany. In Secret Hitler, players are German politicians attempting to hold a fragile Liberal government together and stem the rising tide of Fascism. Watch out though-there are secret Fascists among you, and one player is Secret Hitler.',
    'Overview': 'Overview',
    'RulePage1Section2': 'At the beginning of the game, each player is secretly assigned to one of three roles: Liberal, Fascist, or Hitler. The Liberals have a majority, but they don’t know for sure who anyone is; Fascists must resort to secrecy and sabotage to accomplish their goals. Hitler plays for the Fascist team, and the Fascists know Hitler’s identity from the outset, but Hitler doesn’t know the Fascists and must work to figure them out.',
    'RulePage1Section3': 'The Liberals win by enacting five Liberal Policies or killing Hitler. The Fascists win by enacting six Fascist Policies, or if Hitler is elected Chancellor after three Fascist Policies have been enacted.',
    'RulePage1Section4': 'Whenever a Fascist Policy is enacted, the government becomes more powerful, and the President is granted a single-use power which must be used before the next round can begin. It doesn’t matter what team the President is on; in fact, even Liberal players might be tempted to enact a Fascist Policy to gain new powers.',
    'Goal': 'Goal',
    'RulePage2Section1': 'Every player has a secret identity as a member of either the Liberal team or the Fascist team. Players on the Liberal team win if either:',
    'RulePage2Section2': '• Five Liberal Policies are enacted.',
    'Or': 'Or',
    'RulePage2Section3': '• Hitler is assassinated.',
    'RulePage2Section4': 'Players on the Fascist team win if either:',
    'RulePage2Section5': '• Six Fascist Policies are enacted.',
    'RulePage2Section6': '• Hitler is elected Chancellor any time after the third Fascist Policy has been enacted.',
    'Game Contents': 'Game Contents',
    'RulePage2Section7': '• 17 ... Policy tiles  (6 Liberal, 11 Fascist)',
    'RulePage2Section8': '• Secret Role cards',
    'RulePage2Section9': '• Party Membership cards',
    'RulePage2Section10': '• Ja! Ballot cards',
    'RulePage2Section11': '• Nein Ballot cards',
    'RulePage2Section12': '• Election Tracker marker',
    'RulePage2Section13': '• Draw pile card',
    'RulePage2Section14': '• Discard pile card',
    'RulePage2Section15': '• Liberal/Fascist board',
    'RulePage2Section16': '• President placard',
    'RulePage2Section17': '• Chancellor placard',
    'Gameplay': 'Gameplay',
    'RulePage3Section1': 'Secret Hitler is played in rounds. Each round has an Election to form a government, a Legislative Session to enact a new Policy, and an Executive Action to exercise governmental power.',
    'Election': 'Election',
    'RulePage3Section2': '1. Pass the Presidential Candidacy.',
    'RulePage3Section3': 'At the beginning of a new round, the President placard moves clockwise to the next player, who is the new Presidential Candidate.',
    'RulePage3Section4': '2. Nominate a Chancellor.',
    'RulePage3Section5': 'The Presidential Candidate chooses a Chancellor Candidate by passing the Chancellor placard to any other eligible player. The Presidential Candidate is free to discuss Chancellor options with the table to build consensus and make it more likely the Government gets elected.',
    'Eligibility': 'Eligibility',
    'RulePage3Section6': 'The last elected President and Chancellor are “term-limited,” and ineligible to be nominated as Chancellor Candidate.',
    'On Eligibility': 'On Eligibility',
    'RulePage3Section7': '• Term limits apply to the President and Chancellor who were last elected, not to the last pair nominated.',
    'RulePage3Section8': '• Term limits only affect nominations to the Chancellorship; anyone can be President, even someone who was just Chancellor.',
    'RulePage3Section9': '• If there are only five players left in the game, only the last elected Chancellor is ineligible to be Chancellor Candidate; the last President may be nominated.',
    'RulePage3Section10': '• There are some other rules that affect eligibility in specific ways: the Veto Power and the Election Tracker. You don’t need to worry about those yet, and we’ll talk about each one in its relevant section.',
    'RulePage4Section1': '3. Vote on the government',
    'RulePage4Section2': 'Once the Presidential Candidate has chosen an eligible Chancellor Candidate, players may discuss the proposed government until everyone is ready to vote. Every player, including the Candidates, votes on the proposed government. Once everyone is ready to vote, reveal your Ballot cards simultaneously so that everyone’s vote is public.',
    'RulePage4Section3': 'If the vote is a tie, or if a majority of players votes no: The vote fails. The Presidential Candidate misses this chance to be elected, and the President placard moves clockwise to the next player. The Election Tracker is advanced by one Election.',
    'Election Tracker': 'Election Tracker',
    'RulePage4Section4': 'If the group rejects three governments in a row, the country is thrown into chaos. Immediately reveal the Policy on top of the Policy deck and enact it. Any power granted by this Policy is ignored, but the Election Tracker resets, and existing term-limits are forgotten. All players become eligible to hold the office of Chancellor for the next Election.',
    'RulePage4Section5': 'Any time a new Policy tile is played face-up, the Election Tracker is reset, whether it was enacted by an elected government or enacted by the frustrated populace.',
    'About lying': 'About lying',
    'RulePage4Section6': 'Often, some players learn things that the rest of the players don’t know, like when the President and Chancellor get to see Policy tiles, or when a President uses the Investigate power to see someone’s Party Membership card. You can always lie about hidden knowledge in Secret Hitler. The only time players MUST tell the truth is in gameending, Hitler-related scenarios: a player who is Hitler must say so if assassinated or if elected Chancellor after three Fascist Policies have been enacted.',
    'RulePage4Section7': 'If there are fewer than three tiles remaining in the Policy deck at the end of a round, they will be shuffled.',
    'RulePage4Section8': 'If the government enacted a Fascist Policy that covered up a Presidential Power, the sitting President gets to use that power. Proceed to the Executive Action.',
    'RulePage4Section9': 'If the government enacted a Liberal Policy or a Fascist Policy that grants no Presidential Power, begin a new round with a new Election.',
    'Executive Action': 'Executive Action',
    'RulePage5Section1': 'If the newly-enacted Fascist Policy grants a Presidential Power, the President must use it before the next round can begin. Before using a power, the President is free to discuss the issue with other players, but ultimately the President gets to decide how and when the power is used. Gameplay cannot continue until the President uses the power. Presidential Powers are used only once; they don’t stack or roll over to future turns.',
    'Presidential Powers': 'Presidential Powers',
    'Investigate Loyalty': 'Investigate Loyalty',
    'RulePage5Section2': 'The President chooses a player to investigate. Investigated players should hand their Party Membership card (not Secret Role card!) to the President, who checks the player’s loyalty in secret and then returns the card to the player. The President may share (or lie about!) the results of their investigation at their discretion. No player may be investigated twice in the same game.',
    'Call Special Election': 'Call Special Election',
    'RulePage5Section3': 'The President chooses any other player at the table to be the next Presidential Candidate by passing that player the President placard. Any player can become President—even players that are term-limited. The new President nominates an eligible player as Chancellor Candidate and the Election proceeds as usual.',
    'RulePage5Section4': 'A Special Election does not skip any players. After a Special Election, the President placard returns to the left of the President who enacted the Special Election.',
    'RulePage5Section5': 'If the President passes the presidency to the next player in the rotation, that player would get to run for President twice in a row: once for the Special Election and once for their normal shift in the Presidential rotation.',
    'Policy Peek': 'Policy Peek',
    'RulePage5Section6': 'The President secretly looks at the top three tiles in the Policy deck and then returns them to the top of the deck without changing the order.',
    'Execution': 'Execution',
    'RulePage5Section7': 'The President executes one player at the table by saying “I formally execute [player name].” If that player is Hitler, the game ends in a Liberal victory. If the executed player is not Hitler, the table should not learn whether a Fascist or a Liberal has been killed; players must try to work out for themselves the new table balance. Executed players are removed from the game and may not speak, vote, or run for office.',
    'Veto Power': 'Veto Power',
    'RulePage6Section1': 'The Veto Power is a special rule that comes into effect after five Fascist Policies have been enacted. For all Legislative Sessions after the fifth Fascist Policy is enacted, the Executive branch gains a permanent new ability to discard all three Policy tiles if both the Chancellor and President agree.',
    'RulePage6Section2': 'The President draws three Policy tiles, discards one, and passes the remaining two to the Chancellor as usual. Then Chancellor may, instead of enacting either Policy, say “I wish to veto this agenda.” If the President consents by saying, “I agree to the veto,” both Policies are discarded and the President placard passes to the left as usual. If the President does not consent, the Chancellor must enact a Policy as normal.',
    'RulePage6Section3': 'Each use of the Veto Power represents an inactive government and advances the Election Tracker by one.',
    'Strategy Notes': 'Strategy Notes',
    'RulePage7Section1': '• Everyone should claim to be a Liberal. Since the Liberal team has a voting majority, it can easily shut out any player claiming to be a Fascist. As a Fascist, there is no advantage to outing yourself to the majority. Additionally, Liberals should usually tell the truth. Liberals are trying to figure out the game like a puzzle, so lying can put their team at a significant disadvantage.',
    'RulePage7Section2': '• If this is your first time playing Hitler, just remember: be as Liberal as possible. Enact Liberal Policies. Vote for Liberal governments. Kiss babies. Trust your fellow Fascists to create opportunities for you to enact Liberal Policies and to advance Fascism on their turns. The Fascists win by subtly manipulating the table and waiting for the right cover to enact Fascist Policies, not by overtly playing as evil.',
    'RulePage7Section3': '• Liberals frequently benefit from slowing play down and discussing the available information. Fascists frequently benefit from rushing votes and creating confusion.',
    'RulePage7Section4': '• Fascists most often win by electing Hitler, not by enacting six Policies! Electing Hitler isn’t an optional or secondary win condition, it’s the core of a successful Fascist strategy. Hitler should always play as a Liberal, and should generally avoid lying or getting into fights and disagreements with other players. When the time comes, Hitler needs the Liberals’ trust to get elected. Even if Hitler isn’t ultimately elected, the distrust sown among Liberals is key to getting Fascists elected late in the game.',
    'RulePage7Section5': '• Ask other players to explain why they took an action. This is especially important with Presidential Powers—in fact, ask ahead of time whom a candidate is thinking of investigating/appointing/assassinating.',
    'RulePage7Section6': '• If a Fascist Policy comes up, there are only three possible culprits: The President, the Chancellor, or the Policy Deck. Try to figure out who (or what!) put you in this position.',

    // New game & join game page
    'Number of players': 'Number of players',
    'Room id': 'Room id',
    'Enter the room id': 'Enter the room id',
    'Room password': 'Room password',
    'Enter the room password': 'Enter the room password',
    'Join': 'Join',
    'Search game session': 'Search game session',
    'There is currently an active game': 'There is currently an active game',

    'Waiting room': 'Waiting room',
    'NO': 'NO',
    'Waiting room QR-Code': 'Waiting room QR-Code',
    'Players': 'Players',
    'Wrong password': 'Wrong password',
    'Wrong Id': 'Falsche Id',
    'Start game': 'Start game',
    'Too few players': 'Too few players',
    'The waiting room is full': 'The waiting room is full',

    // Roles Page
    'Your role': 'Your Role',
    'Your team': 'Your team',
    'You don\'t know any other team member': 'You don\'t know any other team member',

    // Board overview page
    'Draw 3 cards': 'Draw 3 cards',
    'Discard a card': 'Discard a card',
    'The president discards a card': 'The president discards a card',
    'Play a card': 'Play a card',
    'The chancellor plays a card': 'The chancellor plays a card',
    'Examine the top 3 cards': 'Examine the top 3 cards',
    'The president examines the top 3 cards': 'The president examines the top 3 cards',

    // Player and election Page
    'The president picks a chancellor candidate': 'The president picks a chancellor candidate',
    'Pick a chancellor candidate': 'Pick a chancellor candidate',
    'Vote for or against': 'Vote for or against',
    'Wait for the other player\'s votes': 'Wait for the other player\'s votes',
    'The voting was successful': 'The voting was successful',
    'The voting was not successful': 'The voting was not successful',
    'Investigate a player\'s indentity card': 'Investigate a player\'s indentity card',
    'The president investigates a player\'s indentity card': 'The president investigates a player\'s indentity card',
    'was investigated': 'was investigated',
    'Pick the next president': 'Pick the next president',
    'The president picks the next president': 'The president picks the next president',
    'Shoot a player': 'Shoot a player',
    'The president shoots a player': 'The president shoots a player',
    'was shot': 'was shot',

    'The liberals won': 'The liberals won!',
    'The fascists won': 'The fascists won!',

    // Game room settings
    'Leave': 'Leave',
  };

  static const Map<String, dynamic> DE = {
    'Login': 'Anmelden',
    'Register': 'Registrieren',
    'E-Mail': 'E-Mail',
    'Password': 'Passwort',
    'Enter your e-mail': 'Gebe deine E-Mail ein',
    'Enter your password': 'Gebe dein Password ein',
    'Forgot password?': 'Passwort vergessen?',
    'Continue as guest': 'Weiter als Gast',
    'OR CONTINUE WITH': 'ODER WEITER MIT',
    'No Account yet?': 'Noch keinen Account?',
    'Confirm password': 'Passwort bestätigen',
    'Confirm your password': 'Bestätige dein Passwort',
    'Already have an account?': 'Schon einen Account?',
    'Reset password': 'Passwort zurücksetzen',
    'Enter your e-mail to reset your password.': 'Gebe deine Email ein, um dein Passwort zurückzusetzen.',
    'Continue': 'Weiter',
    'New password': 'Neues Passwort',
    'Enter your new password': 'Gebe dein neues Passwort ein',
    'Save': 'Speichern',
    'New Game': 'Neues Spiel',
    'Join Game': 'Spiel beitreten',
    'Rules': 'Regeln',
    'User data': 'Benutzerdaten',
    'Statistics': 'Statistik',
    'Logout': 'Abmelden',
    'Settings': 'Einstellungen',
    'Language': 'Sprache',
    'Design': 'Design',
    'Imprint': 'Impressum',
    'Choose your language.': 'Wähle deine Sprache aus.',
    'German': 'Deutsch',
    'English': 'Englisch',
    'Choose theme.': 'Wähle aus, ob du ein liberales Thema oder ein faschistisches Thema haben möchtest.',
    'Fascist': 'Faschist',
    'Liberal': 'Liberal',
    'Name': 'Name',
    'Enter your name': 'Gebe deinen Namen ein',
    'Change password': 'Passwort ändern',
    'Delete account': 'Konto löschen',
    'Old password': 'Altes Passwort',
    'Enter your old password': 'Gebe dein altes Passwort ein',
    'Delete': 'Löschen',
    'Please enter "DELETE"': 'Bitte gebe “LÖSCHEN” in das Textfeld ein um deinen Account zu löschen.',
    'Enter "DELETE"': 'Gebe "LÖSCHEN" ein',
    'Confirm E-Mail': 'E-Mail bestätigen',
    'Send confirmation e-mail': 'Bestätigungsmail senden',
    'Confirm your current email': 'Bitte bestätige deine aktuelle E-mail, oder ändere sie.',
    'Continue without confirmation': 'Ohne Bestätigung fortfahren',
    'OR': 'ODER',
    'Confirmation email sent': 'Bestätigungsmail gesendet.',
    'Confirmation email could not be sent': 'Bestätigungsmail konnte nicht gesendet werden.',
    'Email already sent': 'E-Mail wurde schon gesendet.',
    'Passwords do not match': 'Passwörter stimmen nicht überein',
    'Invalid email format': 'Ungültiges E-mail Format',
    'Less than 8 characters': 'Weniger als 8 Zeichen',
    'More than 256 characters': 'More than 256 characters',
    'Field is empty': 'Feld ist leer',
    'Invalid credentials': 'Ungültige Daten',

    // Rules Pages
    'RulePage1Section1': 'Wir schreiben das Jahr 1932 und befinden uns in Deutschland vor dem Zweiten Weltkrieg. In Secret Hitler sind die Spieler deutsche Politiker, die versuchen, eine fragile liberale Regierung zusammenzuhalten und die wachsende Welle des Faschismus einzudämmen. Aber Vorsicht, es gibt heimliche Faschisten unter ihnen, und ein Spieler ist Hitler.',
    'Overview': 'Übersicht',
    'RulePage1Section2': 'Zu Beginn des Spiels wird jedem Spieler heimlich eine von drei Rollen zugewiesen: Liberaler, Faschist oder Hitler. Die Liberalen haben die Mehrheit, aber sie wissen nicht, wer die anderen sind; Faschisten müssen auf Geheimhaltung und Sabotage zurückgreifen, um ihre Ziele zu erreichen. Hitler spielt für das faschistische Team und die Faschisten kennen Hitlers Identität von Anfang an, aber Hitler kennt die Faschisten nicht und muss daran arbeiten, sie herauszufinden.',
    'RulePage1Section3': 'Die Liberalen gewinnen, indem sie fünf liberale Richtlinien erlassen oder Hitler töten. Die Faschisten gewinnen, wenn sie sechs faschistische Richtlinien erlassen, oder wenn Hitler zum Reichskanzler gewählt wird, nachdem drei faschistische Richtlinien erlassen wurden.',
    'RulePage1Section4': 'Immer wenn eine faschistische Politik umgesetzt wird, wird die Regierung mächtiger und der Präsident erhält eine einmalige Macht, die er nutzen muss, bevor die nächste Runde beginnen kann. Es spielt keine Rolle, in welchem Team der Präsident ist; Tatsächlich könnten selbst liberale Akteure versucht sein, eine faschistische Politik zu verfolgen, um neue Macht zu erlangen.',
    'Goal': 'Ziel',
    'RulePage2Section1': 'Jeder Spieler hat eine geheime Identität als Mitglied des liberalen oder des faschistischen Teams. Spieler im liberalen Team gewinnen, wenn:',
    'RulePage2Section2': 'Fünf liberal Richtlinien erlassen werden.',
    'Or': 'Oder',
    'RulePage2Section3': 'Hitler ermordet wird.',
    'RulePage2Section4': 'Spieler des faschistischen Teams gewinnen, wenn:',
    'RulePage2Section5': 'Sechs liberal Richtlinien erlassen werden.',
    'RulePage2Section6': 'Hitler als Kanzler gewählt wird, nachdem mindestens 3 faschistische Richtlinien erlassen wurden.',
    'Game Contents': 'Spielinhalte',
    'RulePage2Section7': '17 ... Policy Karten  (6 Liberal, 11 Faschistisch)',
    'RulePage2Section8': 'Secret Role Karten',
    'RulePage2Section9': 'Party Membership Karten',
    'RulePage2Section10': 'Ja! Abstimmungskarten',
    'RulePage2Section11': 'Nein Abstimmungskarten',
    'RulePage2Section12': 'Wahl-Tracker-Marker',
    'RulePage2Section13': 'Ziehstapel',
    'RulePage2Section14': 'Ablegestarpel',
    'RulePage2Section15': 'Liberal/Fascist board',
    'RulePage2Section16': 'Präsidentenschild',
    'RulePage2Section17': 'Kanzlerschild',
    'Gameplay': 'Spielweise',
    'RulePage3Section1': 'Secret Hitler wird in Runden gespielt. In jeder Runde gibt es eine Wahl zur Bildung einer Regierung, eine Legislativsitzung zur Verabschiedung einer neuen Richtlinie und eine Exekutivaktion zur Ausübung der Regierungsgewalt.',
    'Election': 'Wahl',
    'RulePage3Section2': '1. Bestehe die Präsidentschaftskandidatur.',
    'RulePage3Section3': 'Zu Beginn einer neuen Runde wandert das Präsidentenplakat im Uhrzeigersinn zum nächsten Spieler, der der neue Präsidentschaftskandidat ist.',
    'RulePage3Section4': '2. Nominiere einen Kanzler.',
    'RulePage3Section5': 'Der Präsidentschaftskandidat wählt einen Kanzlerkandidaten aus, indem er das Kanzlerschild an einen anderen berechtigten Spieler weitergibt. Dem Präsidentschaftskandidaten steht es frei, mit dem Tisch Kanzleroptionen zu besprechen, um einen Konsens zu erzielen und die Wahrscheinlichkeit zu erhöhen, dass die Regierung gewählt wird.',
    'Eligibility': 'Teilnahmeberechtigung',
    'RulePage3Section6': 'Der zuletzt gewählte Präsident und Kanzler ist „befristet“ und kann nicht als Kanzlerkandidat nominiert werden.',
    'On Eligibility': 'Zur Berechtigung',
    'RulePage3Section7': '• Die Amtszeitbeschränkung gilt für den zuletzt gewählten Präsidenten und den zuletzt gewählten Kanzler, nicht für das zuletzt nominierte Paar.',
    'RulePage3Section8': '• Amtszeitbeschränkungen betreffen nur Nominierungen für das Kanzleramt; Jeder kann Präsident sein, sogar jemand, der zuvor Kanzler war.',
    'RulePage3Section9': '• Wenn nur noch fünf Spieler im Spiel sind, ist nur der zuletzt gewählte Kanzler nicht als Kanzlerkandidat zugelassen; der letzte Präsident kann nominiert werden.',
    'RulePage3Section10': '• Es gibt einige andere Regeln, die sich auf bestimmte Weise auf die Wahlberechtigung auswirken: das Vetorecht und den Wahl-Tracker. Darüber musst du dir noch keine Sorgen machen, und wir werden im entsprechenden Abschnitt auf jeden einzelnen Punkt eingehen.',
    'RulePage4Section1': '3. Abstimmung über die Regierung  ',
    'RulePage4Section2': 'Sobald der Präsidentschaftskandidat einen geeigneten Kanzlerkandidaten ausgewählt hat, können die Spieler über die vorgeschlagene Regierung diskutieren, bis alle zur Abstimmung bereit sind. Jeder Spieler, einschließlich der Kandidaten, stimmt über die vorgeschlagene Regierung ab. Sobald alle zur Abstimmung bereit sind, decken Sie gleichzeitig Ihre Stimmzettel auf, sodass die Abstimmung aller öffentlich ist.',
    'RulePage4Section3': 'Bei Stimmengleichheit oder wenn die Mehrheit der Spieler mit „Nein“ stimmt: Die Abstimmung schlägt fehl. Der Präsidentschaftskandidat verpasst diese Chance, gewählt zu werden, und das Präsidentenplakat wandert im Uhrzeigersinn zum nächsten Spieler. Der Wahl-Tracker wird um eine Wahl vorgerückt.',
    'Election Tracker': 'Wahl-Tracker',
    'RulePage4Section4': 'Lehnt die Gruppe drei Regierungen hintereinander ab, stürzt das Land ins Chaos. Decke die oberste Politikkarte sofort auf und setze sie in Kraft. Jegliche durch diese Richtlinie gewährte Befugnis wird ignoriert, der Wahl-Tracker wird jedoch zurückgesetzt und bestehende Amtszeitbeschränkungen werden vergessen. Alle Spieler sind berechtigt, bei der nächsten Wahl das Amt des Kanzlers zu bekleiden.',
    'RulePage4Section5': 'Jedes Mal, wenn eine neue Politikkarte offen ausgespielt wird, wird der Wahl-Tracker zurückgesetzt, unabhängig davon, ob es von einer gewählten Regierung oder von der frustrierten Bevölkerung erlassen wurde.',
    'About lying': 'Übers lügen',
    'RulePage4Section6': 'Oft erfahren einige Spieler Dinge, die der Rest der Spieler nicht weiß, etwa wenn der Präsident und der Kanzler Politikkarten sehen oder wenn ein Präsident die Fähigkeit „Instigate Loyalty“ nutzt, um die Parteimitgliedskarte einer anderen Person zu sehen. Über verborgenes Wissen in Secret Hitler kann man jederzeit lügen. Das einzige Mal, dass Spieler die Wahrheit sagen MÜSSEN, sind Hitler-bezogene Szenarien am Ende des Spiels: Ein Spieler, der Hitler ist, muss dies sagen, wenn er ermordet wird oder zum Kanzler gewählt wird, nachdem drei faschistische Richtlinien erlassen wurden.',
    'RulePage4Section7': 'Sollten am Ende einer Runde weniger als drei Karten im Policy-Stapel verbleiben, werden diese gemischt.',
    'RulePage4Section8': 'Wenn die Regierung eine faschistische Politik erlassen hat, und eine Exekutiventscheidung überdeckt wird, führt der aktuelle Präsident diese aus.',
    'RulePage4Section9': 'Wenn die Regierung eine liberale oder faschistische Politik verabschiedet hat, ohne eine Exekutiventscheidung, beginnt eine neue Runde mit einer neuen Wahl.',
    'Executive Action': 'EXEKUTIVENTSCHEIDUNG',
    'RulePage5Section1': 'Wenn die neu in Kraft getretene faschistische Politik eine Exekutiventscheidung gewährt, muss der Präsident diese nutzen, bevor die nächste Runde beginnen kann. Bevor er eine Macht ausübt, steht es dem Präsidenten frei, das Thema mit anderen Spielern zu besprechen, aber letztendlich entscheidet der Präsident, wie und wann die Macht genutzt wird. Das Spiel kann nicht fortgesetzt werden, bis der Präsident die Macht nutzt. Die Befugnisse des Präsidenten werden nur einmal genutzt; Sie können nicht gestapelt oder in zukünftige Züge übertragen werden.',
    'Presidential Powers': 'Befugnisse des Präsidenten',
    'Investigate Loyalty': 'Investigate Loyalty',
    'RulePage5Section2': 'Der Präsident wählt einen Spieler zur Untersuchung aus. Untersuchte Spieler sollten ihre Party Menbership Karte (nicht die Secret Role Karte!) dem Präsidenten übergeben, der im Geheimen die Loyalität des Spielers überprüft und die Karte dann an den Spieler zurückgibt. Der Präsident kann die Ergebnisse seiner Untersuchung nach eigenem Ermessen mitteilen (oder darüber lügen!). Kein Spieler darf im selben Spiel zweimal untersucht werden.',
    'Call Special Election': 'Call Special Election',
    'RulePage5Section3': 'Der Präsident wählt einen beliebigen anderen Spieler am Tisch zum nächsten Präsidentschaftskandidaten, indem er diesem Spieler das Präsidentenplakat überreicht. Jeder Spieler kann Präsident werden – auch Spieler mit befristeter Amtszeit. Der neue Präsident nominiert einen geeigneten Spieler als Kanzlerkandidaten und die Wahl verläuft wie gewohnt.',
    'RulePage5Section4': 'Bei einer Sonderwahl werden keine Spieler übersprungen. Nach einer Sonderwahl wird die alte Reihenfolge für die Präsidenten beibehalten.',
    'RulePage5Section5': 'Wenn der Präsident die Präsidentschaft an den nächsten Spieler in der Rotation übergibt, könnte dieser Spieler zweimal hintereinander für das Amt des Präsidenten kandidieren: einmal für die Sonderwahl und einmal für seine normale Schicht in der Präsidentenrotation.',
    'Policy Peek': 'Policy Peek',
    'RulePage5Section6': 'Der Präsident schaut sich heimlich die obersten drei Karten des Policy-Stapels an und legt sie dann, ohne die Reihenfolge zu ändern, oben auf den Stapel zurück.',
    'Execution': 'Execution',
    'RulePage5Section7': 'Der Präsident exekutiert einen Spieler am Tisch, indem er sagt: „Ich exekutiere [Name des Spielers] offiziell.“ Wenn dieser Spieler Hitler ist, endet das Spiel mit einem Sieg der Liberalen. Wenn der hingerichtete Spieler nicht Hitler ist, sollte der Tisch nicht erfahren, ob ein Faschist oder ein Liberaler getötet wurde; Die Spieler müssen versuchen, die neue Verteilung selbst herauszufinden. Hingerichtete Spieler werden aus dem Spiel entfernt und dürfen nicht sprechen, abstimmen oder für ein Amt kandidieren.',
    'Veto Power': 'Vetorecht',
    'RulePage6Section1': 'Das Vetorecht ist eine Sonderregel, die nach der Verabschiedung von fünf faschistischen Richtlinien in Kraft tritt. Für alle Legislativsitzungen nach Inkrafttreten der fünften faschistischen Politik erhält die Exekutive eine permanente neue Möglichkeit, alle drei Politikkarten abzuwerfen, wenn sowohl der Kanzler als auch der Präsident zustimmen.',
    'RulePage6Section2': 'Der Präsident zieht drei Politikkarten, wirft eine ab und gibt die restlichen zwei wie üblich an den Kanzler weiter. Dann kann der Kanzler, anstatt eine der beiden Richtlinien zu verabschieden, sagen: „Ich möchte gegen diese Agenda ein Veto einlegen.“ Wenn der Präsident zustimmt, indem er sagt: „Ich stimme dem Veto zu“, werden beide Richtlinien verworfen und das Präsidentenplakat wird wie gewohnt nach links verschoben. Wenn der Präsident nicht zustimmt, muss der Kanzler wie üblich eine Richtlinie erlassen.',
    'RulePage6Section3': 'Jeder Einsatz des Vetorechts stellt eine inaktive Regierung dar und rückt den Wahl-Tracker um eins voran.',
    'Strategy Notes': 'Strategietipps',
    'RulePage7Section1': '• Jeder sollte behaupten, ein Liberaler zu sein. Da das liberale Team über eine Stimmenmehrheit verfügt, kann es problemlos jeden Spieler ausschließen, der behauptet, ein Faschist zu sein. Als Faschist hat es keinen Vorteil, sich vor der Mehrheit zu outen. Darüber hinaus sollten Liberale in der Regel die Wahrheit sagen. Die Liberalen versuchen, das Spiel wie ein Puzzle zu verstehen, daher kann Lügen ihrer Mannschaft einen erheblichen Nachteil verschaffen.',
    'RulePage7Section2': '• Wenn du zum ersten Mal Hitler spielst, denke daran: Sei so liberal wie möglich. Verabschiedung einer liberalen Politik. Stimmen für liberale Regierungen. Küsse Babys. Vertrauen  darauf, dass deine Faschistenkollegen dir Gelegenheiten bieten, liberale Richtlinien umzusetzen und den Faschismus in ihren Reihen voranzutreiben. Die Faschisten gewinnen, indem sie den Tisch subtil manipulieren und auf die richtige Tarnung warten, um faschistische Richtlinien durchzusetzen, und nicht dadurch, dass sie sich offen als böse aufspielen.',
    'RulePage7Section3': '• Liberale profitieren häufig davon, das Spiel langsamer anzugehen und die verfügbaren Informationen zu diskutieren. Faschisten profitieren häufig von überstürzten Abstimmungen und der Schaffung von Verwirrung.',
    'RulePage7Section4': '• Faschisten gewinnen meistens durch die Wahl Hitlers, nicht durch die Verabschiedung von sechs Richtlinien! Die Wahl Hitlers ist keine optionale oder sekundäre Siegbedingung, sondern der Kern einer erfolgreichen faschistischen Strategie. Hitler sollte immer als Liberaler spielen und generell vermeiden, zu lügen oder sich mit anderen Spielern auf Streit und Meinungsverschiedenheiten einzulassen. Wenn es soweit ist, braucht Hitler das Vertrauen der Liberalen, um gewählt zu werden. Selbst wenn Hitler letztendlich nicht gewählt wird, ist das unter den Liberalen gesäte Misstrauen der Schlüssel dazu, dass die Faschisten spät im Spiel gewählt werden.',
    'RulePage7Section5': '• Frage Spieler, zu erklären, warum sie eine Aktion ausgeführt haben. Dies ist besonders wichtig, wenn es um die Befugnisse des Präsidenten geht. Erkundige dich im Voraus, wen ein Kandidat untersuchen, ihn ernennen oder ermorden möchte.',
    'RulePage7Section6': '• Wenn eine faschistische Politik auftaucht, gibt es nur drei mögliche Schuldige: den Präsidenten, den Kanzler oder das Policy Deck. Versuchen Sie herauszufinden, wer (oder was!) Sie in diese Position gebracht hat.',

    // New game & join game page
    'Number of players': 'Spieleranzahl',
    'Room id': 'Raum-Id',
    'Enter the room id': 'Gebe die Raum-Id ein',
    'Room password': 'Raumpasswort',
    'Enter the room password': 'Gebe das Raumpasswort ein',
    'Join': 'Beitreten',
    'Search game session': 'Spielsitzung suchen',
    'There is currently an active game': 'Es gibt gerade ein aktives Spiel',

    'Waiting room': 'Warteraum',
    'NO': 'NR',
    'Waiting room QR-Code': 'Warteraum QR-Code',
    'Players': 'Spieler',
    'Wrong password': 'Falsches Passwort',
    'Wrong Id': 'Falsche Id',
    'Start game': 'Spiel starten',
    'Too few players': 'Zu wenig Spieler',
    'The waiting room is full': 'Der Warteraum ist voll',

    // Roles Page
    'Your role': 'Deine Rolle',
    'Your team': 'Dein team',
    'You don\'t know any other team member': 'Du kennst keinen anderen aus deinem Team',

    // Board overview page
    'Draw 3 cards': 'Ziehe 3 Karten',
    'Discard a card': 'Lege eine Karte ab',
    'The president discards a card': 'Der Präsident legt eine Karte ab',
    'Play a card': 'Spiele eine Karte',
    'The chancellor plays a card': 'Der Kanzler spielt eine Karte',
    'Examine the top 3 cards': 'Überprüfe die obersten 3 Karten',
    'The president examines the top 3 cards': 'Der Präsident überprüft die obersten 3 Karten',

    // Player and election Page
    'The president picks a chancellor candidate': 'Der Präsident sucht einen Kanzlerkandidaten aus',
    'Pick a chancellor candidate': 'Suche einen Kanzlerkandidaten aus',
    'Vote for or against': 'Wähle für oder gegen',
    'Wait for the other player\'s votes': 'Warte auf die Stimmen der anderen Spieler',
    'The voting was successful': 'Die Wahl war erfolgreich',
    'The voting was not successful': 'Die Wahl war nicht erfolgreich',
    'Investigate a player\'s indentity card': 'Untersuche die Indentität von einem Spieler',
    'The president investigates a player\'s indentity card': 'Der Präsident untersucht die Indentität eines Spielers',
    'was investigated': 'wurde untersucht',
    'Pick the next president': 'Suche den nächsten Präsidenten aus',
    'The president picks the next president': 'Der Präsident sucht den nächsten Präsidenten aus',
    'Shoot a player': 'Erschieße einen Spieler',
    'The president shoots a player': 'Der Präsident erschießt einen Spieler',
    'was shot': 'wurde erschossen',

    'The liberals won': 'Die Liberalen haben gewonnen!',
    'The fascists won': 'Die Faschisten haben gewonnen!',

    // Game room settings
    'Leave': 'Verlassen',
  };
}