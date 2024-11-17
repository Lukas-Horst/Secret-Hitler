// author: Lukas Horst

// Class to deactivate the function to send a mail
class SendMailTimeout {
  bool isActivated = false;
  int activateAmount = 0;
  int timeout = 0;  // The timeout in minutes

  Future<void> activateTimeout() async {
    if (!isActivated) {
      isActivated = true;
      if (activateAmount == 0) {
        timeout = 2;
      } else if (activateAmount == 1) {
        timeout = 5;
      } else if (activateAmount == 2) {
        timeout = 8;
      } else {
        timeout = 10;
      }
      activateAmount++;
      while (timeout > 0) {
        await Future.delayed(const Duration(minutes: 1));
        timeout--;
      }
      isActivated = false;
    }
  }

}