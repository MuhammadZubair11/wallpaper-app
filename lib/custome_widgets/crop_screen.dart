import 'dart:io';

import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';


class CropScreen extends StatefulWidget {
  final File imageFile;
  const CropScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  // controller
  late final CropController controller;

  @override
  void initState() {
    super.initState();
    controller = CropController();
  }

  // crop and save function abna ga
  Future<File> _cropAndSave() async {
    final cropped = await controller.croppedBitmap();
    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final croppedFile = File(
      '${widget.imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await croppedFile.writeAsBytes(pngBytes);
    return croppedFile;
  }

  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CropImage(
                  controller: controller,
                  image: Image.file(widget.imageFile),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: _glassButton(
                icon: Icons.arrow_back,

                onTap: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: _glassButton(
                icon: Icons.check,
                onTap: () async {
                  final croppedFile = await _cropAndSave();
                  Navigator.pop(context, croppedFile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
