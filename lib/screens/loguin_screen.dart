import 'package:flutter/material.dart';
import 'package:loja_virtual/consts.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoguinScreen extends StatefulWidget {
  const LoguinScreen({Key? key}) : super(key: key);

  @override
  _LoguinScreenState createState() => _LoguinScreenState();
}

class _LoguinScreenState extends State<LoguinScreen> {
  @override
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secundaryColor,
          title: const Text("Entrar"),
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
                        if (text!.isEmpty || text.length < 6)
                          return "Senha inválida";
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Insira um e-mail para recuperar!"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            model.recoverPass(_emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Verifique seu e-mail"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: const Duration(seconds: 2),
                            ));
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                          model.signIn(
                              email: _emailController.text,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        },
                        child: const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor)),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 45.0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SingUpScreen()));
                        },
                        child: const Text(
                          "Criar uma conta",
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

  void _onSuccess() => Navigator.of(context).pop();

  void _onFail() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Falha ao Entrar! Tente novamente"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
}
