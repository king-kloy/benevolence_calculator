import 'package:benevolence_calculator/src/app.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showPassword = false;
  TextEditingController _username;
  TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 56),
            Container(
                margin: EdgeInsets.all(30),
                child: Image.asset("assets/bg.png")),
            Text("Welcome", style: Theme.of(context).textTheme.headline4),
            Text("Back", style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 56),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _username,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor),
                          ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26)),
                      contentPadding: EdgeInsets.all(12),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          )),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _password,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    keyboardType: TextInputType.text,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).accentColor),
                          ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26)),
                      contentPadding: EdgeInsets.all(12),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).accentColor)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).accentColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        icon: Icon(_showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    shape: StadiumBorder(),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => MyHomePage()));
                    },
                    child: Text('Sign In',
                        style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
