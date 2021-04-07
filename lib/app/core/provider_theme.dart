import 'package:flutter/foundation.dart';

class ProviderTheme with ChangeNotifier {
//Creamos una clase "MyProvider" y le agregamos las capacidades de Change Notifier.
/*
La propiedad WITH
Un mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase,
sin heredar de esas clases. Los métodos de esas clases ahora pueden llamarse en su clase, y el código
dentro de esas clases se ejecutará. Dart no tiene herencia múltiple, pero el uso de mixins le permite
plegarse en otras clases para lograr la reutilización del código y evitar los problemas que podría causar
la herencia múltiple.
*/
  bool _light = true;

  set light(bool value) {
    _light = value;
    print("cambiado ${value}");
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  bool get light =>
      _light; //Dentro de nuestro provider, creamos e inicializamos nuestra variable.

  void updateTheme(bool isDarkMode) {
    this._light = isDarkMode;
    notifyListeners();
  }
}
