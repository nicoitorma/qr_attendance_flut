import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_content_prov.dart';
import 'package:qr_attendance_flut/Views/online/widget.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../../Models/attendance.dart';
import '../../utils/qr_scanner.dart';
import '../../values/const.dart';
import '../custom_list_tiles/attdnc_cntnt_tile.dart';
import '../instantiable_widget.dart';
import '../menu_app_bar.dart';

class OnlineAttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const OnlineAttendanceContents({super.key, required this.data});

  @override
  State<OnlineAttendanceContents> createState() =>
      _OnlineAttendanceContentsState();
}

class _OnlineAttendanceContentsState extends State<OnlineAttendanceContents> {
  late OnlineAttendanceContentsProv prov;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
    prov = Provider.of<OnlineAttendanceContentsProv>(context, listen: false);
    prov.getAttndcContent(widget.data.user!, widget.data.attendanceCode!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlineAttendanceContentsProv>(
      builder: ((context, value, child) => Scaffold(
          appBar: (value.isLongPress)
              ? MenuAppBar(value: value)
              : AppBar(
                  title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.attendanceName!),
                    (widget.data.cutoffTimeAndDate == 'null')
                        ? Container()
                        : Text('$labelCutoff${widget.data.cutoffTimeAndDate} ',
                            style: subtitleStyle)
                  ],
                )),
          bottomNavigationBar:
              (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (value.isLongPress) {
                value.setLongPress();
                value.clearSelectedItems();
              }
              Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: QrScanner(
                    data: widget.data,
                    provider: value,
                  ),
                  duration: transitionDuration,
                  reverseDuration: transitionDuration,
                  childCurrent: widget));
            },
            child: const Icon(Icons.qr_code_scanner_outlined),
          ),
          body: NetworkWidget(
              child: (value.list.isEmpty)
                  ? Center(child: Text(labelNoItem))
                  : ListView.builder(
                      itemCount: value.list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: AttendanceContentTile(
                              data: value.list[index],
                              color: (value.selectedTile
                                      .contains(value.list[index]))
                                  ? Colors.red
                                  : Colors.transparent,
                              onTap: () {
                                if (value.isLongPress) {
                                  if (value.selectedTile
                                      .contains(value.list[index])) {
                                    value.removeItemFromSelected(
                                        value.list[index]);
                                    if (value.selectedTile.isEmpty) {
                                      value.setLongPress();
                                    }
                                  } else {
                                    value.selectTile(value.list[index]);
                                  }
                                  return;
                                }
                              },
                              onLongPress: () {
                                value.setLongPress();
                                value.selectTile(value.list[index]);
                              }),
                        );
                      })))),
    );
  }
}
