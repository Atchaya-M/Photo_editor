import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Editor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _imageBytes;
  Uint8List? _editedImageBytes;
  bool _isProcessing = false;

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
        _editedImageBytes = null;
      });
    }
  }

  Future<void> _applyFilter() async {
    if (_imageBytes == null) return;

    setState(() {
      _isProcessing = true;
    });

    final image = img.decodeImage(_imageBytes!)!;
    final grayscaleImage = img.grayscale(image);

    setState(() {
      _editedImageBytes = img.encodePng(grayscaleImage);
      _isProcessing = false;
    });
  }

  Future<void> _saveImage() async {
    if (_editedImageBytes == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final blob = html.Blob([_editedImageBytes!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..setAttribute('download', 'edited_image.png');
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to save image. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
  }

  Widget _buildImage() {
    if (_imageBytes != null) {
      return Column(
        children: [
          Image.memory(_imageBytes!),
          const SizedBox(height: 20),
          if (_editedImageBytes != null)
            Image.memory(_editedImageBytes!), // Display edited image
        ],
      );
    } else {
      return const Placeholder(); // Placeholder for no image selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Editor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildImage(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _applyFilter,
              icon: const Icon(Icons.filter),
              label: const Text('Apply Filter'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _saveImage,
              icon: const Icon(Icons.save),
              label: const Text('Save Image'),
            ),
            const SizedBox(height: 20),
            _isProcessing
                ? const CircularProgressIndicator()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
