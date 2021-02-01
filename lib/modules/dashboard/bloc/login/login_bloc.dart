import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class BlocLogin extends Bloc<LoginEvent, LoginState> {
  BlocLogin() : super(LoginPageEmptyState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginPageLoadedEvent) {
      yield* checkUserIsLogin();
    }
  }

  Stream<LoginState> checkUserIsLogin() async* {
    yield LoginPageLoadingState();
    try {
      final FirebaseAuthService loginService = new FirebaseAuthService();
      var tmp  = await loginService.reauthenticatingUser();
      print(tmp);
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


