import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_manager/models/file_direct_link.dart';
import 'package:project_manager/models/file_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FileService {
  static final FileService _fileService = FileService._internal();
  static const String _accountID = "54d25eee-5cf6-4cba-a9c8-0fc23814bd3c";
  static const String _AuthToken = "8gCfQEaIbLrmWfqdMWZOKNdsBLN3I5mo";
  static const String _FolderToken = "bf822299-e50c-42b3-957c-8eb7d383b9c8";

  String _filesHost = "https://store1.gofile.io/contents/uploadfile";

  factory FileService() {
    return _fileService;
  }

  FileService._internal();

  Future<FileResponse?> uploadFile(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(_filesHost),
    );

    request.headers['Authorization'] = _AuthToken;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    request.fields['folderId'] = _FolderToken;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return fileResponseFromJson(responseBody);
      // var data = jsonDecode(responseBody);
      // print(data);
    } else {
      print('Error: ${response.statusCode}');
    }
    return null;
  }

  Future<FileDirectLink?> fetchData(String fileId) async {
    try {
      var url = Uri.parse('https://api.gofile.io/contents/$fileId/directlinks');
      var headers = {
        'Authorization': _AuthToken,
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return fileDirectLinkFromJson(response.body);
        // var data = jsonDecode(response.body);
        // print(data);
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }
}

class PdfStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadPdf(String filePath) async {
    try {
      // Generate a unique UUID
      final String uniqueId = const Uuid().v4();

      // Create a reference to the storage path with the UUID as the filename
      final String storagePath = 'pdfs/$uniqueId.pdf';
      final Reference ref = _storage.ref().child(storagePath);

      // Upload the file
      await ref.putFile(File(filePath));

      // Get the download URL
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  Future<File?> retrievePdf(String downloadUrl) async {
    try {
      // Create a reference from the download URL
      final Reference ref = _storage.refFromURL(downloadUrl);

      // Download the file to a temporary location
      final File tempFile = File('${Directory.systemTemp.path}/temp_pdf.pdf');
      await ref.writeToFile(tempFile);

      return tempFile;
    } catch (e) {
      print('Error retrieving PDF: $e');
      return null;
    }
  }
}
