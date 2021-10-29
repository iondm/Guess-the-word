import "package:flutter/material.dart";

class AnswerTextInput extends StatefulWidget {
  final _controller;
  Function(String) testResponse;
  Function answerHint;
  bool responseVisibility;
  String hint;
  FocusNode focusNode;
  AnswerTextInput(this._controller, this.testResponse, this.responseVisibility,
      this.hint, this.focusNode, this.answerHint);

  @override
  _AnswerTextInputState createState() => _AnswerTextInputState();
}

class _AnswerTextInputState extends State<AnswerTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._controller,
      keyboardType: TextInputType.text,
      onSubmitted: widget.testResponse,
      focusNode: widget.focusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => widget.answerHint(),
          icon: Icon(Icons.lightbulb_outline),
          color: Colors.orange,
        ),
        hintText: widget.hint,
        labelText: "Try to guess!",
        errorText: widget.responseVisibility ? "!" : null,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(fontSize: 0),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
