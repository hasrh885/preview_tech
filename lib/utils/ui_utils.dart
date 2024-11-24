import 'package:intl/intl.dart';

class UiUtils {
  static final UiUtils _instance = UiUtils._internal();
  UiUtils._internal();
  factory UiUtils()=>_instance;

  stringToInt({required String value}){
    if(value == ""){
      return 0;
    }
    return int.parse(value.replaceAll(",", ""));
  }

  inputFormater({required int value}){
    if(value == ""){
      return "0";
    }
    return NumberFormat("#,###").format(value);
  }

  convertDate({required dateTimeString}){
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  convertTime({required dateTimeString}){
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('h:mm a').format(dateTime);
  }


  String convertNumberToWords(int number) {
    if (number == 0) return "Zero";

    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen"
    ];

    final tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety"
    ];

    if (number < 20) return units[number];

    if (number < 100) {
      return "${tens[number ~/ 10]} ${units[number % 10]}".trim();
    }

    if (number < 1000) {
      return "${units[number ~/ 100]} Hundred ${convertNumberToWords(number % 100)}".trim();
    }

    if (number < 1000000) {
      return "${convertNumberToWords(number ~/ 1000)} Thousand ${convertNumberToWords(number % 1000)}".trim();
    }

    if (number < 1000000000) {
      return "${convertNumberToWords(number ~/ 1000000)} Million ${convertNumberToWords(number % 1000000)}".trim();
    }

    return "${convertNumberToWords(number ~/ 1000000000)} Billion ${convertNumberToWords(number % 1000000000)}".trim();
  }
}