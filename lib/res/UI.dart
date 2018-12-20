import 'package:flutter/material.dart';

class PlayerGradient extends StatelessWidget {
  static final Color color = const Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: (LinearGradient(
            end: FractionalOffset(0.0, 0.0),
            begin: FractionalOffset(0.0, 1.0),
            stops: [
              0.1,
              0.3,
              0.8,
              0.9
            ],
            colors: <Color>[
              color.withOpacity(0.7),
              color.withOpacity(0.5),
              color.withOpacity(0.4),
              color.withOpacity(0.4)
            ],
          )
        )
      )
    );
  }
}