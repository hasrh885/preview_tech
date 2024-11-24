import 'package:denomination/component/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MultiplicationUi extends StatelessWidget {
  final TextEditingController inputController;
  final String multiplicationNo;
  final String total;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  const MultiplicationUi({
    super.key,
    required this.inputController,
    required this.multiplicationNo,
    required this.total,
    this.onTap,
    this.onChanged,
    this.suffix
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                "₹",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Text(
                multiplicationNo,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ).marginSymmetric(horizontal: 4),
              Text(
                "x",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ).marginOnly(left: 12),
            ],
          ),
        ),

        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: Get.width * 0.25,
                child: CustomTextFormField(
                  controller: inputController,
                  onTap: onTap,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(1),
                  ],
                  suffix: suffix,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "=",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Text(
                "₹",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ).marginSymmetric(horizontal: 4),
              Text(
                total,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ),
      ],
    ).marginAll(12);
  }
}
