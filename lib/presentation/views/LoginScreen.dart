import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/values/AppStrings.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  final String banner = 'assets/images/Frame 427324088.svg';
  final String icHeadphone = 'assets/images/headphone.svg';
  final String isSearch = 'assets/images/search-normal.svg';
  final String icSocial = 'assets/images/Social link.svg';

  final double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final Size size = MediaQuery.sizeOf(context);
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.05),
                          _buildBanner(size),
                          const SizedBox(height: 30),
                          GetBuilder<LoginController>(
                            builder: (ctrl) => _buildForm(size, ctrl, context),
                          ),
                          const SizedBox(height: 40),
                          _buildButton(size, controller, context),
                          const SizedBox(height: 80),
                          const Spacer(),
                          _buildFooter(size, context),
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
      ),
    );
  }

  Widget _buildBanner(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      child: SvgPicture.asset(banner, fit: BoxFit.cover),
    );
  }

  Widget _buildForm(
    Size size,
    LoginController controller,
    BuildContext context,
  ) {
    return Form(
      key: controller.formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            _buildItemForm(
              label: AppStrings.taxCode,
              hintText: AppStrings.taxCode,
              textController: controller.taxCodeController,
              isPassword: false,
              isNumberKeyBoard: true,
              icon: Icons.cancel,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.taxCodeInvalid;
                }
                final RegExp regex = RegExp(
                  r'^(\d{10}|\d{12}|\d{13}|\d{14}|\d{10}-\d{3}|\d{10}-\d{4})$',
                );
                if (!regex.hasMatch(value)) {
                  return AppStrings.taxCodeInvalid;
                }
                return null;
              },
              nextFocus: controller.accountFocus,
              currentFocus: controller.taxCodeFocus,
              controller: controller,
              context: context,
            ),
            const SizedBox(height: 10),
            _buildItemForm(
              label: AppStrings.account,
              hintText: AppStrings.account,
              textController: controller.accountController,
              isPassword: false,
              isNumberKeyBoard: false,
              autofillHints: const [AutofillHints.username],
              icon: Icons.cancel,
              validator: (value) {
                return null;
              },
              nextFocus: controller.passwordFocus,
              currentFocus: controller.accountFocus,
              controller: controller,
              context: context,
            ),
            const SizedBox(height: 10),
            Obx(
              () => _buildItemForm(
                label: AppStrings.password,
                hintText: AppStrings.password,
                textController: controller.passwordController,
                isPassword: true,
                isNumberKeyBoard: false,
                autofillHints: const [AutofillHints.password],
                icon: controller.isShowPass.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                validator: (value) {
                  if (value == null || value.length < 6 || value.length > 50) {
                    return AppStrings.passwordInvalid;
                  }
                  return null;
                },
                currentFocus: controller.passwordFocus,
                controller: controller,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemForm({
    required String label,
    required String hintText,
    required TextEditingController textController,
    required bool isPassword,
    required bool isNumberKeyBoard,
    required IconData icon,
    required String? Function(String?) validator,
    Iterable<String>? autofillHints,
    FocusNode? nextFocus,
    required FocusNode currentFocus,
    required LoginController controller,
    required BuildContext context,
  }) {
    final colorScheme = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        FormField<String>(
          key: ValueKey(label),
          initialValue: textController.text,
          validator: (value) {
            final currentVal = textController.text;
            if (currentVal.isEmpty) {
              return "${AppStrings.pleaseEnter}$label";
            }
            return validator(currentVal);
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                      focusNode: currentFocus,
                      autofillHints: autofillHints,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        nextFocus != null
                            ? FocusScope.of(context).requestFocus(nextFocus)
                            : controller.handleLogin();
                      },
                      keyboardType: isPassword
                          ? TextInputType.visiblePassword
                          : (isNumberKeyBoard
                                ? TextInputType.number
                                : TextInputType.text),
                      controller: textController,
                      obscureText: isPassword
                          ? !controller.isShowPass.value
                          : false,
                      cursorColor: colorScheme.primary,
                      showCursor: true,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: state.hasError
                                ? Colors.red
                                : colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        suffixIcon: controller.isTextFieldChange(textController)
                            ? GestureDetector(
                                onTap: () {
                                  controller.onClickSuffixIcon(
                                    textController,
                                    isPassword,
                                  );
                                  state.didChange("");
                                  if (state.hasError) {
                                    state.validate();
                                  }
                                },
                                child: Icon(
                                  icon,
                                  size: 24,
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                              )
                            : null,
                      ),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) {
                        state.didChange(value);
                        if (state.hasError) {
                          state.validate();
                        }
                        controller.update();
                      },
                    )
                    .animate(
                      controller: controller.shakeController,
                      autoPlay: false,
                    )
                    .shake(
                      hz: 4,
                      curve: Curves.easeInOutCubic,
                      duration: const Duration(milliseconds: 400),
                    ),
                if (state.hasError)
                  Column(
                    children: [
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.errorText ?? "",
                              style: TextStyle(
                                color: colorScheme.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade().scale(curve: Curves.elasticOut),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton(
    Size size,
    LoginController controller,
    BuildContext context,
  ) {
    final colorScheme = context.theme.colorScheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.handleLogin();
      },
      child: Container(
        width: size.width,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Obx(
          () => Center(
            child: controller.isLoading.value
                ? SizedBox(
                    width: size.width * 0.08,
                    height: size.width * 0.08,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    AppStrings.login,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void onTapFooterItem(String title) {
    switch (title) {
      case AppStrings.help:
        Fluttertoast.showToast(
          msg: AppStrings.help,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        break;
      case AppStrings.group:
        Fluttertoast.showToast(
          msg: AppStrings.group,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        break;
      case AppStrings.lookup:
        Fluttertoast.showToast(
          msg: AppStrings.lookup,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        break;
      default:
    }
  }

  Widget _buildFooter(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFooterItem(
          size: size,
          icon: icHeadphone,
          title: AppStrings.help,
          onTap: () => onTapFooterItem(AppStrings.help),
          context: context,
        ),
        _buildFooterItem(
          size: size,
          icon: icSocial,
          title: AppStrings.group,
          onTap: () => onTapFooterItem(AppStrings.group),
          context: context,
        ),
        _buildFooterItem(
          size: size,
          icon: isSearch,
          title: AppStrings.lookup,
          onTap: () => onTapFooterItem(AppStrings.lookup),
          context: context,
        ),
      ],
    );
  }

  Widget _buildFooterItem({
    required Size size,
    required String icon,
    required String title,
    required Function()? onTap,
    required BuildContext context,
  }) {
    final colorScheme = context.theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorScheme.outline, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
