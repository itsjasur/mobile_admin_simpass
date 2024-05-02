import 'dart:convert'; // For base64Decode
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageViewerContent extends StatefulWidget {
  final List binaryImageList;
  const ImageViewerContent({super.key, required this.binaryImageList});

  @override
  State<ImageViewerContent> createState() => _ImageViewerContentState();
}

class _ImageViewerContentState extends State<ImageViewerContent> {
  double _rotationAngle = 0.0; // Rotation angle in radians
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.binaryImageList.isNotEmpty) _currentIndex = 0;
  }

  void _rotateImage() {
    // incrementint the rotation angle by 90 degrees (in radians)
    setState(() {
      _rotationAngle += 90 * (3.141592653589793 / 180); // 90 degrees in radians
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.black,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_currentIndex != null)
              AspectRatio(
                aspectRatio: 1,
                child: Transform.rotate(
                  angle: _rotationAngle,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.memory(
                      base64.decode(widget.binaryImageList[_currentIndex!]),
                    ),
                  ),
                ),
              ),
            if (_currentIndex == null)
              const Text(
                'No image',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white38,
                ),
              ),
            Positioned(
              right: 0,
              top: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  onHover: (value) {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (_currentIndex != null && _currentIndex! >= 1) {
                      _currentIndex = _currentIndex! - 1;
                      setState(() {});
                    }
                  },
                  onHover: (value) {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (_currentIndex != null && _currentIndex! < widget.binaryImageList.length - 1) {
                      _currentIndex = _currentIndex! + 1;
                      setState(() {});
                    }
                  },
                  onHover: (value) {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                  onTap: _rotateImage,
                  onHover: (value) {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.rotate_90_degrees_cw_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
