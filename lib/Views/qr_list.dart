import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Views/custom_list_tiles/qr_tile.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Controller/offline/qr_list_provider.dart';
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
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
    final provider = Provider.of<QrListProvider>(context, listen: false);
    provider.getQrList();
  }

  @override
  void dispose() {
    nameController.dispose();
    idNumController.dispose();
    deptController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrListProvider>(
      builder: (context, value, child) => Scaffold(
        bottomNavigationBar: (_bannerAd != null)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!))
            : const SizedBox(height: 0),
        appBar: (isLongPress)
            ? AppBar(
                title: Text(value.selectedTile.length.toString()),
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
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    title: Text(labelAlertDeleteTitle),
                                    content: Text(labelAlertDeleteContent),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(labelNo)),
                                      TextButton(
                                          onPressed: () {
                                            value.deleteItem();
                                            isLongPress = !isLongPress;
                                            Navigator.pop(context);
                                          },
                                          child: Text(labelYes))
                                    ],
                                  )));
                        },
                        child: const Icon(Icons.delete_outlined)),
                  ),
                  (value.list.length > 1)
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
        body: (value.list.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                itemCount: value.list.length,
                itemBuilder: ((context, index) {
                  List selectedQr = value.selectedTile;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: QrTile(
                      color: (selectedQr.contains(value.list[index]))
                          ? Colors.red
                          : Colors.transparent,
                      data: value.list[index],
                      onTap: () {
                        if (isLongPress) {
                          if (value.selectedTile.contains(value.list[index])) {
                            value.removeItemFromSelected(value.list[index]);
                            if (value.selectedTile.isEmpty) {
                              isLongPress = !isLongPress;
                            }
                          } else {
                            value.selectQr(value.list[index]);
                          }
                          return;
                        }
                      },
                      onLongPress: () {
                        isLongPress = !isLongPress;
                        value.selectQr(value.list[index]);
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
      String fullname = nameController.text.trim();
      String idNum = idNumController.text.trim();
      String? dept = deptController.text.trim();

      provider.insertQr(QrModel(
        fullname: fullname,
        idNum: idNum,
        dept: dept,
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
