import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const TextFieldExampleApp());

class TextFieldExampleApp extends StatelessWidget {
  const TextFieldExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late List<TextEditingController> _controller;

  String? _selectedDistrict;

  final List<String> districts = ['San Isidro','Pueblo Libre','Jesus Maria','San Miguel'];

  @override
  void initState() {
    super.initState();
    _controller = List.generate(6, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var con in _controller){
      con.dispose();
  }
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

              child: Text('Crear cuenta',style: TextStyle(color: Colors.red),)


          ),),

        body:Center(child:

        Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserInputField(controller: _controller[0],hint: 'nombre',),
              UserInputField(controller: _controller[1], hint: 'apellido',),
              UserInputField(controller: _controller[2], hint: 'celular',),
              UserInputField(controller: _controller[3], hint: 'dni',),
              UserInputField(controller: _controller[4], hint: 'correo',),
              UserInputField(controller: _controller[5], hint: 'contraseña',),
              DropdownButton<String>(
                hint: Text('Selecciona un distrito'),
                value: _selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                  });
                },
                items: districts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

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

