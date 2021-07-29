import 'package:rxdart/rxdart.dart';

class DrawerBloc {
  //Quero ser capaz de de armazenar o ultimo valor que passou na stream, inicia na pagina 0
  final BehaviorSubject<int> _pageController = BehaviorSubject<int>.seeded(0);

  Stream<int> get outPage => _pageController.stream;

  int _page = 0;

  void setPage(int page) {
    if (page == _page) return;
    _page = page;
    _pageController.add(page);
  }

  void dispose() {
    _pageController.close();
  }
}
