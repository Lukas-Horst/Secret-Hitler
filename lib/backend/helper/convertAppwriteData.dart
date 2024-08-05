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