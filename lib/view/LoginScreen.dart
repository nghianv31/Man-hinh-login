import 'package:bt1/repo/UserRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../models/UserModel.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String banner = 'assets/images/Frame 427324088.svg';
  final String icHeadphone = 'assets/images/headphone.svg';
  final String isSearch = 'assets/images/search-normal.svg';
  final String icSocial = 'assets/images/Social link.svg';

  final Color textColor = Color(0xFF242E37);
  final Color textHintColor = Color(0xFF5C6771);
  final Color borderColor = Color(0xFFEBECED);
  final Color focusedColor = Color(0xFFF24E1E);
  final double fontSize = 16;

  final TextEditingController msThueController = TextEditingController();
  final TextEditingController tkController = TextEditingController();
  final TextEditingController mkController = TextEditingController();

  final UserRepo _userRepo = UserRepo();

  bool isShowPass = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = _userRepo.getUser();
    if (currentUser != null) {
      msThueController.text = currentUser.msThue;
      tkController.text = currentUser.taiKhoan;
      mkController.text = currentUser.matKhau;
    }
  }

  @override
  void dispose() {
    msThueController.dispose();
    tkController.dispose();
    mkController.dispose();
    super.dispose();
  }

  bool _isTextFieldChange(TextEditingController controller) {
    return controller.text.isNotEmpty;
  }

  void _onClickSuffixIcon(TextEditingController controller, bool isPassword) {
    if (isPassword) {
      setState(() {
        isShowPass = !isShowPass;
      });
    } else {
      controller.clear();
    }
  }

  void _onClickLoginButton() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      final UserModel newUser = UserModel(
        msThue: msThueController.text,
        taiKhoan: tkController.text,
        matKhau: mkController.text,
        isLoginned: true,
      );
      final bool result = _userRepo.compareUser(newUser);
      if (result) {
        await _userRepo.addUser(newUser);
        await Hive.box('settings').put('isFirstLogin', false);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: newUser)),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Đăng nhập thất bại")));
        msThueController.clear();
        tkController.clear();
        mkController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Size size = constraints.biggest;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.05),
                        // Banner
                        _buildBanner(size),
                        const SizedBox(height: 30),
                        // Form
                        _buildForm(size),
                        const SizedBox(height: 40),
                        // Button
                        _buildButton(size),
                        // Footer
                        const SizedBox(height: 40),
                        const Spacer(),
                        _buildFooter(size),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBanner(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      child: SvgPicture.asset(banner, fit: BoxFit.cover),
    );
  }

  Widget _buildForm(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildItemForm(
            label: "Mã số thuế",
            hintText: "Mã số thuế",
            controller: msThueController,
            isPassword: false,
            isNumberKeyBoard: true,
            icon: Icons.cancel,
            validator: (value) {
              if (value == null || value.length < 10) {
                return "Mã số thuế phải có ít nhất 10 ký tự";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildItemForm(
            label: "Tài khoản",
            hintText: "Tài khoản",
            controller: tkController,
            isPassword: false,
            isNumberKeyBoard: false,
            icon: Icons.cancel,
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildItemForm(
            label: "Mật khẩu",
            hintText: "Mật khẩu",
            controller: mkController,
            isPassword: true,
            isNumberKeyBoard: false,
            icon: isShowPass ? Icons.visibility : Icons.visibility_off,
            validator: (value) {
              if (value == null || value.length < 6 || value.length > 50) {
                return "Mật khẩu phải từ 8 đến 50 ký tự";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemForm({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool isPassword,
    required bool isNumberKeyBoard,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        FormField<String>(
          key: ValueKey(label),
          initialValue: controller.text,
          validator: (value) {
            final currentVal = controller.text;
            if (currentVal.isEmpty) {
              return "Vui lòng nhập $label";
            }
            return validator(currentVal);
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: isNumberKeyBoard
                      ? TextInputType.number
                      : TextInputType.text,
                  controller: controller,
                  obscureText: isPassword ? !isShowPass : false,
                  cursorColor: focusedColor,
                  showCursor: true,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: textHintColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: state.hasError ? Colors.red : focusedColor,
                        width: 2,
                      ),
                    ),
                    suffixIcon: _isTextFieldChange(controller)
                        ? GestureDetector(
                            onTap: () {
                              _onClickSuffixIcon(controller, isPassword);
                              state.didChange("");
                              if (state.hasError) {
                                state.validate();
                              }
                            },
                            child: Icon(
                              icon,
                              size: 24,
                              color: textHintColor.withOpacity(0.5),
                            ),
                          )
                        : null,
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    state.didChange(value);
                    if (state.hasError) {
                      state.validate();
                    }
                    setState(() {});
                  },
                ),
                Visibility(
                  visible: state.hasError,
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          state.errorText ?? "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton(Size size) {
    return GestureDetector(
      onTap: () => _onClickLoginButton(),
      child: Container(
        width: size.width,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: focusedColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            "Đăng nhập",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFooterItem(size: size, icon: icHeadphone, title: "Trợ giúp"),
        _buildFooterItem(size: size, icon: icSocial, title: "Group"),
        _buildFooterItem(size: size, icon: isSearch, title: "Tra cứu"),
      ],
    );
  }

  Widget _buildFooterItem({
    required Size size,
    required String icon,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: size.width * 0.07,
            height: size.width * 0.07,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
