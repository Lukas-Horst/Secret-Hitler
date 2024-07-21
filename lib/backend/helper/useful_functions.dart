// author: Lukas Horst

import 'package:flutter/material.dart';

// Function to check if a dialog is currently open
isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

// Function to open a new page
void newPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

// Function to close as many pages as the given amount
void closePage(BuildContext context, int amount) {
  for (int i=0; i < amount; i++) {
    Navigator.of(context).pop();
  }
}