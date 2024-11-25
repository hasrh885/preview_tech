import 'package:denomination/component/custom_dropdown.dart';
import 'package:denomination/component/custom_popup_menu_button.dart';
import 'package:denomination/component/custom_text_form_field.dart';
import 'package:denomination/component/multiplication_ui.dart';
import 'package:denomination/resources/assets.dart';
import 'package:denomination/resources/color.dart';
import 'package:denomination/screen/history/view/history_view.dart';
import 'package:denomination/screen/home_page/comtroller/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({Key? key}) : super(key: key);

  final HomePageController homePageController = Get.put(HomePageController());
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
      body: Column(
        children: [
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              // Duration for smoother transition
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation.drive(Tween(begin: 0.8, end: 1.0)),
                    child: child,
                  ),
                );
              },
              child: Obx(
                () =>
                    controller.showNewWidget.value ? newWidget() : oldWidget(),
              )),
          Expanded(
            child: ListView(
              controller: controller.scrollControllerListView.value,
              physics: controller.listViewBuilderScrollingStart == false
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    color: Colors.black,
                    height: MediaQuery.sizeOf(context).height,
                    child: Obx(() => ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.list.length,
                          shrinkWrap: true,
                          controller:
                              controller.scrollControllerListViewBuilder.value,
                          physics:
                              controller.listViewBuilderScrollingStart.value ==
                                      true
                                  ? const AlwaysScrollableScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Obx(() => MultiplicationUi(
                                  inputController:
                                      controller.inputControllers[index],
                                  multiplicationNo: controller.uiUtils
                                      .inputFormater(
                                          value: controller.list[index]),
                                  total: controller.total[index],
                                  suffix: controller.inputControllers[index]
                                              .value.text !=
                                          ""
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.clearInput(index);
                                            controller.total[index] = "0";
                                            controller.totalSumValue();
                                          },
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: white,
                                            ),
                                            child: Icon(
                                              Icons.close_outlined,
                                              color: black,
                                              size: 18.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  onChanged: (value) {
                                    controller.updateValue(value, index);
                                  },
                                ));
                          },
                        )))
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: fabKey,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: black.withOpacity(0.9),
        ),
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.flash_on_outlined),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: white,
          backgroundColor: silkBlue,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.flash_on_outlined),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: white,
          backgroundColor: silkBlue,
          shape: const CircleBorder(),
        ),
        children: [
          floatingActionButton(
              onPressed: () {
                controller.clearAll();
                final state = fabKey.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              heroTag: "btn1",
              buttonName: "Clear",
              icon: Icons.refresh_outlined),
          floatingActionButton(
              onPressed: () {
                showDialogBox(context);
                final state = fabKey.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              heroTag: "btn2",
              buttonName: "Save",
              icon: Icons.save_alt_outlined),
        ],
      ),
    ));
  }

  Widget floatingActionButton(
      {required String heroTag,
      required String buttonName,
      required IconData icon,
      required final VoidCallback? onPressed}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            buttonName,
            style: TextStyle(color: white),
          ),
        ),
        SizedBox(width: 20),
        FloatingActionButton.small(
          backgroundColor: fillColor,
          heroTag: heroTag,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: white,
          ),
        ),
      ],
    );
  }

  void showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            color: black,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 35,
                      )).marginOnly(bottom: 8),
                ),
                leaveDropdown(
                  context: context,
                  hintName: 'Catagory',
                  items: controller.items,
                  currentItem: controller.currentItem.value,
                  itemCallBack: (value) {
                    controller.changeDropDownValue(value);
                  },
                ),
                CustomTextFormField(
                  maxLines: 4,
                  controller: controller.remarkController.value,
                  hintText: "Fill your remark(If any)",
                ).marginSymmetric(vertical: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.updateDataValue.value == false
                        ? controller.storeData()
                        : controller.updateData();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: grey,
                    backgroundColor: grey, // Change text color
                    side: BorderSide(width: 0), // Change border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Change border radius for rounded corners
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: white),
                  ).paddingSymmetric(vertical: 8, horizontal: 4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget leaveDropdown({
    required BuildContext context,
    required String hintName,
    required ValueChanged itemCallBack,
    required final List<String> items,
    dynamic currentItem,
  }) {
    return DropdownWidget(
      titleWidget: IntrinsicWidth(
        child: Text(hintName, style: const TextStyle(fontSize: 12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      hintText: hintName,
      currentItem: currentItem,
      itemCallBack: itemCallBack,
      items: items,
    );
  }

  Widget oldWidget() {
    return Obx(
      () => Stack(
        children: [
          SizedBox(
            height: 150,
            width: Get.width,
            child: Image.asset(
              Assets().homePageCurrencyBanner,
              fit: BoxFit.cover,
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: CustomPopupMenuButton(
                items: [
                  CustomPopupMenuItem(
                    icon: Icons.history,
                    text: 'History',
                    onTap: () {
                      Get.offAll(() => HistoryView());
                    },
                  ),
                ],
              )).marginOnly(top: 25),
          controller.totalSum == 0
              ? Positioned(
                  bottom: 15,
                  left: 5,
                  child: Text(
                    "Denomination",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ))
              : SizedBox.shrink(),
          Obx(
            () => controller.totalSum.value != 0
                ? Positioned(
                    bottom: 15,
                    left: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "₹ ${controller.uiUtils.inputFormater(value: controller.totalSum.value)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: Get.width,
                          child: Text(
                          "${controller.uiUtils.convertNumberToWords(controller.totalSum.value)} only/-",
                          maxLines: 5,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ).marginOnly(right: 28),)
                      ],
                    ).marginOnly(left: 8))
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget newWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: Get.width,
      color: ebonyClay,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Amount",
            style: TextStyle(color: white, fontSize: 16),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
              "₹ ${controller.uiUtils.inputFormater(value: controller.totalSum.value)}",
              style: TextStyle(color: white, fontSize: 16),
            ),
              CustomPopupMenuButton(
                items: [
                  CustomPopupMenuItem(
                    icon: Icons.history,
                    text: 'History',
                    onTap: () {
                      Get.to(() => HistoryView());
                    },
                  ),
                ],
              )
          ],),
          Text(
            controller.totalSum.value == 0
                ? controller.uiUtils.convertNumberToWords(0)
                : "${controller.uiUtils.convertNumberToWords(controller.totalSum.value)} only/-",
            maxLines: 2,
            style: TextStyle(color: white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
