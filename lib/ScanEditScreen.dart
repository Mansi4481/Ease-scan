import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'FinalImageScreen.dart';

class ScanEditScreen extends StatefulWidget {
  final File imageFile;
  const ScanEditScreen({super.key, required this.imageFile});

  @override
  State<ScanEditScreen> createState() => _ScanEditScreenState();
}

class _ScanEditScreenState extends State<ScanEditScreen> {
  Future<void> _navigateToFinalImageScreen(File pdfFile) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FinalImageScreen(pdfFile: pdfFile),
      ),
    );
  }

  Future<void> _exportPdfAndNavigate() async {
    try {
      // Generate PDF file
      final bytes = await widget.imageFile.readAsBytes();
      final outputDir = await getTemporaryDirectory();
      final pdfPath =
          "${outputDir.path}/scanned_doc_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(bytes);

      print('PDF generated at: $pdfPath'); // Debugging message

      // Navigate to FinalImageScreen
      _navigateToFinalImageScreen(pdfFile);
    } catch (e) {
      print('Error during PDF generation: $e'); // Debugging message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _exportPdfAndNavigate,
            child: const Text('Next',
                style: TextStyle(
                    color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Crop & Rotate',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _exportPdfAndNavigate,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF2563EB)),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
