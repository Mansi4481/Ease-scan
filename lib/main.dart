import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const DocumentScannerApp());
}

class DocumentScannerApp extends StatelessWidget {
  const DocumentScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EdgeDetectionScreen(),
    );
  }
}

class EdgeDetectionScreen extends StatefulWidget {
  const EdgeDetectionScreen({super.key});

  @override
  _EdgeDetectionScreenState createState() => _EdgeDetectionScreenState();
}

class _EdgeDetectionScreenState extends State<EdgeDetectionScreen> {
  File? scannedImage;

  Future<void> scanDocument() async {
    try {
      final tempDir = Directory.systemTemp;
      final outputPath = '${tempDir.path}/scanned_document.jpg';
      bool success = await EdgeDetection.detectEdge(outputPath);

      if (success) {
        setState(() {
          scannedImage = File(outputPath);
        });

        // Navigate to FinalImageScreen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FinalImageScreen(imageFile: scannedImage!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to start scanning. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during scanning: $e')),
      );
    }
  }

  Future<void> shareOrSaveDocument() async {
    if (scannedImage != null) {
      await Share.shareXFiles([XFile(scannedImage!.path)],
          text: 'Scanned Document');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document to share or save.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            color: Colors.black,
            child: Lottie.asset(
              'assets/singing-contract.json',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Scan Documents Easily',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Quickly digitize your important papers with our intuitive scanning tool.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: scanDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Start Scanning',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinalImageScreen extends StatelessWidget {
  final File imageFile;

  const FinalImageScreen({super.key, required this.imageFile});

  Future<void> _shareImage(BuildContext context) async {
    try {
      await Share.shareXFiles([XFile(imageFile.path)],
          text: 'Scanned Document');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Document'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _shareImage(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Share',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
