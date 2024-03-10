// import 'dart:io';

// import 'package:dhingra_residency/repository/models/new_room.dart';
// import 'package:dhingra_residency/repository/models/user_log.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

// import '../../../../data/function.dart';
// import '../../../../repository/models/food_expense.dart';
// import '../../../../repository/models/payment.dart';
// import '../../../../repository/models/reports.dart';
// import "package:collection/collection.dart";

// import '../../../../repository/models/voucher.dart';

// class PrintReportsController extends GetxController {
//   List<VoucherModel> dayInitial = [],
//       dayDuplicate = [],
//       nightInitial = [],
//       nightDuplicate = [],
//       extendedVoucher = [];

//   List<NewCheckInClass> dayInit = [],
//       dayDup = [],
//       nightInit = [],
//       nightDup = [],
//       extendedVoucherNew = [];

//   List<LateCheckoutExcelClass> lateClassList = [];

//   RxInt reportType = 1.obs;
//   int cashSum = 0, cardSum = 0, onlineSum = 0, returnSum = 0;
//   int foodTotal = 0, foodQuantityTotal = 0;

//   final List<String> foodReportType = ['Day', 'Night', 'Others'];
//   final List<String> menuTypes = ['Day', 'Night', 'Other'];
//   final List<String> occupiedRoomsTypes = ['Day', 'Night'];
//   final List<String> lateVouchersTypes = ['Night', 'Non-AC', 'Other'];

//   RxString foodReportSelected = 'Day'.obs,
//       occupiedRoomsSelected = 'Night'.obs,
//       lateVouchersSelected = 'Night'.obs;

//   RxString trxBy = 'All'.obs;
//   List<String> trxByList = ['All'];
//   Rx<DateTime> startDate = DateTime.now().obs,
//       endSelectedDate = DateTime.now().obs;
//   Rx<TimeOfDay> startTime = const TimeOfDay(hour: 0, minute: 0).obs,
//       endTime = const TimeOfDay(hour: 0, minute: 0).obs;
//   RxBool startFilter = false.obs, endFilter = false.obs;
//   Workbook workbook = Workbook();

//   //final reportsPath = Directory('/storage/emulated/0/HDR Reports');

//   @override
//   void onInit() async {
//     final snapshot = await FirebaseDatabase.instance
//         .ref()
//         .child('data/authentication')
//         .get();

//     if (snapshot.exists) {
//       var map = snapshot.value as dynamic;

//       for (var item in map['admin'].entries) {
//         trxByList.add(item.value['name']);
//       }
//       for (var item in map['employee'].entries) {
//         trxByList.add(item.value['name']);
//       }
//     }
//     super.onInit();
//   }

//   @override
//   void dispose() {
//     workbook.dispose();
//     if (kDebugMode) {
//       print("Workbook disposed");
//     }
//     super.dispose();
//   }

//   Future<bool> checkFolder() async {
//     if (!await Permission.storage.isGranted) {
//       await Permission.storage.request();
//       return true;
//     } else {
//       return true;
//     }
//   }

//   Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
//     if (Platform.isAndroid) {
//       Directory? directory = await getExternalStorageDirectory();
//       if (directory != null) {
//         final File file = File('${directory.path}/$fileName');
//         await file.writeAsBytes(bytes, flush: true);
//         try {
//           OpenFile.open(file.path);
//         } catch (e) {
//           throw Exception(e);
//         }
//       }
//     }
//   }

//   Future<List<ExcelDataRow>> buildHisaabFile(var listItem, int index) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<HisaabExcelClass> reports = <HisaabExcelClass>[];

//     for (var item in listItem) {
//       DateTime time = DateTime.parse(item['sort']);
//       String paymentTime =
//           '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${(time.year) % 100} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//       String amountString = item['amount'];
//       int amount = 0;
//       if (amountString.isNum) {
//         amount = int.parse(amountString);
//       }
//       switch (item['type']) {
//         case 'Cash':
//           {
//             cashSum += amount;
//             HisaabExcelClass item1 = HisaabExcelClass(
//                 index,
//                 item['voucher_number'],
//                 item['room_number'],
//                 paymentTime,
//                 item['employee'],
//                 item['amount'],
//                 '',
//                 '',
//                 '');
//             reports.add(item1);
//             break;
//           }
//         case 'Online':
//           {
//             onlineSum += amount;
//             HisaabExcelClass item1 = HisaabExcelClass(
//                 index,
//                 item['voucher_number'],
//                 item['room_number'],
//                 paymentTime,
//                 item['employee'],
//                 '',
//                 item['amount'],
//                 '',
//                 '');
//             reports.add(item1);
//             break;
//           }
//         case 'Return':
//           {
//             returnSum += amount;
//             HisaabExcelClass item1 = HisaabExcelClass(
//                 index,
//                 item['voucher_number'],
//                 item['room_number'],
//                 paymentTime,
//                 item['employee'],
//                 '',
//                 '',
//                 item['amount'],
//                 '');
//             reports.add(item1);
//             break;
//           }

//         case 'Card':
//           {
//             cardSum += amount;

//             HisaabExcelClass item1 = HisaabExcelClass(
//               index,
//               item['voucher_number'],
//               item['room_number'],
//               paymentTime,
//               item['employee'],
//               '',
//               '',
//               '',
//               item['amount'],
//             );
//             reports.add(item1);
//             break;
//           }
//       }
//     }

//     List<HisaabExcelClass> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((HisaabExcelClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(
//           columnHeader: '',
//           value: dataRow.serial,
//         ),
//         ExcelDataCell(columnHeader: '', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: '', value: dataRow.room),
//         ExcelDataCell(columnHeader: '', value: dataRow.cash),
//         ExcelDataCell(columnHeader: '', value: dataRow.online),
//         ExcelDataCell(columnHeader: '', value: dataRow.returnAmount),
//         ExcelDataCell(columnHeader: '', value: dataRow.card),
//         ExcelDataCell(columnHeader: '', value: dataRow.dateTime),
//         ExcelDataCell(columnHeader: '', value: dataRow.employeeName),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> hisaabExcel() async {
//     cashSum = 0;
//     cardSum = 0;
//     onlineSum = 0;
//     returnSum = 0;

//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     sheet.getRangeByName('A1:C1').merge();
//     sheet.getRangeByName('A1').setText('Transactions / Hisaab Report ');
//     sheet.getRangeByName('A1').cellStyle.fontSize = 10;

//     sheet.getRangeByName('A3').setText('SNo.');
//     sheet.getRangeByName('B3').setText('Voucher No.');
//     sheet.getRangeByName('C3').setText('Room No.');
//     sheet.getRangeByName('D3').setText('Cash');
//     sheet.getRangeByName('E3').setText('Online');
//     sheet.getRangeByName('F3').setText('Return');
//     sheet.getRangeByName('G3').setText('Card');
//     sheet.getRangeByName('H3').setText('Date/Time');
//     sheet.getRangeByName('I3').setText('Staff');

//     String startKey = startFilter.value
//         ? '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}${startTime.value.hour.toString().padLeft(2, '0')}${startTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = endSelectedDate.value.add(const Duration(days: 1));
//     String endKey = endFilter.value
//         ? '${(endSelectedDate.value.year) % 100}${endSelectedDate.value.month.toString().padLeft(2, '0')}${endSelectedDate.value.day.toString().padLeft(2, '0')}${endTime.value.hour.toString().padLeft(2, '0')}${endTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DataSnapshot snapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('payment')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();

//     Map<dynamic, dynamic> map = {};
//     if (snapshot.exists) {
//       map = snapshot.value as Map<dynamic, dynamic>;
//     }

//     List initialList;
//     if (trxBy.value == 'All') {
//       initialList = map.values
//           .where((element) =>
//               element['type'] != 'Rent' && element['type'] != 'Free')
//           .toList();
//     } else {
//       initialList = map.values
//           .where((element) =>
//               element['type'] != 'Rent' &&
//               element['type'] != 'Free' &&
//               element['employee'] == trxBy.value)
//           .toList();
//     }

//     var initialMap = groupBy(initialList, (item) => item['voucher_number']);

//     sheet.getRangeByName('B1:C1').columnWidth = 15;
//     sheet.getRangeByName('H1:I1').columnWidth = 18;

//     var newMap = Map.fromEntries(initialMap.entries.toList()
//       ..sort((e1, e2) => e1.key.compareTo(e2.key)));

//     int rowIndex = 4;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;
//     int count = 0;
//     for (var entry in newMap.entries) {
//       entry.value.sort((a, b) => a['sort'].compareTo(b['sort']));
//       count++;
//       dataRows = buildHisaabFile(entry.value, count);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);

//       sheet
//           .getRangeByIndex(rowIndex + 1, 1, rowIndex + entry.value.length, 1)
//           .merge();

//       sheet
//           .getRangeByIndex(rowIndex + 1, 2, rowIndex + entry.value.length, 2)
//           .merge();
//       sheet
//           .getRangeByIndex(rowIndex + 1, 3, rowIndex + entry.value.length, 3)
//           .merge();

//       rowIndex += entry.value.length + 1;
//     }

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A3:I${rowIndex - 1}').cellStyle = borderStyle;

//     rowIndex++;

//     sheet.getRangeByName('C$rowIndex:G$rowIndex').cellStyle = borderStyle;
//     sheet.getRangeByName('C$rowIndex').setText('Grand Total');
//     sheet.getRangeByName('D$rowIndex').setText(cashSum.toString());
//     sheet.getRangeByName('E$rowIndex').setText(onlineSum.toString());
//     sheet.getRangeByName('F$rowIndex').setText(returnSum.toString());
//     sheet.getRangeByName('G$rowIndex').setText(cardSum.toString());

//     final List<int> bytes = workbook.saveAsStream();
//     //workbook.dispose();

//     saveAndLaunchFile(bytes, 'Hisaab ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> builduserLogFile(
//       List<UserLogModel> list, int index) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
//     final List<UserLogReport> reports = <UserLogReport>[];

//     for (UserLogModel log in list) {
//       DateTime time = DateTime.parse(log.sort);
//       String logTime =
//           '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${(time.year) % 100} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

//       UserLogReport item1 = UserLogReport();
//       item1.index = index.toString();
//       item1.user = log.user;
//       item1.sort = logTime;
//       item1.voucher = log.voucher;
//       item1.voucherType = log.voucherType;
//       item1.room = log.room;
//       item1.action = log.action;
//       item1.newValue = log.newValue;

//       reports.add(item1);
//     }

//     List<UserLogReport> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((UserLogReport dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: '', value: dataRow.index),
//         ExcelDataCell(columnHeader: '', value: dataRow.user),
//         ExcelDataCell(columnHeader: '', value: dataRow.sort),
//         ExcelDataCell(columnHeader: '', value: dataRow.voucherType),
//         ExcelDataCell(columnHeader: '', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: '', value: dataRow.room),
//         ExcelDataCell(columnHeader: '', value: dataRow.action),
//         ExcelDataCell(columnHeader: '', value: dataRow.newValue),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> userLogExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     String startKey = startFilter.value
//         ? '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}${startTime.value.hour.toString().padLeft(2, '0')}${startTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = endSelectedDate.value.add(const Duration(days: 1));
//     String endKey = endFilter.value
//         ? '${(endSelectedDate.value.year) % 100}${endSelectedDate.value.month.toString().padLeft(2, '0')}${endSelectedDate.value.day.toString().padLeft(2, '0')}${endTime.value.hour.toString().padLeft(2, '0')}${endTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DataSnapshot daySnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('user_log')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();

//     Map<dynamic, dynamic> dayMap = {};
//     if (daySnapshot.exists) {
//       dayMap = daySnapshot.value as Map<dynamic, dynamic>;
//     }

//     sheet.getRangeByName('B1:H1').columnWidth = 18;

//     List<UserLogModel> logList = [];

//     for (Map item in dayMap.values) {
//       UserLogModel log = getUserLogClass(item);
//       logList.add(log);
//     }

//     Map logGroupedUnsorted =
//         groupBy(logList, (UserLogModel voucher) => voucher.voucher);

//     var logGrouped = Map.fromEntries(logGroupedUnsorted.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));

//     int rowIndex = 3;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     sheet.getRangeByName('A$rowIndex').setText('Sr No.');
//     sheet.getRangeByName('B$rowIndex').setText('User');
//     sheet.getRangeByName('C$rowIndex').setText('Date & Time');
//     sheet.getRangeByName('D$rowIndex').setText('Voucher Type');
//     sheet.getRangeByName('E$rowIndex').setText('Voucher No.');
//     sheet.getRangeByName('F$rowIndex').setText('Room No.');
//     sheet.getRangeByName('G$rowIndex').setText('Action');
//     sheet.getRangeByName('H$rowIndex').setText('Value');

//     sheet.getRangeByName('B1:C1').columnWidth = 18;
//     sheet.getRangeByName('G1').columnWidth = 18;

//     int index = 1;
//     rowIndex++;
//     for (var entry in logGrouped.entries) {
//       List<UserLogModel> logClassList = entry.value;

//       logClassList.sort(
//           (a, b) => (DateTime.parse(a.sort)).compareTo(DateTime.parse(b.sort)));

//       dataRows = builduserLogFile(logClassList, index);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);

//       sheet
//           .getRangeByIndex(rowIndex + 1, 1, rowIndex + logClassList.length, 1)
//           .merge();

//       sheet
//           .getRangeByIndex(rowIndex + 1, 4, rowIndex + logClassList.length, 4)
//           .merge();

//       sheet
//           .getRangeByIndex(rowIndex + 1, 5, rowIndex + logClassList.length, 5)
//           .merge();

//       rowIndex += logClassList.length + 1;
//       index++;
//     }
//     rowIndex--;

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:B1').merge();
//     sheet.getRangeByName('A1').setText('User Log');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:H$rowIndex').cellStyle = borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'User Log ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> buildAllRoomsFile(Map map) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<AllRoomsExcelClass> reports = <AllRoomsExcelClass>[];

//     for (var entry in map.entries) {
//       VoucherModel voucher = VoucherModel().getVoucherClass(entry.value);

//       DateTime checkIn = DateTime.parse(entry.value['checkin_date']);
//       DateTime checkOut = DateTime.parse(entry.value['checkout_date']);
//       String checkInTime =
//           '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${(checkIn.year) % 100} ${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

//       String checkOutTime =
//           '${checkOut.day.toString().padLeft(2, '0')}/${checkOut.month.toString().padLeft(2, '0')}/${(checkOut.year) % 100} ${checkOut.hour.toString().padLeft(2, '0')}:${checkOut.minute.toString().padLeft(2, '0')}';

//       AllRoomsExcelClass item1 = AllRoomsExcelClass(
//           voucher.voucherNumber,
//           voucher.voucherType,
//           voucher.roomNumber,
//           voucher.roomType,
//           voucher.mobileNumber,
//           checkInTime,
//           checkOutTime,
//           voucher.numberOfDays,
//           voucher.roomRent,
//           voucher.expense,
//           voucher.idType,
//           voucher.whatsappIdNumber,
//           voucher.checkInBy);
//       reports.add(item1);
//     }

//     List<AllRoomsExcelClass> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((AllRoomsExcelClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: 'Voucher No.', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: 'Type', value: dataRow.type),
//         ExcelDataCell(columnHeader: 'Room No.', value: dataRow.roomNo),
//         ExcelDataCell(columnHeader: 'Category', value: dataRow.category),
//         ExcelDataCell(columnHeader: 'Mob No.', value: dataRow.mobile),
//         ExcelDataCell(columnHeader: 'CheckIn Date', value: dataRow.checkin),
//         ExcelDataCell(columnHeader: 'CheckOut Date', value: dataRow.checkout),
//         ExcelDataCell(columnHeader: 'No. of Days', value: dataRow.days),
//         ExcelDataCell(columnHeader: 'Room Rent', value: dataRow.rent),
//         ExcelDataCell(columnHeader: 'Expense', value: dataRow.expense),
//         ExcelDataCell(columnHeader: 'ID Type', value: dataRow.idType),
//         ExcelDataCell(columnHeader: 'ID No.', value: dataRow.id),
//         ExcelDataCell(
//           columnHeader: 'CheckIn By',
//           value: dataRow.checkinBy,
//         ),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> allRoomsExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     String startKey = startFilter.value
//         ? '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}${startTime.value.hour.toString().padLeft(2, '0')}${startTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = endSelectedDate.value.add(const Duration(days: 1));
//     String endKey = endFilter.value
//         ? '${(endSelectedDate.value.year) % 100}${endSelectedDate.value.month.toString().padLeft(2, '0')}${endSelectedDate.value.day.toString().padLeft(2, '0')}${endTime.value.hour.toString().padLeft(2, '0')}${endTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DataSnapshot daySnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('day_voucher')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();
//     DataSnapshot nightSnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('night_voucher')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();

//     Map<dynamic, dynamic> dayMap = {}, nightMap = {};
//     if (daySnapshot.exists) {
//       dayMap = daySnapshot.value as Map<dynamic, dynamic>;
//     }
//     if (nightSnapshot.exists) {
//       nightMap = nightSnapshot.value as Map<dynamic, dynamic>;
//     }

//     sheet.getRangeByName('A1:C1').columnWidth = 13;
//     sheet.getRangeByName('D1:M1').columnWidth = 18;

//     Map initialMap = dayMap;
//     initialMap.addAll(nightMap);

//     Map map = Map.fromEntries(initialMap.entries.toList()
//       ..sort((e1, e2) => e1.key.compareTo(e2.key)));

//     int rowIndex = 3;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     if (map.isNotEmpty) {
//       dataRows = buildAllRoomsFile(map);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:B1').merge();
//     sheet.getRangeByName('A1').setText('All Rooms');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:M${rowIndex + map.length}').cellStyle =
//         borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'All Rooms ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> buildNewCheckinFile(List<dynamic> list) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<NewCheckInExcelClass> reports = <NewCheckInExcelClass>[];

//     int index = 1;
//     for (var item in list) {
//       NewCheckInClass voucher = item;

//       DateTime checkIn = DateTime.parse(voucher.checkin);
//       DateTime checkOut = DateTime.parse(voucher.checkout);
//       String checkInTime =
//           '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${(checkIn.year) % 100} ${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

//       String checkOutTime =
//           '${checkOut.day.toString().padLeft(2, '0')}/${checkOut.month.toString().padLeft(2, '0')}/${(checkOut.year) % 100} ${checkOut.hour.toString().padLeft(2, '0')}:${checkOut.minute.toString().padLeft(2, '0')}';

//       NewCheckInExcelClass item1 = NewCheckInExcelClass(
//           index.toString(),
//           voucher.voucher,
//           voucher.roomNo,
//           checkInTime,
//           voucher.status == 'checkout' ? checkOutTime : '');
//       reports.add(item1);
//       index++;
//     }

//     List<NewCheckInExcelClass> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((NewCheckInExcelClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: 'Sr No.', value: dataRow.srNo),
//         ExcelDataCell(columnHeader: 'Voucher No.', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: 'Room No.', value: dataRow.roomNo),
//         ExcelDataCell(columnHeader: 'CheckIn Date', value: dataRow.checkin),
//         ExcelDataCell(columnHeader: 'CheckOut Date', value: dataRow.checkout),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> newCheckinViewExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     dayInit = [];
//     nightInit = [];
//     dayDup = [];
//     nightDup = [];
//     extendedVoucherNew = [];

//     if (startDate.value.day == DateTime.now().day &&
//         startDate.value.month == DateTime.now().month &&
//         startDate.value.year == DateTime.now().year) {
//       final night = await FirebaseDatabase.instance
//           .ref('data')
//           .child('night_voucher')
//           .orderByChild('count')
//           .startAt(1)
//           .get();

//       final day = await FirebaseDatabase.instance
//           .ref('data')
//           .child('day_voucher')
//           .orderByChild('count')
//           .startAt(1)
//           .get();

//       if (night.exists) {
//         final map = night.value as Map<dynamic, dynamic>;

//         map.forEach((k, v) async {
//           VoucherModel voucherObject = VoucherModel().getVoucherClass(v);

//           NewCheckInClass instance = NewCheckInClass();
//           instance.roomNo = voucherObject.roomNumber;
//           instance.voucher = voucherObject.voucherNumber;
//           instance.count = voucherObject.count;
//           instance.status = voucherObject.status;
//           instance.voucherType = voucherObject.voucherType;
//           instance.checkin = voucherObject.checkinDate;
//           instance.checkout = voucherObject.checkoutDate;

//           nightInit.add(instance);
//           nightDup.add(instance);
//         });
//       }

//       if (day.exists) {
//         final map = day.value as Map<dynamic, dynamic>;

//         map.forEach((k, v) async {
//           VoucherModel voucherObject = VoucherModel().getVoucherClass(v);

//           NewCheckInClass instance = NewCheckInClass();
//           instance.roomNo = voucherObject.roomNumber;
//           instance.voucher = voucherObject.voucherNumber;
//           instance.count = voucherObject.count;
//           instance.status = voucherObject.status;
//           instance.voucherType = voucherObject.voucherType;
//           instance.checkin = voucherObject.checkinDate;
//           instance.checkout = voucherObject.checkoutDate;

//           dayInit.add(instance);
//           dayDup.add(instance);
//         });
//       }
//     } else {
//       String resetId =
//           '${startDate.value.day.toString().padLeft(2, '0')}${startDate.value.month.toString().padLeft(2, '0')}${(startDate.value.year) % 100}';

//       final snapshot = await FirebaseDatabase.instance
//           .ref('data/new_checkin')
//           .child(resetId)
//           .get();

//       if (snapshot.exists) {
//         final map = snapshot.value as Map<dynamic, dynamic>;
//         for (var item in map.values) {
//           NewCheckInClass voucherObject = NewCheckInClass().getClass(item);
//           if (voucherObject.voucherType == 'Day') {
//             dayInit.add(voucherObject);
//             dayDup.add(voucherObject);
//           } else {
//             nightInit.add(voucherObject);
//             nightDup.add(voucherObject);
//           }
//         }
//       }
//     }

//     int totalCheckout = 0;

//     for (var item in dayInit) {
//       NewCheckInClass voucherObject = item;

//       if (voucherObject.count == 1) {
//         extendedVoucherNew.add(voucherObject);
//       } else {
//         if (voucherObject.count > 2) {
//           for (int i = 2; i < voucherObject.count; i++) {
//             dayDup.add(voucherObject);
//           }
//         }
//         if (voucherObject.status == 'checkout') {
//           totalCheckout += (voucherObject.count - 1);
//         }
//       }
//     }
//     for (var item in nightInit) {
//       NewCheckInClass voucherObject = item;
//       if (voucherObject.count == 1) {
//         extendedVoucherNew.add(voucherObject);
//       } else {
//         if (voucherObject.count > 2) {
//           for (int i = 2; i < voucherObject.count; i++) {
//             nightDup.add(voucherObject);
//           }
//         }
//         if (voucherObject.status == 'checkout') {
//           totalCheckout += (voucherObject.count - 1);
//         }
//       }
//     }
//     for (var item in extendedVoucherNew) {
//       NewCheckInClass voucherObject = item;
//       if (dayInit.contains(voucherObject)) {
//         dayInit.remove(voucherObject);
//         dayDup.remove(voucherObject);
//       }
//       if (nightInit.contains(voucherObject)) {
//         nightInit.remove(voucherObject);
//         nightDup.remove(voucherObject);
//       }
//     }

//     dayDup.sort((a, b) => int.parse(a.voucher).compareTo(int.parse(b.voucher)));

//     nightDup
//         .sort((a, b) => int.parse(a.voucher).compareTo(int.parse(b.voucher)));

//     extendedVoucherNew
//         .sort((a, b) => int.parse(a.voucher).compareTo(int.parse(b.voucher)));

//     sheet.getRangeByName('A1:C1').columnWidth = 13;
//     sheet.getRangeByName('D1:M1').columnWidth = 18;

//     int rowIndex = 3;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     if (nightDup.isNotEmpty) {
//       dataRows = buildNewCheckinFile(nightDup);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }

//     rowIndex += nightDup.length + 2;

//     if (dayDup.isNotEmpty) {
//       dataRows = buildNewCheckinFile(dayDup);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }
//     rowIndex += dayDup.length + 2;

//     sheet.getRangeByName('B$rowIndex:C$rowIndex').merge();
//     sheet.getRangeByName('B$rowIndex').setText('Total Check-In');
//     sheet
//         .getRangeByName('D$rowIndex')
//         .setText('${dayDup.length + nightDup.length}');

//     sheet.getRangeByName('B${rowIndex + 1}:C${rowIndex + 1}').merge();
//     sheet.getRangeByName('B${rowIndex + 1}').setText('Total Check-Out');
//     sheet.getRangeByName('D${rowIndex + 1}').setText('$totalCheckout');

//     sheet.getRangeByName('B${rowIndex + 2}:C${rowIndex + 2}').merge();
//     sheet.getRangeByName('B${rowIndex + 2}').setText('Pending');
//     sheet
//         .getRangeByName('D${rowIndex + 2}')
//         .setText('${dayDup.length + nightDup.length - totalCheckout}');

//     rowIndex += 5;

//     if (extendedVoucherNew.isNotEmpty) {
//       dataRows = buildNewCheckinFile(extendedVoucherNew);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }

//     rowIndex += extendedVoucherNew.length + 2;

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:B1').merge();
//     sheet.getRangeByName('A1').setText('60 Wala Voucher');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:E${3 + nightDup.length}').cellStyle = borderStyle;
//     sheet
//         .getRangeByName(
//             'A${5 + nightDup.length}:E${5 + nightDup.length + dayDup.length}')
//         .cellStyle = borderStyle;

//     sheet
//         .getRangeByName(
//             'B${7 + dayDup.length + nightDup.length}:D${9 + nightDup.length + dayDup.length}')
//         .cellStyle = borderStyle;

//     sheet
//         .getRangeByName(
//             'A${12 + nightDup.length + dayDup.length}:E${12 + nightDup.length + dayDup.length + extendedVoucherNew.length}')
//         .cellStyle = borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'New CheckIn ${idGenerator()}.xlsx');
//   }

//   Future<void> repeatRoomsExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     String startKey = startFilter.value
//         ? '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}${startTime.value.hour.toString().padLeft(2, '0')}${startTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = endSelectedDate.value.add(const Duration(days: 1));
//     String endKey = endFilter.value
//         ? '${(endSelectedDate.value.year) % 100}${endSelectedDate.value.month.toString().padLeft(2, '0')}${endSelectedDate.value.day.toString().padLeft(2, '0')}${endTime.value.hour.toString().padLeft(2, '0')}${endTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DataSnapshot allRooms =
//         await FirebaseDatabase.instance.ref('data').child('rooms').get();

//     DataSnapshot daySnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('day_voucher')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();
//     DataSnapshot nightSnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('night_voucher')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();

//     Map<dynamic, dynamic> dayMap = {}, nightMap = {}, rooms = {};
//     if (daySnapshot.exists) {
//       dayMap = daySnapshot.value as Map<dynamic, dynamic>;
//     }
//     if (nightSnapshot.exists) {
//       nightMap = nightSnapshot.value as Map<dynamic, dynamic>;
//     }
//     if (allRooms.exists) {
//       rooms = allRooms.value as Map<dynamic, dynamic>;
//     }

//     Map nonAcMap = {}, classicMap = {}, deluxeMap = {}, saverMap = {};
//     for (var entry in rooms.entries) {
//       RoomModel room = RoomModel().getClass(entry.value);
//       if (room.roomType == 'Non-AC') {
//         nonAcMap[room.roomNumber] = 0;
//       }
//       if (room.roomType == 'Deluxe') {
//         deluxeMap[room.roomNumber] = 0;
//       }
//       if (room.roomType == 'Classic') {
//         classicMap[room.roomNumber] = 0;
//       }
//       if (room.roomType == 'Saver') {
//         saverMap[room.roomNumber] = 0;
//       }
//     }

//     Map initialMap = dayMap;
//     initialMap.addAll(nightMap);

//     int nonAcCount = 0, deluxeCount = 0, classicCount = 0, saverCount = 0;
//     for (var voucherItem in initialMap.values) {
//       VoucherModel voucher = VoucherModel().getVoucherClass(voucherItem);

//       if (nonAcMap.containsKey(voucher.roomNumber)) {
//         nonAcMap[voucher.roomNumber]++;
//         nonAcCount++;
//       }
//       if (deluxeMap.containsKey(voucher.roomNumber)) {
//         deluxeMap[voucher.roomNumber]++;
//         deluxeCount++;
//       }
//       if (classicMap.containsKey(voucher.roomNumber)) {
//         classicMap[voucher.roomNumber]++;
//         classicCount++;
//       }
//       if (saverMap.containsKey(voucher.roomNumber)) {
//         saverMap[voucher.roomNumber]++;
//         saverCount++;
//       }
//     }

//     int rowIndex = 4;

//     var nonAcSort = Map.fromEntries(nonAcMap.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));
//     nonAcSort.forEach((k, v) {
//       sheet.getRangeByName('A$rowIndex').setText(k);
//       sheet.getRangeByName('B$rowIndex').setText(v.toString());
//       rowIndex++;
//     });

//     rowIndex = 4;

//     var deluxeSort = Map.fromEntries(deluxeMap.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));
//     deluxeSort.forEach((k, v) {
//       sheet.getRangeByName('C$rowIndex').setText(k);
//       sheet.getRangeByName('D$rowIndex').setText(v.toString());
//       rowIndex++;
//     });

//     rowIndex = 4;

//     var classicSort = Map.fromEntries(classicMap.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));
//     classicSort.forEach((k, v) {
//       sheet.getRangeByName('E$rowIndex').setText(k);
//       sheet.getRangeByName('F$rowIndex').setText(v.toString());
//       rowIndex++;
//     });

//     rowIndex = 4;

//     var saverSort = Map.fromEntries(saverMap.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));
//     saverSort.forEach((k, v) {
//       sheet.getRangeByName('G$rowIndex').setText(k);
//       sheet.getRangeByName('H$rowIndex').setText(v.toString());
//       rowIndex++;
//     });

//     sheet.getRangeByName('A3:B3').merge();
//     sheet.getRangeByName('A3').setText('Non-AC : $nonAcCount');

//     sheet.getRangeByName('C3:D3').merge();
//     sheet.getRangeByName('C3').setText('Deluxe : $deluxeCount');

//     sheet.getRangeByName('E3:F3').merge();
//     sheet.getRangeByName('E3').setText('Classic : $classicCount');

//     sheet.getRangeByName('G3:H3').merge();
//     sheet.getRangeByName('G3').setText('Saver : $saverCount');

//     sheet.getRangeByName('E1:F1').merge();
//     sheet.getRangeByName('E1').setText('Total :');

//     int totalCount = nonAcCount + deluxeCount + classicCount + saverCount;

//     sheet.getRangeByName('G1:H1').merge();
//     sheet.getRangeByName('G1').setText(totalCount.toString());

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:B1').merge();
//     sheet.getRangeByName('A1').setText('Repeat Counter');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:B${nonAcMap.length + 3}').cellStyle = borderStyle;
//     sheet.getRangeByName('C3:D${deluxeMap.length + 3}').cellStyle = borderStyle;
//     sheet.getRangeByName('E3:F${classicMap.length + 3}').cellStyle =
//         borderStyle;
//     sheet.getRangeByName('G3:H${saverMap.length + 3}').cellStyle = borderStyle;
//     sheet.getRangeByName('E1:G1').cellStyle = borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'Repeat Counter ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> buildOccupiedRoomsFile(List<dynamic> list) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<OccupiedRoomsClass> reports = <OccupiedRoomsClass>[];

//     int index = 1;
//     for (var item in list) {
//       VoucherModel voucher = item;

//       DateTime checkIn = DateTime.parse(voucher.checkinDate);
//       DateTime checkOut = DateTime.parse(voucher.checkoutDate);
//       String checkInTime =
//           '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${(checkIn.year) % 100}  ${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';
//       String checkOutTime =
//           '${checkOut.day.toString().padLeft(2, '0')}/${checkOut.month.toString().padLeft(2, '0')}/${(checkOut.year) % 100}  ${checkOut.hour.toString().padLeft(2, '0')}:${checkOut.minute.toString().padLeft(2, '0')}';

//       OccupiedRoomsClass item1 = OccupiedRoomsClass(
//           index.toString(),
//           voucher.roomNumber,
//           voucher.voucherNumber,
//           voucher.idType,
//           voucher.whatsappIdNumber,
//           checkInTime,
//           checkOutTime);
//       reports.add(item1);
//       index++;
//     }
//     List<OccupiedRoomsClass> reports_1 = await Future.value(reports);

//     if (occupiedRoomsSelected.value == 'Day') {
//       excelDataRows = reports_1.map<ExcelDataRow>((OccupiedRoomsClass dataRow) {
//         return ExcelDataRow(cells: <ExcelDataCell>[
//           ExcelDataCell(columnHeader: '', value: dataRow.sno),
//           ExcelDataCell(columnHeader: '', value: dataRow.voucher),
//           ExcelDataCell(columnHeader: '', value: dataRow.idType),
//           ExcelDataCell(columnHeader: '', value: dataRow.whatsapp),
//           ExcelDataCell(columnHeader: '', value: dataRow.roomNo),
//           ExcelDataCell(columnHeader: '', value: dataRow.checkin),
//           ExcelDataCell(columnHeader: '', value: dataRow.checkout),
//         ]);
//       }).toList();
//     } else {
//       excelDataRows = reports_1.map<ExcelDataRow>((OccupiedRoomsClass dataRow) {
//         return ExcelDataRow(cells: <ExcelDataCell>[
//           ExcelDataCell(columnHeader: '', value: dataRow.sno),
//           ExcelDataCell(columnHeader: '', value: dataRow.roomNo),
//           ExcelDataCell(columnHeader: '', value: dataRow.voucher),
//           ExcelDataCell(columnHeader: '', value: dataRow.idType),
//           ExcelDataCell(columnHeader: '', value: dataRow.whatsapp),
//           ExcelDataCell(columnHeader: '', value: dataRow.checkin),
//         ]);
//       }).toList();
//     }
//     return excelDataRows;
//   }

//   Future<void> occupiedRoomsExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     dayInitial = [];
//     nightInitial = [];
//     sheet.getRangeByName('A1:C1').columnWidth = 13;
//     sheet.getRangeByName('D1:M1').columnWidth = 18;

//     int rowIndex = 4;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     if (occupiedRoomsSelected.value == 'Day') {
//       final day = await FirebaseDatabase.instance
//           .ref('data')
//           .child('day_voucher')
//           .orderByChild('count')
//           .startAt(1)
//           .get();

//       if (day.exists) {
//         final map = day.value as Map<dynamic, dynamic>;
//         for (var item in map.values) {
//           VoucherModel voucherObject = VoucherModel().getVoucherClass(item);
//           if (voucherObject.status != 'checkout') {
//             dayInitial.add(voucherObject);
//           }
//         }
//       }
//       dayInitial.sort((a, b) => DateTime.parse(a.checkoutDate)
//           .compareTo(DateTime.parse(b.checkoutDate)));

//       if (dayInitial.isNotEmpty) {
//         dataRows = buildOccupiedRoomsFile(dayInitial);
//         dataRows_1 = await Future.value(dataRows);
//         sheet.importData(dataRows_1, rowIndex, 1);
//       }
//       rowIndex += dayInitial.length + 2;

//       sheet.getRangeByName('A4').setText('SNo.');
//       sheet.getRangeByName('B4').setText('Voucher No.');
//       sheet.getRangeByName('C4').setText('ID Type');
//       sheet.getRangeByName('D4').setText('WhatsApp Code');
//       sheet.getRangeByName('E4').setText('Room No.');
//       sheet.getRangeByName('F4').setText('CheckIn Date');
//       sheet.getRangeByName('G4').setText('TT Checkout');

//       sheet.getRangeByName('A2:C2').merge();
//       sheet.getRangeByName('A2').setText('Occupied Room Checking List');
//       sheet.getRangeByName('A2').cellStyle = borderStyle;

//       sheet.getRangeByName('D1').setText('Hotel E Square');
//       sheet.getRangeByName('D1').cellStyle = borderStyle;

//       sheet.getRangeByName('G1').setText(
//           '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}');
//       sheet.getRangeByName('G1').cellStyle = borderStyle;

//       sheet.getRangeByName('A4:G${dayInitial.length + 4}').cellStyle =
//           borderStyle;

//       sheet.getRangeByName('A${dayInitial.length + 6}').setText('Remark :');
//       sheet.getRangeByName('F${dayInitial.length + 6}').setText('Signature :');

//       final List<int> bytes = workbook.saveAsStream();
//       // workbook.dispose();

//       saveAndLaunchFile(bytes, 'Occupied Day ${idGenerator()}.xlsx');
//     } else {
//       final night = await FirebaseDatabase.instance
//           .ref('data')
//           .child('night_voucher')
//           .orderByChild('count')
//           .startAt(1)
//           .get();

//       if (night.exists) {
//         final map = night.value as Map<dynamic, dynamic>;
//         for (var item in map.values) {
//           VoucherModel voucherObject = VoucherModel().getVoucherClass(item);
//           if (voucherObject.status != 'checkout') {
//             nightInitial.add(voucherObject);
//           }
//         }
//       }

//       nightInitial.sort((a, b) =>
//           int.parse(a.voucherNumber).compareTo(int.parse(b.voucherNumber)));

//       if (nightInitial.isNotEmpty) {
//         dataRows = buildOccupiedRoomsFile(nightInitial);
//         dataRows_1 = await Future.value(dataRows);
//         sheet.importData(dataRows_1, rowIndex, 1);
//       }

//       rowIndex += nightInitial.length + 2;

//       sheet.getRangeByName('A4').setText('SNo.');
//       sheet.getRangeByName('B4').setText('Room No.');
//       sheet.getRangeByName('C4').setText('Voucher No.');
//       sheet.getRangeByName('D4').setText('ID Type');
//       sheet.getRangeByName('E4').setText('WhatsApp Code');
//       sheet.getRangeByName('F4').setText('CheckIn Date');

//       sheet.getRangeByName('A2:C2').merge();
//       sheet.getRangeByName('A2').setText('Occupied Room Checking List');
//       sheet.getRangeByName('A2').cellStyle = borderStyle;

//       sheet.getRangeByName('D1').setText('Hotel E Square');
//       sheet.getRangeByName('D1').cellStyle = borderStyle;

//       sheet.getRangeByName('F1').setText(
//           '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}');
//       sheet.getRangeByName('F1').cellStyle = borderStyle;

//       sheet.getRangeByName('A4:F${nightInitial.length + 4}').cellStyle =
//           borderStyle;

//       sheet.getRangeByName('A${nightInitial.length + 6}').setText('Remark :');
//       sheet
//           .getRangeByName('E${nightInitial.length + 6}')
//           .setText('Signature :');

//       final List<int> bytes = workbook.saveAsStream();
//       // workbook.dispose();

//       saveAndLaunchFile(bytes, 'Occupied Night ${idGenerator()}.xlsx');
//     }
//   }

//   Future<List<ExcelDataRow>> buildLateCheckoutFile(List<dynamic> list) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<LateCheckoutExcelFileClass> reports =
//         <LateCheckoutExcelFileClass>[];

//     int index = 1;
//     for (var item in list) {
//       LateCheckoutExcelClass voucher = item;

//       DateTime checkOut = DateTime.parse(voucher.checkout);
//       DateTime? checkIn = DateTime.tryParse(voucher.checkin);

//       String checkOutTime =
//           '${checkOut.day.toString().padLeft(2, '0')}/${checkOut.month.toString().padLeft(2, '0')}/${(checkOut.year) % 100}  ${checkOut.hour.toString().padLeft(2, '0')}:${checkOut.minute.toString().padLeft(2, '0')}';

//       String checkInTime = '';
//       if (checkIn != null) {
//         checkInTime =
//             '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${(checkIn.year) % 100}  ${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';
//       }
//       LateCheckoutExcelFileClass item1 = LateCheckoutExcelFileClass(
//           index.toString(),
//           voucher.roomNo,
//           voucher.roomType,
//           voucher.voucher,
//           voucher.by,
//           checkInTime,
//           checkOutTime);
//       reports.add(item1);
//       index++;
//     }

//     List<LateCheckoutExcelFileClass> reports_1 = await Future.value(reports);

//     excelDataRows =
//         reports_1.map<ExcelDataRow>((LateCheckoutExcelFileClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: 'Sr No.', value: dataRow.index),
//         ExcelDataCell(columnHeader: 'Employee', value: dataRow.by),
//         ExcelDataCell(columnHeader: 'Room Type', value: dataRow.roomType),
//         ExcelDataCell(columnHeader: 'Voucher No.', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: 'Room No.', value: dataRow.roomNo),
//         ExcelDataCell(columnHeader: 'CheckIn Date', value: dataRow.checkin),
//         ExcelDataCell(columnHeader: 'CheckOut Date', value: dataRow.checkout),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> lateVoucherExcel() async {
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     lateClassList = [];
//     sheet.getRangeByName('B1:G1').columnWidth = 18;

//     int rowIndex = 3;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     String startKey =
//         '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = startDate.value.add(const Duration(days: 1));
//     String endKey =
//         '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DataSnapshot snapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('late_checkout')
//         .orderByKey()
//         .startAt(startKey)
//         .endAt(endKey)
//         .get();

//     if (snapshot.exists) {
//       final map = snapshot.value as Map<dynamic, dynamic>;
//       for (var item in map.values) {
//         LateCheckoutExcelClass voucherObject = getLateCheckoutClass(item);
//         if (voucherObject.voucherType == lateVouchersSelected.value) {
//           lateClassList.add(voucherObject);
//         }
//       }
//     }
//     lateClassList
//         .sort((a, b) => int.parse(a.voucher).compareTo(int.parse(b.voucher)));

//     if (lateClassList.isNotEmpty) {
//       dataRows = buildLateCheckoutFile(lateClassList);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }

//     rowIndex += lateClassList.length + 2;

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:C1').merge();
//     sheet.getRangeByName('A1').setText('Late CheckOuts');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:G${lateClassList.length + 3}').cellStyle =
//         borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'Late CheckOuts ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> buildFoodFile(var listItem) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<FoodClass> reports = <FoodClass>[];

//     for (var item in listItem) {
//       FoodExpenseModel foodItem = FoodExpenseModel().getClass(item);

//       DateTime time = DateTime.parse(foodItem.sort);
//       String itemTime =
//           '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${(time.year) % 100} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

//       FoodClass item1 = FoodClass(foodItem.voucher, foodItem.room, itemTime,
//           foodItem.by, foodItem.itemName, foodItem.quantity, foodItem.price);
//       reports.add(item1);
//     }

//     List<FoodClass> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((FoodClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: '', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: '', value: dataRow.roomNo),
//         ExcelDataCell(columnHeader: '', value: dataRow.dateTime),
//         ExcelDataCell(columnHeader: '', value: dataRow.addedBy),
//         ExcelDataCell(columnHeader: '', value: dataRow.item),
//         ExcelDataCell(columnHeader: '', value: dataRow.quantity),
//         ExcelDataCell(columnHeader: '', value: dataRow.price),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<List<ExcelDataRow>> buildOtherFoodSummaryFile(
//       List<OtherFoodSummaryClass> item) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<OtherFoodSummaryClass> reports = <OtherFoodSummaryClass>[];

//     for (var instance in item) {
//       reports.add(instance);
//     }

//     List<OtherFoodSummaryClass> reports_1 = await Future.value(reports);

//     excelDataRows =
//         reports_1.map<ExcelDataRow>((OtherFoodSummaryClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: 'Item Name', value: dataRow.item),
//         ExcelDataCell(columnHeader: 'Total Quantity', value: dataRow.quantity),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> foodExcel() async {
//     foodTotal = 0;
//     workbook = Workbook();
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     String startKey = startFilter.value
//         ? '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}${startTime.value.hour.toString().padLeft(2, '0')}${startTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(startDate.value.year) % 100}${startDate.value.month.toString().padLeft(2, '0')}${startDate.value.day.toString().padLeft(2, '0')}000000000000';

//     DateTime endDate = endSelectedDate.value.add(const Duration(days: 1));
//     String endKey = endFilter.value
//         ? '${(endSelectedDate.value.year) % 100}${endSelectedDate.value.month.toString().padLeft(2, '0')}${endSelectedDate.value.day.toString().padLeft(2, '0')}${endTime.value.hour.toString().padLeft(2, '0')}${endTime.value.minute.toString().padLeft(2, '0')}00000000'
//         : '${(endDate.year) % 100}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}000000000000';

//     DatabaseReference dataRef = foodReportSelected.value == foodReportType[0]
//         ? FirebaseDatabase.instance.ref('data').child('dayFoodReport')
//         : foodReportSelected.value == foodReportType[1]
//             ? FirebaseDatabase.instance.ref('data').child('nightFoodReport')
//             : FirebaseDatabase.instance.ref('data').child('otherFoodReport');

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     DataSnapshot snapshot =
//         await dataRef.orderByKey().startAt(startKey).endAt(endKey).get();

//     if (snapshot.exists) {
//       final dayMap = snapshot.value as Map<dynamic, dynamic>;
//       var initialList = dayMap.values.toList();

//       for (int index = 0; index < initialList.length; index++) {
//         if (initialList[index]['name'] == 'Water') {
//           initialList[index]['name'] = 'M/W';
//         }
//       }

//       var unsortedMap1 = groupBy(initialList, (item) => item['voucher']);
//       var unsortedMap2 = groupBy(initialList, (item) => item['name']);

//       var initialMap1 = Map.fromEntries(unsortedMap1.entries.toList()
//         ..sort((e1, e2) => int.parse(e1.key).compareTo(int.parse(e2.key))));

//       var initialMap2 = Map.fromEntries(unsortedMap2.entries.toList()
//         ..sort((e1, e2) => e1.key.compareTo(e2.key)));

//       Future<List<ExcelDataRow>> dataRows;
//       List<ExcelDataRow> dataRows_1;

//       int rowIndex = 3;

//       if (foodReportSelected.value == foodReportType[2]) {
//         sheet.getRangeByIndex(rowIndex, 2, rowIndex, 3).merge();
//         sheet.getRangeByName('B$rowIndex').setText('Item Wise Summary');
//         rowIndex++;

//         List<OtherFoodSummaryClass> otherList = [];

//         for (var entry in initialMap2.entries) {
//           int quantitySum = 0;
//           String itemName = '';
//           for (var item in entry.value) {
//             FoodExpenseModel foodItem = FoodExpenseModel().getClass(item);
//             itemName = foodItem.itemName;
//             String quantity = foodItem.quantity;
//             if (quantity.isNum) {
//               quantitySum += int.parse(quantity);
//             }
//           }
//           OtherFoodSummaryClass item =
//               OtherFoodSummaryClass(itemName, quantitySum);

//           otherList.add(item);
//         }

//         dataRows = buildOtherFoodSummaryFile(otherList);
//         dataRows_1 = await Future.value(dataRows);
//         sheet.importData(dataRows_1, rowIndex, 2);

//         sheet
//             .getRangeByName('B${rowIndex - 1}:C${rowIndex + otherList.length}')
//             .cellStyle = borderStyle;

//         rowIndex += initialMap2.length + 3;
//       }

//       sheet.getRangeByName('A$rowIndex').setText('Voucher No.');
//       sheet.getRangeByName('B$rowIndex').setText('Room No.');
//       sheet.getRangeByName('C$rowIndex').setText('Date/Time');
//       sheet.getRangeByName('D$rowIndex').setText('Added By');
//       sheet.getRangeByName('E$rowIndex').setText('Items');
//       sheet.getRangeByName('F$rowIndex').setText('Quantity');
//       sheet.getRangeByName('G$rowIndex').setText('Price');

//       sheet.getRangeByName('A1:Z1').columnWidth = 18;

//       sheet.getRangeByName('A$rowIndex:G$rowIndex').cellStyle = borderStyle;

//       rowIndex++;

//       for (var entry in initialMap1.entries) {
//         int sum = 0;
//         for (var item in entry.value) {
//           FoodExpenseModel foodItem = FoodExpenseModel().getClass(item);
//           String price = foodItem.price;
//           if (price.isNum) {
//             sum += int.parse(price);
//           }
//         }

//         sheet
//             .getRangeByName(
//                 'A${rowIndex + 1}:G${rowIndex + entry.value.length}')
//             .cellStyle = borderStyle;
//         sheet
//             .getRangeByName(
//                 'F${rowIndex + entry.value.length + 1}:G${rowIndex + entry.value.length + 1}')
//             .cellStyle = borderStyle;

//         foodTotal += sum;
//         entry.value.sort((a, b) => a['sort'].compareTo(b['sort']));

//         dataRows = buildFoodFile(entry.value);
//         dataRows_1 = await Future.value(dataRows);
//         sheet.importData(dataRows_1, rowIndex, 1);

//         sheet
//             .getRangeByIndex(rowIndex + 1, 1, rowIndex + entry.value.length, 1)
//             .merge();

//         sheet
//             .getRangeByIndex(rowIndex + 1, 2, rowIndex + entry.value.length, 2)
//             .merge();

//         sheet
//             .getRangeByName('F${rowIndex + entry.value.length + 1}')
//             .setText('Total');

//         sheet
//             .getRangeByName('G${rowIndex + entry.value.length + 1}')
//             .setText(sum.toString());

//         rowIndex += entry.value.length + 2;
//       }
//       sheet.getRangeByName('F$rowIndex').setText('Grand Total');
//       sheet.getRangeByName('G$rowIndex').setText(foodTotal.toString());

//       sheet.getRangeByName('F$rowIndex:G$rowIndex').cellStyle = borderStyle;

//       sheet.getRangeByName('F$rowIndex:G$rowIndex').cellStyle.bold = true;
//     }

//     sheet.getRangeByName('A1:C1').merge();
//     if (foodReportSelected.value == foodReportType[0]) {
//       sheet.getRangeByName('A1').setText('Food - Day Menu Report');
//     }
//     if (foodReportSelected.value == foodReportType[1]) {
//       sheet.getRangeByName('A1').setText('Food - Night Menu Report');
//     }
//     if (foodReportSelected.value == foodReportType[2]) {
//       sheet.getRangeByName('A1').setText('Food - Other Menu Report');
//     }
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'Day Food  ${idGenerator()}.xlsx');
//   }

//   Future<List<ExcelDataRow>> buildLastNightCheckoutFile(
//       List<VoucherModel> list) async {
//     List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

//     final List<LateNightClass> reports = <LateNightClass>[];
//     int index = 1;

//     for (VoucherModel voucher in list) {
//       int balance = 0;

//       Map paymentMap = {}
//         ..addAll(voucher.transactions)
//         ..addAll(voucher.extraCharge);

//       int totalExpense = int.parse(voucher.expense),
//           totalAdvance = 0,
//           returnAmount = 0;

//       paymentMap.forEach((k, v) {
//         PaymentModel paymentInstance = getPaymentClass(v);

//         switch (paymentInstance.type) {
//           case 'Cash':
//             {
//               totalAdvance += int.parse(paymentInstance.amount);
//               break;
//             }
//           case 'Card':
//             {
//               totalAdvance += int.parse(paymentInstance.amount);
//               break;
//             }
//           case 'Online':
//             {
//               totalAdvance += int.parse(paymentInstance.amount);
//               break;
//             }
//           case 'Rent':
//             {
//               totalExpense += int.parse(paymentInstance.amount);
//               break;
//             }
//           case 'Return':
//             {
//               returnAmount += int.parse(paymentInstance.amount);
//               break;
//             }
//           case 'Additional':
//             {
//               totalExpense += int.parse(paymentInstance.amount);
//               break;
//             }
//         }
//       });

//       balance = totalExpense + returnAmount - totalAdvance;

//       DateTime checkIn = DateTime.parse(voucher.checkinDate);
//       DateTime checkOut = DateTime.parse(voucher.checkoutDate);
//       String checkInTime =
//           '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${(checkIn.year) % 100} ${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

//       String checkOutTime =
//           '${checkOut.day.toString().padLeft(2, '0')}/${checkOut.month.toString().padLeft(2, '0')}/${(checkOut.year) % 100} ${checkOut.hour.toString().padLeft(2, '0')}:${checkOut.minute.toString().padLeft(2, '0')}';

//       LateNightClass item1 = LateNightClass(
//           index.toString(),
//           voucher.voucherNumber,
//           voucher.roomNumber,
//           checkInTime,
//           checkOutTime,
//           balance.toString());
//       reports.add(item1);
//       index++;
//     }

//     List<LateNightClass> reports_1 = await Future.value(reports);

//     excelDataRows = reports_1.map<ExcelDataRow>((LateNightClass dataRow) {
//       return ExcelDataRow(cells: <ExcelDataCell>[
//         ExcelDataCell(columnHeader: 'Sr No.', value: dataRow.index),
//         ExcelDataCell(columnHeader: 'Voucher No.', value: dataRow.voucher),
//         ExcelDataCell(columnHeader: 'Room No.', value: dataRow.roomNo),
//         ExcelDataCell(columnHeader: 'CheckIn Date', value: dataRow.checkin),
//         ExcelDataCell(columnHeader: 'CheckOut Date', value: dataRow.checkout),
//         ExcelDataCell(columnHeader: 'Balance', value: dataRow.balance),
//       ]);
//     }).toList();

//     return excelDataRows;
//   }

//   Future<void> lastNightCheckoutExcel() async {
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.enableSheetCalculations();

//     DataSnapshot nightSnapshot = await FirebaseDatabase.instance
//         .ref('data')
//         .child('night_voucher')
//         .orderByChild('count')
//         .startAt(1)
//         .get();

//     Map<dynamic, dynamic> nightMap = {};
//     if (nightSnapshot.exists) {
//       nightMap = nightSnapshot.value as Map<dynamic, dynamic>;
//     }

//     sheet.getRangeByName('A1:C1').columnWidth = 13;
//     sheet.getRangeByName('D1:M1').columnWidth = 18;

//     Map initialMap = nightMap;

//     Map map = Map.fromEntries(initialMap.entries.toList()
//       ..sort((e1, e2) => int.parse(e1.value['voucher_number'])
//           .compareTo(int.parse(e2.value['voucher_number']))));

//     DateTime currentTime = DateTime.now();
//     DateTime nextDay =
//         DateTime(currentTime.year, currentTime.month, currentTime.day + 1);

//     List tempList = map.values.toList();
//     List<VoucherModel> filteredList = [];
//     for (Map item in tempList) {
//       VoucherModel voucher = VoucherModel().getVoucherClass(item);
//       if (voucher.status != 'checkout' &&
//           DateTime.parse(voucher.checkoutDate).isBefore(nextDay)) {
//         filteredList.add(voucher);
//       }
//     }

//     int rowIndex = 3;
//     Future<List<ExcelDataRow>> dataRows;
//     List<ExcelDataRow> dataRows_1;

//     if (filteredList.isNotEmpty) {
//       dataRows = buildLastNightCheckoutFile(filteredList);
//       dataRows_1 = await Future.value(dataRows);
//       sheet.importData(dataRows_1, rowIndex, 1);
//     }

//     final Style borderStyle = workbook.styles.add('borderStyle');
//     borderStyle.hAlign = HAlignType.center;
//     borderStyle.vAlign = VAlignType.center;
//     borderStyle.wrapText = true;
//     borderStyle.borders.top.lineStyle = LineStyle.thin;
//     borderStyle.borders.bottom.lineStyle = LineStyle.thin;
//     borderStyle.borders.left.lineStyle = LineStyle.thin;
//     borderStyle.borders.right.lineStyle = LineStyle.thin;

//     sheet.getRangeByName('A1:B1').merge();
//     sheet.getRangeByName('A1').setText('All Rooms');
//     sheet.getRangeByName('A1').cellStyle = borderStyle;

//     sheet.getRangeByName('A3:F${rowIndex + filteredList.length}').cellStyle =
//         borderStyle;

//     final List<int> bytes = workbook.saveAsStream();
//     // workbook.dispose();

//     saveAndLaunchFile(bytes, 'All Rooms ${idGenerator()}.xlsx');
//   }
// }
