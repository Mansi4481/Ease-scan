import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ScanEditScreen.dart';

class NoScanYet extends StatelessWidget {
  const NoScanYet({super.key});

  Future<void> _scanDocument(BuildContext context) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
      return;
    }

    try {
      final String imagePath = join(
          (await getApplicationDocumentsDirectory()).path,
          "${DateTime.now().millisecondsSinceEpoch}.jpg");

      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: false,
        androidScanTitle: 'Scanning',
        androidCropTitle: '', // Disable crop title
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: '', // Disable crop reset
      );

      if (success && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScanEditScreen(imageFile: File(imagePath)),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/scanner.png', // Make sure to add this image to your assets
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'No scans yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Start scanning your documents',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _scanDocument(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(140, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Import',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
