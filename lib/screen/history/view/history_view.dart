import 'package:denomination/component/custom_slidable_list.dart';
import 'package:denomination/resources/color.dart';
import 'package:denomination/screen/history/controller/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({super.key});

  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    controller.fetchData();
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "History",
          style: TextStyle(color: white, fontSize: 22),
        ),
      ),
      body: CustomSlidAbleList(
        readData: controller.readData,
        onPressedDelete: (index) {
          controller.delete(index: index);
        },
        onPressedEdit: (index) {
          controller.edit(index: index);
        },
        onPressedShare: (index) {
          controller.shareData(index: index);
        },
      ),
    );
  }
}
