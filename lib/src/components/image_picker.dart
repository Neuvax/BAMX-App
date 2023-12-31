import 'dart:io';

import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_avatar/random_avatar.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? imageUrl;

  const ImagePickerWidget({super.key, this.imageUrl});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _imageUrl;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  Future<void> _pickImage() async {
    final authCubit = context.read<AuthCubit>();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final newImageFile = File(pickedFile.path);
      await authCubit.updateProfilePicture("profile_picture", newImageFile);
      setState(() {
        _imageFile = newImageFile;
        _imageUrl = null; // clear the imageUrl if a new image is picked
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
      child: Column(
        children: [
          if (_imageUrl != null || _imageFile != null)
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              backgroundImage: getImageProvider(),
            )
          else
            RandomAvatar(
              auth.currentUser!.uid,
              height: 150,
              width: 150,
            ),
          const SizedBox(height: 12),
          const Text(
            "Cambiar foto de perfil",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
