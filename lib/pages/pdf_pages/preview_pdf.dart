import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<String> saveandlanchFile(
    {required List<int> bytes, required String filename}) async {
  try {
    final temppDir = await getTemporaryDirectory();
    // final path = storage!.first.path;
    final path = '${temppDir.path}/$filename';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    final params = ShareParams(
      files: [XFile(file.path)],
      text: 'Generated PDF Report',
    );
    final shareresult = await SharePlus.instance.share(params);
    if (shareresult.status == ShareResultStatus.unavailable) {
      return "Share not available";
    }
    return "File Shared successfully";
  } catch (e) {
    return "Error creating the file";
  }
  // await OpenFile.open('${temppDir.path}/$filename');
}
