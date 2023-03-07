import 'package:flutter/material.dart';
import 'package:personal_training_app/core/const/color_constants.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final String errorText;
  final bool isError;
  final TextEditingController controller;
  final Function() onTextChanged;
  final TextInputAction textInputAction;

  const CustomTextField(
      {required this.title,
      required this.placeholder,
      required this.errorText,
      required this.controller,
      required this.onTextChanged,
      this.isError = false,
      this.textInputAction = TextInputAction.done,
      Key? key})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode focusNode = FocusNode();
  bool stateIsError = false;

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    stateIsError = focusNode.hasFocus ? false : widget.isError;
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          stateIsError = false;
        }
      });
    });
    stateIsError = widget.isError;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader(),
          const SizedBox(height: 5),
          _createTextField(),
          if (stateIsError) ...[_createError()]
        ],
      ),
    );
  }

  Widget _createTextField() {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      style: const TextStyle(color: ColorConstants.textBlack, fontSize: 16),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                  color: stateIsError
                      ? ColorConstants.errorColor
                      : ColorConstants.textFieldBorder.withOpacity(0.5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: ColorConstants.secondaryColor)),
          hintText: widget.placeholder,
          hintStyle: const TextStyle(color: ColorConstants.grey, fontSize: 16),
          filled: true,
          fillColor: ColorConstants.textFieldBackground),
      onChanged: (text) {
        setState(() {});
        widget.onTextChanged();
      },
    );
  }

  Widget _createHeader() {
    return Text(
      widget.title,
      style: TextStyle(
        color: _getUserNameColor(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _createError() {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        widget.errorText,
        style: const TextStyle(
          fontSize: 14,
          color: ColorConstants.errorColor,
        ),
      ),
    );
  }

  Color _getUserNameColor() {
    if (focusNode.hasFocus) {
      return ColorConstants.secondaryColor;
    } else if (stateIsError) {
      return ColorConstants.errorColor;
    } else if (widget.controller.text.isNotEmpty) {
      return ColorConstants.textBlack;
    }
    return ColorConstants.grey;
  }
}
