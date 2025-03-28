// author: Lukas Horst

import 'dart:convert';

// Method to switch the position of 2 elements in a list
void switchListElements(List<dynamic> dynamicList, int index1, int index2) {
  dynamic temp = dynamicList[index1];
  dynamicList[index1] = dynamicList[index2];
  dynamicList[index2] = temp;
}

List<dynamic> copyList(List<dynamic> originalList) {
  return json.decode(json.encode(originalList));
}