import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/presentation/components/custom_text_button.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Align(
                  alignment: Alignment.center,
                  child: ClickableLogo(
                    height: 50,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),

                      const Text(
                        '로그인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        '사용자 아이디 와 비밀번호를 입력하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 50),

                      //ID text field
                      CustomTextInput(
                        controller: _userNameController,
                        title: '사용자 아이디',
                        validator: InputValidator().validateId,
                      ),
                      const SizedBox(height: 20),
                      //password fiel
                      CustomTextInput(
                        controller: _passController,
                        title: '비밀번호',
                        validator: InputValidator().validatePass,
                        hidden: true,
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          statesController: MaterialStatesController(),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading ? const ButtonCircularProgressIndicator() : const Text('로그인'),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('계정이 없나요?'),
                          const SizedBox(width: 10),
                          CustomTextButton(
                            title: '사용자 등록',
                            onTap: () {
                              context.go('/signup');
                            },
                          ),
                        ],
                      ),

                      // password text field
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Copyright © '),
                      TextSpan(
                        text: 'Simpass Inc.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' All rights reserved.'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    _isLoading = true;
    setState(() {});

    if (_formKey.currentState!.validate()) {
      final APIService apiService = APIService();
      await apiService.login(context, LoginRequestModel(userName: _userNameController.text, password: _passController.text));
    }
    _isLoading = false;
    setState(() {});
  }
}
