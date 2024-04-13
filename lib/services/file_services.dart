import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:gradefy/models/file_direct_link.dart';
import 'package:gradefy/models/file_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      drive.DriveApi.driveFileScope,
    ],
  );

  Future<void> loginToGoogleAndUploadFile(
      BuildContext context, File file) async {
    try {
      // Create the HTTP client authenticated with the obtained headers
      AuthClient? httpClient = (await _googleSignIn.authenticatedClient());

      // Create the Google Drive API client
      final driveApi = drive.DriveApi(httpClient!);

      // Perform the file upload using the authenticated client
      await uploadToGoogleDrive(driveApi, file);

      // Sign out after the upload is complete (optional)
      await _googleSignIn.signOut();

      // Show success message or perform further actions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('File uploaded successfully to Google Drive!')),
      );
    } catch (error) {
      print('Error occurred during the login process: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload file to Google Drive.')),
      );
    }
  }

  Future<void> uploadToGoogleDrive(drive.DriveApi driveApi, File file) async {
    final fileContent = drive.Media(file.openRead(), file.lengthSync());
    final fileMetadata = drive.File();
    fileMetadata.name = file.path.split('/').last;
    fileMetadata.parents = null;

    // Upload the file to Google Drive
    final uploadedFile =
        await driveApi.files.create(fileMetadata, uploadMedia: fileContent);

    print(
        'File "${uploadedFile.name}" uploaded successfully. File ID: ${uploadedFile.id}');
  }

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
      // final String downloadUrl = await ref.getDownloadURL();
      // return downloadUrl;
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  Future<String?> uploadPdfFromUint8List(Uint8List pdfBytes) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "user@gmial.com",
          password: "UserPassword"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    // try {
      final User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   print("no user");
      //   return null;
      // } else {
        // Generate a unique UUID
        final String uniqueId = const Uuid().v4();

        // Create a reference to the storage path with the UUID as the filename
        final String storagePath = 'pdfs/$uniqueId.pdf';
        final Reference ref = _storage.ref().child(storagePath);

        // Upload the file from Uint8List
        await ref.putData(pdfBytes);

        // Get the download URL
        final String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      // }
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
  }

  Future<File?> retrievePdf(String downloadUrl) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "user@gmial.com",
          password: "UserPassword"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
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
