import 'package:upgrader/upgrader.dart';

class SpanishMessages extends UpgraderMessages {
  @override
  String get title => 'Actualización disponible';

  @override
  String get body =>
      'Hay una nueva versión disponible, actualiza la aplicación para continuar';

  @override
  String get buttonTitleUpdate => 'Actualizar';

  @override
  String get prompt => 'Ve a la tienda de aplicaciones para actualizar';
}
