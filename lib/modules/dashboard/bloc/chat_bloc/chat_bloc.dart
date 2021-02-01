import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/modules/dashboard/bloc/registration_bloc/registration_event.dart';
import 'package:mailbox/modules/dashboard/bloc/registration_bloc/registration_state.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(initialState);

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) {
    throw UnimplementedError();
  }

}
