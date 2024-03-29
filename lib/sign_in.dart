// ignore_for_file: missing_return

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:live_tv/helper/database_helper.dart';
import 'package:live_tv/main.dart';
import 'package:live_tv/model/sign_in_model.dart';
import 'package:live_tv/model/model_user.dart' as ModelUser;
import 'package:live_tv/sign_up.dart';

import 'package:live_tv/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({Key key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String s;
  TextEditingController _userName;
  TextEditingController _password;
  setLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged', true);
  }
  void google()async{

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      FirebaseAuth auth = FirebaseAuth.instance;
      User user;
      if (googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication=
        await googleSignInAccount.authentication;

        final AuthCredential credential =  GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
        );
        
        try{
          final UserCredential userCredential = 
          await auth.signInWithCredential(credential);

          user = userCredential.user;

        }
        on FirebaseAuthException catch(e){
          if(e.code == 'account-exists-with-different-credential'){
            print(e.code.toString()+'2');
          }
          else if(e.code == 'invalid-credential'){
            print(e.code.toString()+'3');
          }
        }
        catch(e){
          print(e.toString()+'4');
        }
      }

    // print(user.displayName);
    setLoggedIn();
    ModelUser.User temp=ModelUser.User(id: user.uid, name: user.displayName, email: user.email, image: user.photoURL);
    DatabaseHelper.instance.insert({
      DatabaseHelper.instance.columnUserId:temp.id,
      DatabaseHelper.instance.columnEmail: temp.email,
      DatabaseHelper.instance.columnName: temp.name,
      DatabaseHelper.instance.columnImage: temp.image,
    });
  //  print(user);
   if(user != null)
   { Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
        ModalRoute.withName('/')
    );}
  }

  /*
  void _googleLogin() async {
    try {

      final GoogleSignInAccount googleSignInAccount =
      await googleLogin.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential  credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      final User user = authResult.user;
      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');

        //return '$user';
      }
      // createUser(googleSignInAccount.displayName, googleSignInAccount.email,
      //     googleSignInAccount.id, googleSignInAccount.photoUrl);
      if(googleSignInAccount!=null){
        print("Google sign in successful");
        setLoggedIn();
        ModelUser.User temp=ModelUser.User(id: user.uid, name: user.displayName, email: user.email, image: user.photoURL);
        DatabaseHelper.instance.insert({
          DatabaseHelper.instance.columnUserId:"",
          DatabaseHelper.instance.columnEmail: temp.email,
          DatabaseHelper.instance.columnName: temp.name,
          DatabaseHelper.instance.columnImage: temp.image,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            ModalRoute.withName('/')
        );
        // createUser(googleSignInAccount.displayName, googleSignInAccount.email,
        //     googleSignInAccount.id, googleSignInAccount.email).whenComplete(() {
        //   Navigator.of(context, rootNavigator: true).pop(context);
        //       //signInUser(googleSignInAccount.displayName, googleSignInAccount.email);
        // });
      }
      //Navigator.of(context, rootNavigator: true).pop(context);
    } catch (error) {
      print(error);
      //print('G error');
    }
  }

  */

  Future<UserSignIn> signInUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://amrtvbangla.bmssystems.org/login.php'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {'username': username, 'password': password},
    );
    if(response.statusCode==200){
      setLoggedIn();
      //  var res = jsonDecode(response.body);
       ModelUser.User temp=ModelUser.User(id: "", name: username.replaceFirst(username[0], username[0].toUpperCase()), email: '', image: '');
          DatabaseHelper.instance.insert({
          DatabaseHelper.instance.columnUserId:temp.id,
          DatabaseHelper.instance.columnEmail: temp.email,
          DatabaseHelper.instance.columnName: temp.name,
          DatabaseHelper.instance.columnImage: temp.image,
        }).whenComplete(() => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
          ModalRoute.withName('/')
      ));
      
    }
    
    // print(s);
    return UserSignIn.fromJson(jsonDecode(response.body));
  }

  facebookLogin() async {
    final fb = FacebookLogin();

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
      // Logged in

      // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken;
        // print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        // print('Hello, ${profile.name}! You ID: ${profile.userId}');


        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        // print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) {
          setLoggedIn();
        }
        ModelUser.User temp=ModelUser.User(id: profile.userId, name: profile.name, email: email!=null?email:"", image: imageUrl);
        DatabaseHelper.instance.insert({
          DatabaseHelper.instance.columnUserId:temp.id,
          DatabaseHelper.instance.columnEmail: temp.email,
          DatabaseHelper.instance.columnName: temp.name,
          DatabaseHelper.instance.columnImage: temp.image,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
            ModalRoute.withName('/')
        );

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       settings: RouteSettings(
        //           name: 'Registration'),
        //       builder: (context) => Registration(
        //         user: user,
        //         password: "",
        //         registrationMedia: "Facebook",
        //       )),
        // );

        break;
      case FacebookLoginStatus.cancel:
      // User cancel log in
        break;
      case FacebookLoginStatus.error:
      // Log in failed
        // print('Error while log in: ${res.error}');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _userName = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //iconTheme: IconThemeData(color: Colors.black38),
        title: const Text(
          "Sign In",
          //style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          //color: Colors.black,
          onPressed: () {
            //Navigator.pop(context); returns black screen
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        actions: const <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.login,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {},
          // ),
        ],
        //backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Container(
            //full name
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,

              //boxShadow: kElevationToShadow[6],
            ),
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              controller: _userName,
              // autofillHints: channelNames,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              cursorColor: Colors.red,
              cursorWidth: 2,
              cursorHeight: 20,
              autofocus: false,
              style: const TextStyle(
                color: Colors.black
              ),
              onSubmitted: (string) {},
              onChanged: (string) {},
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                //hintMaxLines: 3,
                hintText: 'User Name',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.drive_file_rename_outline),
                  splashColor: Colors.blue,
                  splashRadius: 5.0,
                  color: Colors.grey,
                  onPressed: () {},
                ),
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
                //fillColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Container(
            //email
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              //boxShadow: kElevationToShadow[6],
            ),
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              controller: _password,
              // autofillHints: channelNames,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              cursorColor: Colors.red,
              cursorWidth: 2,
              cursorHeight: 20,
              autofocus: false,
              style: const TextStyle(
                  color: Colors.black
              ),
              onSubmitted: (string) {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Search(
                //           filteredChannel: filteredChannel,
                //           string: string,
                //           allChannel: allChannels,
                //         )));
              },
              onChanged: (string) {
                // setState(() {
                //   filteredChannel = allChannels
                //       .where((element) => (element.channelname
                //       .toLowerCase()
                //       .contains(string.toLowerCase())))
                //       .toList();
                // });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                //hintMaxLines: 3,
                hintText: 'Password',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.lock),
                  splashColor: Colors.blue,
                  splashRadius: 5.0,
                  color: Colors.grey,
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Search(
                    //           filteredChannel: filteredChannel,
                    //           string: _controller.text,
                    //           allChannel: allChannels,
                    //         )));
                  },
                ),
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
                //fillColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            width: double.infinity,
            height: 30.0,
          ),
          ElevatedButton(
            onPressed: () {
              // print(_userName);
              // print(_password);
              signInUser(_userName.text, _password.text);
              // to be added
              // print(s);
              // if(s!=null){
              //   if(s.contains('Login')){
              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       content: Text(
              //           "Login Successful"),
              //       duration: Duration(seconds: 3),
              //     ));
              //   }
              // }
              //Navigator.of(context, rootNavigator: true).pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.grey
            ),
            child: Container(
              decoration: const BoxDecoration(
                //color: Colors.grey
                // gradient: LinearGradient(
                //   colors: <Color>[
                //     Color(0xFF0D47A1),
                //     Color(0xFF1976D2),
                //     Color(0xFF42A5F5),
                //   ],
                // ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text('Sign In', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text("Don't have Id?"),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: const RouteSettings(name: "Sign up"),
                          builder: (c) => SignUp(),),);
                },
                  child: const Text("Sign Up!",style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),)),
            ],
          ),
          const SizedBox(height: 20.0,),
          SignInButton(
            Buttons.Google,
            onPressed: () {
              google();
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (BuildContext context) => MyApp()),
              //     ModalRoute.withName('/')
              // );
              //print(s);
            },
          ),
          const SizedBox(height: 20.0,),
          SignInButton(Buttons.Facebook, onPressed: (){
            facebookLogin();
          }),
        ],
      ),
    );
  }
}
