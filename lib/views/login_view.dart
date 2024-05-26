import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const TextFieldExampleApp());

class TextFieldExampleApp extends StatelessWidget {
  const TextFieldExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: Login(),
    );
  }
}




class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late TextEditingController _controller;

  late TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }


  @override
    Widget build(BuildContext context) {
    final colors = Theme
        .of(context)
        .colorScheme;


    return Scaffold(
      appBar: AppBar(


          title: const Align(

            alignment: Alignment.center,

            child: Text('Iniciar sesion',style: TextStyle(color: Colors.red),)


      ),),

        body:Center(child:

        Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserInputField(controller: _controller,hint: 'usuario',),
              UserInputField(controller: _controller2, hint: 'contraseña',),
              ElevatedButton(onPressed: (){print('next');}, child: Icon(Icons.login),),
             Column(
                 mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text('¿Nuevo en CitySOS?'),
              TextButton(onPressed: (){print('registrarse');}, child: Text('Registrate ahora',style: TextStyle(color: Colors.red),))
             ])
            ]




        )
    ));
  }

}
class UserInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const UserInputField({required this.controller, required this.hint ,super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: controller,
        decoration:  InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
        ),
        onSubmitted: (String value) async {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thanks!'),
                content: Text(
                  'You typed "$value", which has length ${value.characters
                      .length}.',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}




