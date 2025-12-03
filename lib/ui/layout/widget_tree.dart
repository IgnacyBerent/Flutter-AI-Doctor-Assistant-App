import 'package:ai_doctor_assistant/models/jwt_token.dart';
import 'package:ai_doctor_assistant/ui/layout/layout.dart';
import 'package:ai_doctor_assistant/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  StreamController<bool> tokenController = StreamController<bool>();
  late Timer timer;
  final jwt = JwtToken();

  @override
  void initState() {
    super.initState();
    _checkTokenStatus();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkTokenStatus();
    });
  }

  void _checkTokenStatus() async {
    bool isTokenExpired = await jwt.isTokenExpired();
    // Use the opposite logic: if NOT expired, we are authenticated (true)
    bool isAuthenticated = !isTokenExpired;

    // Send the value to the stream.
    if (!tokenController.isClosed) {
      tokenController.add(isAuthenticated);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    tokenController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: tokenController.stream,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: const CircularProgressIndicator());
        } else {
          if (snapshot.data == true) {
            return const Layout();
          } else {
            return const LoginView();
          }
        }
      },
    );
  }
}
