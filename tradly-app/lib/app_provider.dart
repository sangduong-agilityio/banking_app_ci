import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/data/repositories/auth_repo.dart';
import 'package:tradly_app/presentations/pages/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/presentations/pages/auth/states/sign_up_bloc.dart';

class TAProvider extends StatelessWidget {
  const TAProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(
            authRepository: AuthRepositoryImplement(
              Supabase.instance.client,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(
            authRepository: AuthRepositoryImplement(
              Supabase.instance.client,
            ),
          ),
        ),
        // Add other BLoCs here if needed
      ],
      child: child,
    );
  }
}
