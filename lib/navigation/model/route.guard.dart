
class OnRouteObserver{
  final bool Function(String route,Map<String,String?> parameters) when;

  final void Function(String route,Map<String,String?> parameters,Function quitListening,Function(String route) rerouteTo) run;

 const  OnRouteObserver( {required this.when, required this.run});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnRouteObserver && runtimeType == other.runtimeType && when == other.when && run == other.run;

  @override
  int get hashCode => when.hashCode ^ run.hashCode;
}