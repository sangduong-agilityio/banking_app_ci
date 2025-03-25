import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reading_example/auth/states/auth_bloc.dart';
import 'package:reading_example/auth/states/auth_event.dart';
import 'package:reading_example/auth/states/auth_state.dart';
import 'package:reading_example/home/home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc()
        ..add(CheckLoginSession()), // Check session when the widget is created
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is LoginSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LoginSessionActive) {
                  return Center(child: Text('You are already logged in!'));
                } else if (state is LoginSessionInactive) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text;
                              final password = _passwordController.text;
                              context.read<LoginBloc>().add(
                                    LoginButtonPressed(
                                        username: username, password: password),
                                  );
                            }
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(); // Default fallback if no state matches
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
