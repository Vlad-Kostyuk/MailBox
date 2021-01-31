import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/modules/dashboard/bloc/registration_bloc/registration_event.dart';
import 'package:mailbox/modules/dashboard/bloc/registration_bloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(RegistrationState initialState) : super(initialState);

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) {
    throw UnimplementedError();
  }

}
