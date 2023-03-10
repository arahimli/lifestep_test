import 'package:rxdart/rxdart.dart';

enum Navigation { home, donations, challenges , profile
  // , TEAMS, LEAGUES
}

class NavigationBloc {
  //BehaviorSubject is from rxdart package
  final BehaviorSubject<Navigation> _navigationController
  = BehaviorSubject.seeded(Navigation.home);
  // seeded with inital page value. I'am assuming PAGE_ONE value as initial page.

  //exposing stream that notify us when navigation index has changed
  // Stream<Navigation> get currentNavigationIndex => _navigationController.stream;
  BehaviorSubject<Navigation> get currentNavigationIndex => _navigationController;
  // method to change your navigation index
  // when we call this method it sends data to stream and his listener
  // will be notified about it.
  void changeNavigationIndex(final Navigation option) => _navigationController.sink.add(option);
  Future<bool> changeNavigationIndexBool(final Navigation option) async{
    if(_navigationController.hasValue && _navigationController.value != option) {
      _navigationController.sink.add(option);
      return true;
    }
    return false;
  }

  void dispose() => _navigationController.close();
}

final NavigationBloc navigationBloc = NavigationBloc();