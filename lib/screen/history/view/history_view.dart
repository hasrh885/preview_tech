import 'package:denomination/component/custom_slidable_list.dart';
import 'package:denomination/resources/color.dart';
import 'package:denomination/screen/history/controller/history_controller.dart';
import 'package:denomination/screen/home_page/comtroller/home_page_controller.dart';
import 'package:denomination/screen/home_page/view/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({super.key});

  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    controller.fetchData();
    return SafeArea(
        child: Scaffold(
            backgroundColor: black,
            appBar: AppBar(
              backgroundColor: black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: white),
                onPressed: (){
                  HomePageController homePageController = Get.put(HomePageController());
                  homePageController.clearAll();
                  Get.offAll(()=>HomePageView());
                },
              ),
              iconTheme: IconThemeData(color: white),
              title: Text(
                "History",
                style: TextStyle(color: white, fontSize: 22),
              ),
            ),
            body: Obx(
              () => controller.readData.isNotEmpty
                  ? CustomSlidAbleList(
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
                    )
                  : Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(color: white, fontSize: 22),
                      ),
                    ),
            )));
  }
}
