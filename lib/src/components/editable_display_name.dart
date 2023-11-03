import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class EditableDisplayName extends StatefulWidget {
  final String? displayName;
  const EditableDisplayName({super.key, this.displayName});

  @override
  State<EditableDisplayName> createState() => _EditableDisplayNameState();
}

class _EditableDisplayNameState extends State<EditableDisplayName> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.displayName);
  }

  void _saveChanges() {
    //TODO: save changes
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isEditing
              ? Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                )
              : Text(
                  widget.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.accent,
                width: 2.0,
              ),
            ),
            child: IconButton(
              icon: _isEditing
                  ? const Icon(Icons.check)
                  : const Icon(Icons.edit),
              onPressed: _isEditing ? _saveChanges : () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}


