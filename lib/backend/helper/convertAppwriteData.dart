// author: Lukas Horst

// Function to convert a dynamic list from appwrite into a string list if possible
List<String> convertDynamicToStringList(List<dynamic> dynamicList) {
  List<String> stringList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      String stringValue = dynamicValue.toString();
      stringList.add(stringValue);
    } catch(e) {}
  }
  return stringList;
}

// Function to convert a dynamic list from appwrite into a int list if possible
List<int> convertDynamicToIntList(List<dynamic> dynamicList) {
  List<int> intList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      int intValue = dynamicValue as int;
      intList.add(intValue);
    } catch(e) {}
  }
  return intList;
}

// Function to convert a dynamic list from appwrite into a bool list if possible
List<bool> convertDynamicToBoolList(List<dynamic> dynamicList) {
  List<bool> boolList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      bool boolValue = dynamicValue as bool;
      boolList.add(boolValue);
    } catch(e) {}
  }
  return boolList;
}