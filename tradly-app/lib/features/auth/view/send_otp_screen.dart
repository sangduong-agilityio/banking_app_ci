import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/features/auth/states/sign_in_event.dart';
import 'package:tradly_app/features/auth/states/sign_in_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/utils/validators.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/snackbar.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/text_field.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final _authRepository = AuthRepositoryImplement(Supabase.instance.client);
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+84';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocProvider(
          create: (context) => SignInBloc(
            authRepository: _authRepository,
          ),
          child: BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              state.status.maybeWhen(
                orElse: () {
                  context.loaderOverlay.hide();
                },
                success: () async {
                  context.loaderOverlay.hide();
                },
                loading: () {
                  context.loaderOverlay.show();
                },
                failure: () {
                  context.loaderOverlay.hide();
                  TASnackBar.buildErrorSnackbar(
                    context,
                    state.errorMessage ?? '',
                  );
                },
              );
            },
            child: TAScaffold(
              backgroundColor: context.colorScheme.primary,
              appBar: TAAppBar(
                toolbarHeight: TAAppBarSize.medium,
                backgroundColor: context.colorScheme.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TADisplaySmallText(
                        text: S.current.sendOtpTitle,
                      ),
                      SizedBox(height: 29),
                      TAHeadlineSmallText(
                        text: S.current.sendOtpDescription,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      BlocBuilder<SignInBloc, SignInState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) {
                          return TAForm(
                            isValidated: (isValid) {
                              context.read<SignInBloc>().add(
                                    SendOtpFormValidateChangedevt(
                                      isValidate: isValid,
                                      phoneNumber:
                                          '$_selectedCountryCode ${_phoneController.text.trim()}',
                                    ),
                                  );
                            },
                            textFields: [
                              TATextField(
                                label: S.current.sendOtpPhoneNumberTitle,
                                controller: _phoneController,
                                useMaterialStyle: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    InputValidationMixin.validEmailOrPhone(
                                        value ?? ''),
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCountryCode,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: context.colorScheme.onPrimary),
                                      items: const [
                                        DropdownMenuItem(
                                            value: '+91',
                                            child: Text('+91',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        DropdownMenuItem(
                                            value: '+1',
                                            child: Text('+1',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        DropdownMenuItem(
                                            value: '+44',
                                            child: Text('+44',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        DropdownMenuItem(
                                            value: '+84',
                                            child: Text('+84',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountryCode = value ?? '+84';
                                        });
                                      },
                                      dropdownColor:
                                          context.colorScheme.primary,
                                      style: TextStyle(
                                          color: context.colorScheme.onPrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 104),
                      TextButton(
                        onPressed: () {},
                        child: TAHeadlineMediumText(
                          text: S.current.sendOtpLoginSocialNetWorkTitle,
                        ),
                      ),
                      SizedBox(height: 16),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          return TAElevatedButton(
                            isDisabled: !state.isFormValid ||
                                _phoneController.text.isEmpty,
                            fontWeight: FontWeight.w500,
                            text: S.current.sendOtpNextButton,
                            textSize: 16,
                            textColor: context.colorScheme.primary,
                            backgroundColor: context.colorScheme.onPrimary,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<SignInBloc>().add(
                                      SendOtpButtonPressedEvt(
                                        phoneNumber:
                                            '$_selectedCountryCode ${_phoneController.text.trim()}',
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
