import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path;

  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows ||
      Platform.isMacOS) {
    final directory = await path_provider.getApplicationSupportDirectory();
    path = directory.path;
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }

  final filePath = Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';

  final file = File(filePath);
  await file.writeAsBytes(bytes, flush: true);

  if (Platform.isAndroid || Platform.isIOS) {
    await OpenFilex.open(filePath, type: _getMimeType(fileName));
  } else if (Platform.isWindows) {
    await Process.run('start', [filePath], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', [filePath], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [filePath], runInShell: true);
  }
}

String _getMimeType(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();

  switch (ext) {
    case 'pdf':
      return 'application/pdf';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'xls':
      return 'application/vnd.ms-excel';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'doc':
      return 'application/msword';
    case 'png':
      return 'image/png';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'csv':
      return 'text/csv';
    default:
      return '*/*';
  }
}
