import 'package:flutter/material.dart';
import 'package:loja_virtual/consts.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: secundaryColor,
          title: const Text("Criar conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(hintText: "Nome Completo"),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Nome inválido";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _adressController,
                      decoration: const InputDecoration(hintText: "Endereço"),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Nome inválido";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text!.isEmpty || !text.contains("@")) {
                          return "E-mail inválido";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _passController,
                      decoration: const InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text!.isEmpty || text.length < 6) {
                          return "Senha inválida";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "adress": _adressController.text
                            };
                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail);
                          }
                        },
                        child: const Text(
                          "Criar conta",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor)),
                      ),
                    ),
                  ],
                ));
          },
        ));
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 2),
    ));
    Future.delayed(const Duration(seconds: 2))
        .then((value) => Navigator.of(context).pop());
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Falha ao criar usuário! Tente novamente"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}
