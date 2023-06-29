
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      color: const Color.fromARGB(255, 242, 249, 242),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/logo.png'),
                width: 200,
              ),
              const SizedBox(height: 100),
              Text(
                'Eco Adventure',
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 24,
                ),
              ),
              Text('cargando...'),
            ],
          ),
        ),
      )
    );
  }
}