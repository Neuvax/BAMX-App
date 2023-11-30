import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditableDisplayName extends StatefulWidget {
  final String? displayName;
  const EditableDisplayName({super.key, this.displayName});

  @override
  State<EditableDisplayName> createState() => _EditableDisplayNameState();
}

class _EditableDisplayNameState extends State<EditableDisplayName> {
  late TextEditingController _controller;
  bool _isEditing = false;
  late String? _displayName;

  @override
  void initState() {
    super.initState();
    _displayName = widget.displayName;
    _controller = TextEditingController(text: widget.displayName);
  }

  Future<void> _saveChanges() async {
    if (_controller.text == _displayName) {
      setState(() {
        _isEditing = false;
      });
      return;
    }
    await context.read<AuthCubit>().updateDisplayName(_controller.text);
    if (_controller.text.isNotEmpty) {
      setState(() {
        _displayName = _controller.text;
      });
    } else {
      setState(() {
        _controller.text = _displayName!;
      });
    }
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
              : Expanded(
                  child: Text(
                    _displayName ?? 'Ingrese tu nombre',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
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
              icon:
                  _isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
              onPressed: _isEditing
                  ? _saveChanges
                  : () {
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
