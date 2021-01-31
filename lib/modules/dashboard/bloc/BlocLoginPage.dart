import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';

class BlocLoginPage extends Bloc<LoginEvent, LoginState> {
  BlocLoginPage() : super(LoginPageEmptyState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginPageLoadedEvent) {
      yield* checkUserIsLogin();
    }
  }

  Stream<LoginState> checkUserIsLogin() async* {
    yield LoginPageLoadingState();
    try {
      final LoginService loginService = new LoginService();
      var tmp  = await loginService.reauthenticatingUser();
      if(tmp) {
        yield LoginPageUserIsLoginState();
      } else {
        yield LoginPageUserLoadedState();
      }
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      yield LoginPageUserIsLoginState();
    }
  }

}

//--------State--------

abstract class LoginState {}

class LoginPageEmptyState extends LoginState {}

class LoginPageLoadingState extends LoginState {}

class LoginPageUserIsLoginState extends LoginState {}

class LoginPageUserLoadedState extends LoginState {}

class LoginPageErrorState extends LoginState {}

//---------------------


//--------Event--------

abstract class LoginEvent {}

class LoginPageLoadedEvent extends LoginEvent {}

//---------------------