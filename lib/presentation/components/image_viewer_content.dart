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
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.binaryImageList.isNotEmpty) _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_currentIndex != null)
            Image.memory(
              base64.decode(widget.binaryImageList[_currentIndex!]),
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
        ],
      ),
    );
  }
}
