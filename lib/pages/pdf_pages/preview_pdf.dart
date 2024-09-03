import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> saveandlanchFile(List<int> bytes, String filename) async {

  final storage = await getExternalStorageDirectories();
  final path = storage!.first.path;
  final file = File('$path/$filename');
  await file.writeAsBytes(bytes, flush: true);
   await OpenFile.open('$path/$filename');
  // print(result);
}
