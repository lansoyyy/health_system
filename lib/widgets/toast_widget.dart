import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(msg) {
  return Fluttertoast.showToast(
    toastLength: Toast.LENGTH_LONG,
    msg: msg,
  );
}
