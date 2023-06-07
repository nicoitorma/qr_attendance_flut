import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/qr_list_provider.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Models/qr_code.dart';
import '../values/const.dart';

class QrCodeList extends StatefulWidget {
  const QrCodeList({super.key});

  @override
  State<QrCodeList> createState() => _QrCodeListState();
}

class _QrCodeListState extends State<QrCodeList> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idNumController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  bool isLongPress = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QrListProvider>(context, listen: false);
    provider.getQrList();
  }

  @override
  void dispose() {
    nameController.dispose();
    idNumController.dispose();
    deptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrListProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: (isLongPress)
            ? AppBar(
                title: Text(value.selectedQr.length.toString()),
                leading: InkWell(
                    onTap: () {
                      value.clearSelectedItems();
                      isLongPress = !isLongPress;
                    },
                    child: const Icon(Icons.close)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          value.deleteItem();
                          isLongPress = !isLongPress;
                        },
                        child: const Icon(Icons.delete_outlined)),
                  ),
                  (value.qrList.length > 1)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => value.selectAll(),
                              child: const Icon(Icons.select_all_outlined)),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () => value.selectAll(),
                        child: const Icon(Icons.save_outlined)),
                  ),
                ],
              )
            : AppBar(title: Text(labelQrCodes)),
        floatingActionButton: FloatingActionButton(
            onPressed: () => addQr(value), child: const Icon(Icons.add)),
        body: (value.qrList.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                itemCount: value.qrList.length,
                itemBuilder: ((context, index) {
                  List selectedQr = value.selectedQr;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: customListItem(
                      color: (selectedQr.contains(value.qrList[index]))
                          ? Colors.red
                          : Colors.transparent,
                      data: value.qrList[index],
                      onTap: () {
                        if (isLongPress) {
                          if (value.selectedQr.contains(value.qrList[index])) {
                            value.removeItemFromSelected(value.qrList[index]);
                            if (value.selectedQr.isEmpty) {
                              isLongPress = !isLongPress;
                            }
                          } else {
                            value.selectQr(value.qrList[index]);
                          }
                          return;
                        }
                      },
                      onLongPress: () {
                        isLongPress = !isLongPress;
                        value.selectQr(value.qrList[index]);
                      },
                    ),
                  );
                }),
              ),
      ),
    );
  }

  insertQr(var provider) async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      String idNum = idNumController.text.trim();
      String? dept = deptController.text.trim();

      provider.insertQr(QrModel(
        name: name,
        idNum: idNum,
        college: dept,
      ));
    }
    nameController.clear();
    idNumController.clear();
    deptController.clear();

    Navigator.of(context).pop();
  }

  /// The function displays an alert dialog with a form for creating a new QR code.
  ///
  /// Returns:
  ///   The `addQr()` function is returning an `AlertDialog` widget that contains a form with three
  /// input fields for name, ID number, and department. The form also has a submit button that will
  /// validate the input fields and return any errors if necessary.
  addQr(var provider) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Center(child: Text(labelNewQr)),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        inputField(
                          controller: nameController,
                          label: labelName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return labelName + labelEmptyFieldError;
                            }
                            return null;
                          },
                        ),
                        inputField(
                          controller: idNumController,
                          label: labelIdNum,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return labelIdNum + labelEmptyFieldError;
                            }
                            return null;
                          },
                        ),
                        inputField(
                          controller: deptController,
                          label: labelDept,
                        ),
                        ElevatedButton(
                            onPressed: () => insertQr(provider),
                            child: Text(labelCreateQr))
                      ],
                    )),
              ),
            )));
  }
}
