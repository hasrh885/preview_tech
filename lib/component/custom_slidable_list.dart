import 'package:denomination/resources/color.dart';
import 'package:denomination/screen/history/model/model.dart';
import 'package:denomination/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CustomSlidAbleList extends StatelessWidget {
  final RxList<ReadModel> readData;
  final Function(int index) onPressedDelete;
  final Function(int index) onPressedEdit;
  final Function(int index) onPressedShare;

  CustomSlidAbleList({
    super.key,
    required this.readData,
    required this.onPressedDelete,
    required this.onPressedEdit,
    required this.onPressedShare,
  });

  final UiUtils uiUtils = UiUtils();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: readData.length,
          itemBuilder: (context, index) {
            return Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    SlidableAction(
                      onPressed: (context){
                        onPressedDelete(index);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      // label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context){
                        onPressedEdit(index);
                      },
                      backgroundColor: silkBlue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      // label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context){
                        onPressedShare(index);
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      // label: 'Share',
                    )
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: cyanBlue,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General",
                        style: TextStyle(color: white, fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${readData[index].totalSum}",
                            style: TextStyle(color: silkBlue, fontSize: 24),
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${uiUtils.convertDate(dateTimeString: readData[index].dateTime)}",
                                style: TextStyle(color: grey, fontSize: 12),
                              ),
                              Text(
                                "${uiUtils.convertTime(dateTimeString: readData[index].dateTime)}",
                                style: TextStyle(color: grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "Remark",
                        style: TextStyle(color: lightBlue, fontSize: 12),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }
}
