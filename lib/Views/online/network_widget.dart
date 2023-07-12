import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/connectivity.dart';

class NetworkWidget extends StatelessWidget {
  const NetworkWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<ConnectionStatus>(context);
    print(network);

    if (network == ConnectionStatus.wifi ||
        network == ConnectionStatus.mobileData) {
      return Container(
        child: child,
      );
    }

    return const Center(
        child: SizedBox(
            height: 50, width: 50, child: CircularProgressIndicator()));
  }
}
