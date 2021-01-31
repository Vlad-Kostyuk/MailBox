
abstract class LoginState {}

class LoginPageEmptyState extends LoginState {}

class LoginPageLoadingState extends LoginState {}

class LoginPageUserIsLoginState extends LoginState {}

class LoginPageUserLoadedState extends LoginState {}

class LoginPageErrorState extends LoginState {}