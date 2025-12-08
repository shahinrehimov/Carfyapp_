// FILE: scripts/split_files.dart
// Usage: dart scripts/split_files.dart lib/auth_domain_temp.dart
//        dart scripts/split_files.dart lib/auth_data_temp.dart

import 'dart:io';

void main(List<String> arguments) async {
  const String reset = '\x1B[0m';
  const String green = '\x1B[32m';
  const String red = '\x1B[31m';
  const String yellow = '\x1B[33m';
  const String blue = '\x1B[34m';
  const String cyan = '\x1B[36m';

  try {
    if (arguments.isEmpty) {
      print('${red}❌ Error: Please provide the temp file path${reset}');
      print('${cyan}Usage:${reset}');
      print('  dart scripts/split_files.dart lib/auth_domain_temp.dart');
      print('  dart scripts/split_files.dart lib/auth_data_temp.dart');
      exit(1);
    }

    final String tempFilePath = arguments[0];
    final File tempFile = File(tempFilePath);

    if (!await tempFile.exists()) {
      print('${red}❌ Error: File not found: $tempFilePath${reset}');
      exit(1);
    }

    print('${yellow}📂 Reading file: $tempFilePath${reset}');
    print('${blue}⚙️  Processing...${reset}\n');

    final String content = await tempFile.readAsString();
    final List<String> lines = content.split('\n');

    String? currentFilePath;
    StringBuffer currentContent = StringBuffer();
    int filesCreated = 0;
    final List<String> createdFiles = [];

    for (final String line in lines) {
      if (line.startsWith('// FILE:')) {
        if (currentFilePath != null) {
          await _saveFile(currentFilePath, currentContent.toString());
          createdFiles.add(currentFilePath);
          filesCreated++;
        }

        String extractedPath = line.replaceFirst('// FILE:', '').trim();
        if (!extractedPath.startsWith('lib/')) {
          extractedPath = 'lib/$extractedPath';
        }
        currentFilePath = extractedPath;
        currentContent = StringBuffer();
      } else {
        if (currentFilePath != null) {
          currentContent.writeln(line);
        }
      }
    }

    if (currentFilePath != null) {
      await _saveFile(currentFilePath, currentContent.toString());
      createdFiles.add(currentFilePath);
      filesCreated++;
    }

    print('\n${green}✨ Done! Created $filesCreated files successfully.${reset}\n');

    // Show created files
    print('${cyan}📋 Created files:${reset}');
    for (final file in createdFiles) {
      print('   ${green}✓${reset} $file');
    }

    print('\n${yellow}❓ Delete temp file? (y/n)${reset}');
    final String? input = stdin.readLineSync();

    if (input?.toLowerCase() == 'y' || input?.toLowerCase() == 'yes') {
      await tempFile.delete();
      print('${green}✓ Temp file deleted.${reset}\n');
    } else {
      print('${cyan}ℹ️  Temp file kept for reference.${reset}\n');
    }
  } catch (e) {
    print('${red}❌ Error: $e${reset}');
    exit(1);
  }
}

Future<void> _saveFile(String filePath, String content) async {
  final File file = File(filePath);
  await file.parent.create(recursive: true);
  final String cleanContent = content.trim();
  await file.writeAsString('$cleanContent\n');
}