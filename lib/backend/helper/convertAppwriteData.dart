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