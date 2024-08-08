// author: Lukas Horst

// Function to get the next player who is alive for the next regular president
int getNextPresident(int currentNextPresident, List<int> killedPlayers) {
  currentNextPresident++;
  while (true) {
    if (killedPlayers.contains(currentNextPresident)) {
      currentNextPresident++;
    } else {
      return currentNextPresident;
    }
  }
}