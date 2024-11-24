import 'dart:convert';

import 'package:denomination/db/storage.dart';
import 'package:denomination/screen/history/model/model.dart';
import 'package:denomination/screen/home_page/comtroller/home_page_controller.dart';
import 'package:denomination/screen/home_page/view/home_page_view.dart';
import 'package:denomination/utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class HistoryController extends GetxController{
  final Storage storage = Storage();
  final UiUtils uiUtils = UiUtils();

  RxList<ReadModel> readData = <ReadModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  fetchData() async {
    // Fetch the stored JSON data as a string
    var jsonData = await storage.read(key: "list");

    if (jsonData != null) {
      // Decode the JSON string into a list of maps
      var data = jsonDecode(jsonData);

      // Check if the decoded data is a list
      if (data is List) {
        // Convert each map in the list to a ReadModel object
        readData.value = List<ReadModel>.from(data.map((item) => ReadModel.fromJson(item)));
        update();
      }
    }
    print(readData[0].dateTime);
    update();
  }

  delete({required int index})async{
    readData.removeAt(index);
    await storage.save(key: "list", value: jsonEncode(readData));
  }

  edit({required int index}){
    HomePageController homePageController = Get.put(HomePageController());
    Get.to(()=> HomePageView(), arguments: {"data": jsonEncode(readData[index])});
    homePageController.editCalculation();
  }


  shareData({required int index}){
    readData[index];
    Share.share("""
    2000 x ${readData[index].inputControllers![0] == "" ?  0 :readData[index].inputControllers![0]} = ${readData[index].total![0]}
    500 x ${readData[index].inputControllers![1]  == "" ?  0 :readData[index].inputControllers![1]} = ${readData[index].total![1]}
    200 x ${readData[index].inputControllers![2]  == "" ?  0 :readData[index].inputControllers![2]} = ${readData[index].total![2]}
    100 x ${readData[index].inputControllers![3]  == "" ?  0 :readData[index].inputControllers![3]} = ${readData[index].total![3]}
    50 x ${readData[index].inputControllers![4]  == "" ?  0 :readData[index].inputControllers![4]} = ${readData[index].total![4]}
    20 x ${readData[index].inputControllers![5]   == "" ?  0 :readData[index].inputControllers![5]} = ${readData[index].total![5]}
    10 x ${readData[index].inputControllers![6]  == "" ?  0 :readData[index].inputControllers![6]} = ${readData[index].total![6]}
    5 x ${readData[index].inputControllers![7]  == "" ?  0 :readData[index].inputControllers![7]} = ${readData[index].total![7]}
    2 x ${readData[index].inputControllers![8]  == "" ?  0 :readData[index].inputControllers![8]} = ${readData[index].total![8]}
    1 x ${readData[index].inputControllers![9]  == "" ?  0 :readData[index].inputControllers![9]} = ${readData[index].total![9]}
    Grant Total Amount : ₹ ${uiUtils.inputFormater(value : readData[index].totalSum!)}
    ${uiUtils.convertNumberToWords(readData[index].totalSum!)}
    
    """);
  }
}