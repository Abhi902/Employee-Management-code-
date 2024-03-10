import 'dart:developer';
import 'dart:io';

import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelModel {
  String? uid;
  String name;
  String category;
  String reference;
  String rate;
  String attendance;
  String amount;
  String advance;
  String kharcha;
  String autoRent;

  ExcelModel({
    required this.name,
    required this.category,
    required this.reference,
    required this.rate,
    required this.attendance,
    required this.amount,
    required this.advance,
    required this.kharcha,
    required this.autoRent,
    this.uid,
  });

  ExcelModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        category = json['category'] ?? '',
        reference = json['reference'] ?? '',
        rate = json['rate'] ?? '',
        attendance = json['attendance'] ?? '',
        amount = json['amount'] ?? '',
        advance = json['advance'] ?? '',
        kharcha = json['kharcha'] ?? '',
        autoRent = json['autoRent'] ?? '',
        uid = json['uid'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'reference': reference,
      'rate': rate,
      'attendance': attendance,
      'amount': amount,
      'advance': advance,
      'kharcha': kharcha,
      'autoRent': autoRent,
      'uid': uid,
    };
  }

  static Future<List<ExcelDataRow>> BuildFile(
      List<CommonFormModel> list) async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    List<ExcelModel> reports = [];

    for (CommonFormModel item in list) {
      ExcelModel item1 = ExcelModel(
        name: item.name,
        uid: item.uid,
        category: item.category,
        reference: item.reference,
        advance: item.advance,
        amount: item.amount,
        attendance: item.attendance,
        autoRent: item.autoRent,
        rate: item.rate,
        kharcha: item.kharcha,
      );
      reports.add(item1);
    }

    {
      excelDataRows = reports.map<ExcelDataRow>((ExcelModel dataRow) {
        return ExcelDataRow(cells: <ExcelDataCell>[
          ExcelDataCell(columnHeader: '', value: dataRow.uid),
          ExcelDataCell(columnHeader: '', value: dataRow.name),
          ExcelDataCell(columnHeader: '', value: dataRow.category),
          ExcelDataCell(columnHeader: '', value: dataRow.reference),
          ExcelDataCell(columnHeader: '', value: dataRow.rate),
          ExcelDataCell(columnHeader: '', value: dataRow.attendance),
          ExcelDataCell(columnHeader: '', value: dataRow.advance),
          ExcelDataCell(columnHeader: '', value: dataRow.kharcha),
          ExcelDataCell(columnHeader: '', value: dataRow.autoRent),
          ExcelDataCell(columnHeader: '', value: dataRow.amount),
        ]);
      }).toList();

      return excelDataRows;
    }
  }

  static Future<void> EmployeeExcel(List<CommonFormModel> employee) async {
    Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1:C1').columnWidth = 13;
    sheet.getRangeByName('D1:M1').columnWidth = 18;

    int rowIndex = 4;
    Future<List<ExcelDataRow>> dataRows;
    List<ExcelDataRow> dataRows_1;

    final Style borderStyle = workbook.styles.add('borderStyle');
    borderStyle.hAlign = HAlignType.center;
    borderStyle.vAlign = VAlignType.center;
    borderStyle.wrapText = true;
    borderStyle.borders.top.lineStyle = LineStyle.thin;
    borderStyle.borders.bottom.lineStyle = LineStyle.thin;
    borderStyle.borders.left.lineStyle = LineStyle.thin;
    borderStyle.borders.right.lineStyle = LineStyle.thin;

    {
      {
        dataRows = BuildFile(employee);
        dataRows_1 = await Future.value(dataRows);
        sheet.importData(dataRows_1, rowIndex, 1);
      }
      rowIndex += employee.length + 2;

      sheet.getRangeByName('B4').setText('Name');
      sheet.getRangeByName('J4').setText('Amount');
      sheet.getRangeByName('G4').setText('Advance');
      sheet.getRangeByName('A4').setText('User Id');
      sheet.getRangeByName('H4').setText('kharcha');
      sheet.getRangeByName('F4').setText('Attendance');
      sheet.getRangeByName('C4').setText('Category');
      sheet.getRangeByName('E4').setText('Rate');
      sheet.getRangeByName('I4').setText('AutoRent');
      sheet.getRangeByName('D4').setText('Reference');

      // sheet.getRangeByName('A2:C2').merge();
      // sheet.getRangeByName('A2').setText('Occupied Room Checking List');
      // sheet.getRangeByName('A2').cellStyle = borderStyle;

      // sheet.getRangeByName('D1').setText('Hotel E Square');
      // sheet.getRangeByName('D1').cellStyle = borderStyle;

      // sheet.getRangeByName('J1').setText(
      //     '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}');
      sheet.getRangeByName('J1').cellStyle = borderStyle;

      sheet.getRangeByName('A4:J${employee.length + 4}').cellStyle =
          borderStyle;

      // sheet.getRangeByName('A${employee.length + 6}').setText('Remark :');
      // sheet.getRangeByName('F${employee.length + 6}').setText('Signature :');

      final List<int> bytes = workbook.saveAsStream();
      // workbook.dispose();

      saveAndLaunchFile(bytes, 'Occupied Day ${idGenerator()}.xlsx');
    }
  }

  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final File file = File('${directory.path}/$fileName');
        log(directory.path.toString());
        await file.writeAsBytes(bytes, flush: true);
        try {
          OpenFile.open(file.path);
        } catch (e) {
          throw Exception(e);
        }
      }
    }
  }

  static String idGenerator() {
    DateTime temp = DateTime.now();
    return "${(temp.year) % 100}${temp.month.toString().padLeft(2, '0')}${temp.day.toString().padLeft(2, '0')}${temp.hour.toString().padLeft(2, '0')}${temp.minute.toString().padLeft(2, '0')}${temp.second.toString().padLeft(2, '0')}${temp.millisecond.toString().padLeft(3, '0')}${temp.microsecond.toString().padLeft(3, '0')}";
  }
}
