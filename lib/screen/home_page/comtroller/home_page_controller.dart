import 'dart:convert';

import 'package:denomination/db/storage.dart';
import 'package:denomination/screen/history/model/model.dart';
import 'package:denomination/screen/home_page/view/home_page_view.dart';
import 'package:denomination/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController{

  final UiUtils uiUtils = UiUtils();
  final Storage storage = Storage();
  // final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();

  RxList list = [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1].obs;
  RxList<TextEditingController> inputControllers = <TextEditingController>[].obs;
  RxList<String> inputControllersText = <String>[].obs;

  RxList<String> total = <String>[].obs;

  RxInt totalSum = 0.obs;

  Rx<TextEditingController> remarkController = TextEditingController().obs;
  RxList<String> items = ["General 1", "General 2", "General 3", "General 4"].obs;
  RxString currentItem = "General 1".obs;

  RxBool updateDataValue = false.obs;

  ///Animation
  Rx<ScrollController> scrollControllerListView = ScrollController().obs;
  Rx<ScrollController> scrollControllerListViewBuilder = ScrollController().obs;

  RxDouble scrollOffset = 0.0.obs;
  RxBool showNewWidget = false.obs;
  RxBool listViewBuilderScrollingStart = false.obs;

  animation(){
    scrollControllerListView.value.addListener(_onScroll);
  }

  void _onScroll() {
    scrollOffset.value = scrollControllerListView.value.offset;
    showNewWidget.value = scrollOffset.value > 50.0;
  }


  @override
  void onInit() {
    super.onInit();
    animation();
    totalSum.value = 0;
    inputControllers.clear();
    total.clear();
    inputControllers.assignAll(List.generate(list.length, (index) => TextEditingController()));
    total.assignAll(List.generate(list.length, (index) => "0"));
  }

  @override
  void onClose() {
    for (var controller in inputControllers) {
      controller.dispose();
    }
    remarkController.value.clear();
    scrollControllerListView.value.dispose();
    Get.delete<HomePageController>();
    super.onClose();
  }

  @override
  void dispose() {
    remarkController.value.clear();
    scrollControllerListView.value.dispose();
    Get.delete<HomePageController>();
    super.dispose();
  }

  clearAll(){
    totalSum.value = 0;
    total.clear();
    total.assignAll(List.generate(list.length, (index) => "0"));

    inputControllers.assignAll(List.generate(list.length, (index) => TextEditingController()));

    remarkController.value.clear();
    currentItem.value = "General 1";
    updateDataValue.value = false;
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
    print(totalSum.value);
    update();
  }
  changeDropDownValue(value){
    currentItem.value = value;
    update();
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
      'file_name' : "${currentItem.value}",
      'remark' : "${remarkController.value.text}"
    };
    // Insert the new data at the beginning of the list (first position)
    body.insert(0, newData);

    // Save the updated list to storage
    await storage.save(key: "list", value: jsonEncode(body));
    clearAll();
  }

  editCalculation(){
    updateDataValue.value = true;
    ReadModel editData = ReadModel.fromJson(jsonDecode(Get.arguments["data"]));
    index.value = Get.arguments["index"];
    print(editData);
    // list.clear();
    // inputControllers.clear();
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

    remarkController.value.text = editData.remark!;

    changeDropDownValue(editData.fileName!);

    print(totalSum);
    print(total);
    print(inputControllers);
    update();
  }


  RxInt index = 0.obs;
  Future<void> updateData() async {
    RxList<ReadModel> readData = <ReadModel>[].obs;

    // Read the existing data from storage
    var jsonData = await storage.read(key: "list");

    if (jsonData != null) {
      var data = jsonDecode(jsonData);
      if (data is List) {
        readData.value = List<ReadModel>.from(
          data.map((item) => ReadModel.fromJson(item)),
        );
      }
    }

    if (index >= 0 && index < readData.length) {

      readData[index.value] = ReadModel(
        list: list,
        inputControllers: inputControllersText,
        total: total,
        totalSum: totalSum.value,
        dateTime: DateTime.now().toIso8601String(),
        fileName: currentItem.value,
        remark: remarkController.value.text,
      );


      await storage.save(
        key: "list",
        value: jsonEncode(readData.map((item) => item.toJson()).toList()),
      );


      clearAll();
    }
    Get.offAll(()=>HomePageView());
  }



}