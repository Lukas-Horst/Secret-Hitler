// author: Lukas Horst

import 'package:flutter/material.dart';

// Function to check if a dialog is currently open
isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;