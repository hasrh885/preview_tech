import 'dart:convert';

import 'package:denomination/db/storage.dart';
import 'package:denomination/screen/history/model/model.dart';
import 'package:denomination/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController{

  final UiUtils uiUtils = UiUtils();
  final Storage storage = Storage();
  final key = GlobalKey<ExpandableFabState>();

  RxList list = [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1].obs;
  RxList<TextEditingController> inputControllers = <TextEditingController>[].obs;
  RxList<String> inputControllersText = <String>[].obs;

  RxList<String> total = <String>[].obs;

  RxInt totalSum = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Rx<TextEditingController> remarkController = TextEditingController().obs;
  RxList<String> items = ["General 1", "General 2", "General 3", "General 4"].obs;
  RxString currentItem = "General 1".obs;



  final double maxHeaderHeight = 100;
  late ScrollController scrollController;
  double opacity = 1.0;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(updateHeaderState);

    totalSum.value = 0;
    inputControllers.clear();
    total.clear();
    inputControllers.assignAll(List.generate(list.length, (index) => TextEditingController()));
    total.assignAll(List.generate(list.length, (index) => "0"));
  }
  void onClose() {
    for (var controller in inputControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  clearAll(){
    totalSum.value = 0;
    total.clear();
    total.assignAll(List.generate(list.length, (index) => "0"));

    for (int i = 0; i < inputControllers.length; i++) {
      inputControllers[i].text = "";
    }

  }

  void updateHeaderState() {
    final offset = scrollController.offset;

    if (offset > 0 && offset <= maxHeaderHeight) {
      opacity = 1 - (offset / maxHeaderHeight).clamp(0, 1);
    } else if (offset > maxHeaderHeight) {
      opacity = 0;
    } else {
      opacity = 1;
    }
  }

  clearInput(index){
    total[index] = "0";
    inputControllers[index].clear();
  }

  extractText(){
    inputControllersText.clear();
    inputControllersText.value = inputControllers.map((controller) => controller.text).toList();
    print(inputControllersText);
  }

  updateValue(value, index){
    total[index] = uiUtils.inputFormater(value : uiUtils.stringToInt(value :value) * list[index]).toString();
    totalSumValue();

    update();
  }

  totalSumValue(){
    totalSum.value = total.fold(0, (acc, value) {
      int? parsedValue = int.tryParse(value.replaceAll(",", ""));
      return acc + (parsedValue ?? 0);
    });
    print(total);
  }

  storeData() async {
    extractText(); // Assuming this function collects all the text from controllers.

    // Read the existing data from storage
    var oldData = await storage.read(key: "list");

    // If there is existing data, decode it
    List<Map<String, dynamic>> body = [];
    if (oldData != null) {
      // Decode the existing data
      var decodedData = jsonDecode(oldData);

      // Check if the decoded data is a list or a map
      if (decodedData is List) {
        // If it's a list, directly cast it
        body = List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        // If it's a map, wrap it in a list and cast to the correct type
        body = [decodedData as Map<String, dynamic>];
      }
    }

    // Create the new data entry
    Map<String, dynamic> newData = {
      'list': list,
      'inputControllers': inputControllersText,
      'total': total,
      'totalSum': totalSum.value,
      'date_time': DateTime.now().toIso8601String(),
    };
    // Insert the new data at the beginning of the list (first position)
    body.insert(0, newData);

    // Save the updated list to storage
    await storage.save(key: "list", value: jsonEncode(body));
  }

  changeDropDownValue(value){
    currentItem.value = value;
    update();
  }


  editCalculation(){
    ReadModel editData = ReadModel.fromJson(jsonDecode(Get.arguments["data"]));
    print(editData);
    // list.clear();
    inputControllers.clear();
    total.clear();
    totalSum.value = 0;

    // list.insertAll(editData.list!.length, editData.list!.where((element) => element is int).cast<int>());

    inputControllers.assignAll(List.generate(list.length, (index) => TextEditingController()));

    for (int i = 0; i < editData.inputControllers!.length; i++) {
      inputControllers[i].text = editData.inputControllers![i];
    }


    for (int i = 0; i < editData.total!.length; i++) {
      total.add(editData.total![i]);
    }
    totalSum.value = editData.totalSum!;

    print(totalSum);
    print(total);
    print(inputControllers);
    update();
  }

}