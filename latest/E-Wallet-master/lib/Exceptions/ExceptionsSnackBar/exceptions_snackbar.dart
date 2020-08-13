import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExceptionsSnackbar extends StatefulWidget {
  final  errorText;

  ExceptionsSnackbar(this.errorText);

  @override
  _ExceptionsSnackbarState createState() => _ExceptionsSnackbarState(errorText);
}

class _ExceptionsSnackbarState extends State<ExceptionsSnackbar> {
  final errorText;

  _ExceptionsSnackbarState(this.errorText);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDefaultSnackbar(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showDefaultSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorText),
        action: SnackBarAction(
          label: 'Click Me',
          onPressed: () {},
        ),
      ),
    );
  }
}
