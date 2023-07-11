import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:excel/excel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/student_in_attendance.dart';

class ExcelWriter {
  static final _crashlytics = FirebaseCrashlytics.instance;
  static Excel? excel;
  static Sheet? sheet;
  static Future writeCustomModels(String attendanceName, String details,
      List<StudentInAttendance> models) async {
    // Get the external storage directory
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    if (downloadsDirectory == null) {
      _crashlytics.log('XLS WRITER: DOWNLOAD DIRECTORY NOT FOUND');
      return;
    }

    String downloadsPath = '${downloadsDirectory.path}/QRAttendance';

    // Create the directory if it doesn't exist
    await Directory(downloadsPath).create(recursive: true);

    // Create a new Excel workbook
    excel = Excel.createExcel();

    // Create a new sheet
    sheet = excel?['Sheet1'];

    setHeaderRow();
    int row = 1;
    // Add custom model data to the sheet
    for (var model in models) {
      sheet?.appendRow(
          [model.idNum, model.fullname, model.dept, model.timeAndDate]);

      if (model.isLate == 'true') {
        // Set the cell color to red
        sheet
            ?.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .cellStyle = CellStyle(backgroundColorHex: '#ed344a');
      }
      row += 1;
    }

    // Save the workbook to the specified file path
    var filePath =
        '${downloadsDirectory.path}/QRAttendance/Attendance/$attendanceName ($details).xlsx';
    List<String> result = [];
    try {
      var fileBytes = excel?.save();
      File(filePath).writeAsBytesSync(fileBytes!);
      result.add('Success');
      result.add('$attendanceName is saved on Downloads folder.');
    } catch (err) {
      _crashlytics.log('XLS WRITER: ${err.toString()}');
      result.add('Failed');
      result.add(err.toString());
    }

    return result;
  }

  static setHeaderRow() {
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: '#34a8eb',
        textWrapping: TextWrapping.Clip,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center);

    sheet?.setColWidth(0, 15);
    sheet?.setColWidth(1, 35);
    sheet?.setColWidth(2, 15);
    sheet?.setColWidth(3, 25);

    // Add header row
    sheet?.appendRow([
      'ID Number',
      'Name',
      'Department',
      'Date and Time Scanned',
    ]);

    List cells = [];
    cells.add(sheet?.cell(CellIndex.indexByString('A1')));
    cells.add(sheet?.cell(CellIndex.indexByString('B1')));
    cells.add(sheet?.cell(CellIndex.indexByString('C1')));
    cells.add(sheet?.cell(CellIndex.indexByString('D1')));

    for (var cell in cells) {
      cell.cellStyle = cellStyle;
    }
  }
}
