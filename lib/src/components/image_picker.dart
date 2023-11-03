import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  ImageProvider<Object>? getImageProvider() {
    if (_imageUrl != null) {
      return CachedNetworkImageProvider(_imageUrl!);
    } else if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else {
      return const AssetImage('assets/images/smiling_apple.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 75,
          backgroundColor: Colors.grey[300],
          backgroundImage: getImageProvider(),
        ));
  }
}
