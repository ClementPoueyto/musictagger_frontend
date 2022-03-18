import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit() : super(const Page1State());

  Future<void> goToPage1([String? text]) async => emit(Page1State(text));

  Future<void> goToPage2([String? text]) async => emit(Page2State(text));

  Future<void> goToPage3([String? text]) async => emit(Page3State(text));

  Future<void> goToPage4([String? text]) async => emit(Page4State(text));

  Future<void> popExtra() async {
    if (state is Page2State) {
      await goToPage2();
    } else if (state is Page3State) {
      await goToPage3();
    } else if (state is Page4State) {
      await goToPage4();
    } else {
      await goToPage1();
    }
  }

  Future<void> setNewRoutePath(RouterState state) async {
    if (state is Page2State) {
      await goToPage2(state.extraPageContent);
    } else if (state is Page3State) {
      await goToPage3(state.extraPageContent);
    } else if (state is Page4State) {
      await goToPage4(state.extraPageContent);
    } else {
      await goToPage1((state as Page1State).extraPageContent);
    }
  }
}