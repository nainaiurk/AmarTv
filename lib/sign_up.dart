
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:live_tv/helper/database_helper.dart';
import 'package:live_tv/main.dart';
import 'package:live_tv/model/model_user.dart' as ModelUser;
import 'package:live_tv/sign_in.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

//import 'package:live_tv/user_sign_up_model.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Registration(),
      theme: themeNotifier.getTheme(),
    );
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  //final facebookLogin = FacebookLogin();

  final googleLogin = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount _currentUser;
  Map userProfile;
  String s;
  bool loggedIn = false;
  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _userNameController;
  TextEditingController _passwordController;



  Future<void> createUser(
      String fullName, String email, String userName, String password) async {
    final response = await http.post(
      Uri.parse('https://amrtvbangla.bmssystems.org/signup.php'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {
        'fullname': fullName,
        'email': email,
        'username': userName,
        'password': password,
      },
    );
    if(response.statusCode==200){
      setLoggedIn();
      ModelUser.User temp=ModelUser.User(id: "", name: _fullNameController.text, email: _emailController.text, image: "");
      DatabaseHelper.instance.insert({
        DatabaseHelper.instance.columnUserId:"",
        DatabaseHelper.instance.columnEmail: temp.email,
        DatabaseHelper.instance.columnName: temp.name,
        DatabaseHelper.instance.columnImage: temp.image,
      }).whenComplete(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            ModalRoute.withName('/')
        );
      });

    }
    else{
      print(response.statusCode);
      print(response.body);
    }

    s = response.body;
    //print(s);
    //print(User.fromJson(jsonDecode(response.body)));
    //return User.fromJson(JSON.jsonDecode(response.body));
  }


  setLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged', true);
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userNameController = TextEditingController();
    googleLogin.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
      }
    });
    googleLogin.signInSilently();
  }

  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //iconTheme: IconThemeData(color: Colors.black38),
        title: const Text(
          "Sign Up",
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
      body: SingleChildScrollView(
        child: Column(
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
              padding: EdgeInsets.only(left: 16),
              child: TextField(
                controller: _fullNameController,
                // autofillHints: channelNames,
                enableInteractiveSelection: true,
                style: TextStyle(
                    color: Colors.black
                ),
                enableSuggestions: true,
                cursorColor: Colors.red,
                cursorWidth: 2,
                cursorHeight: 20,
                autofocus: false,
                onSubmitted: (string) {},
                onChanged: (string) {},
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  //hintMaxLines: 3,
                  hintText: 'Full Name',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.drive_file_rename_outline),
                    splashColor: Colors.blue,
                    splashRadius: 5.0,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  hintStyle: TextStyle(color: Colors.black54),
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
              padding: EdgeInsets.only(left: 16),
              child: TextField(
                controller: _emailController,
                // autofillHints: channelNames,
                enableInteractiveSelection: true,
                style: TextStyle(
                    color: Colors.black
                ),
                enableSuggestions: true,
                cursorColor: Colors.red,
                cursorWidth: 2,
                cursorHeight: 20,
                autofocus: false,
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
                  hintText: 'Email',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.email_outlined),
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
                  hintStyle: TextStyle(color: Colors.black54),
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
              //user name
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
                //boxShadow: kElevationToShadow[6],
              ),
              padding: EdgeInsets.only(left: 16),
              child: TextField(
                controller: _userNameController,
                // autofillHints: channelNames,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                style: TextStyle(
                    color: Colors.black
                ),
                cursorColor: Colors.red,
                cursorWidth: 2,
                cursorHeight: 20,
                autofocus: false,
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
                  hintText: 'User Name',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.supervised_user_circle),
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
                  hintStyle: TextStyle(color: Colors.black54),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
                //boxShadow: kElevationToShadow[6],
              ),
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                controller: _passwordController,
                // autofillHints: channelNames,
                enableInteractiveSelection: true,
                style: const TextStyle(
                    color: Colors.black
                ),
                enableSuggestions: true,
                cursorColor: Colors.red,
                cursorWidth: 2,
                cursorHeight: 20,
                autofocus: false,
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
                    icon: Icon(Icons.lock),
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
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  //fillColor: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 30.0,
            ),
            RaisedButton(
              color: Colors.grey,
              onPressed: () {
                print(_fullNameController.text);
                print(_emailController.text);
                print(_userNameController.text);
                print(_passwordController.text);
                createUser(_fullNameController.text, _emailController.text,
                    _userNameController.text, _passwordController.text);
                //to be added

                print(s);

              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: <Color>[
                  //     Color(0xFF0D47A1),
                  //     Color(0xFF1976D2),
                  //     Color(0xFF42A5F5),
                  //   ],
                  // ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 50.0,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Text(
                    "Already a User?",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                 const SizedBox(width: 10,),
                 InkWell(
                   onTap: (){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             settings: const RouteSettings(name: "Sign in"),
                             builder: (c) => SignIn()));
                   },
                   child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 20.0,
                      ),
                    ),
                 ),

              ],
            ),
            // (s != null)
            //     ? (s.isEmpty)
            //         ? Container(
            //             width: double.infinity,
            //             height: 30.0,
            //           )
            //         : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //             content: Text(s),
            //             duration: Duration(seconds: 3),
            //           ))
            //     : Container(),
            const SizedBox(
              height: 50.0,
              width: double.infinity,
            ),

                // InkWell(
                //   splashColor: Colors.yellow,
                //   onTap: (){
                //     _fbLogin();
                //    // print(userProfile["name"]);
                //   },
                //   child: Container(
                //     height: 50.0,
                //     width: 50.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       //borderRadius: BorderRadius.all(Radius.circular(5)),
                //       image: DecorationImage(
                //         image: AssetImage('assets/image/facebook.png'),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),

                // SignInButton(
                //   Buttons.Facebook,
                //   onPressed: login,
                //   text: 'Sign In with Facebook',
                // ),
                /*SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    _googleLogin();
                    //global.setTrue();
                    //print(s);
                  },
                )
              ,*/
            SignInButton(
              Buttons.FacebookNew,
              onPressed: () {
                facebookLogin();
                //global.setTrue();
                //print(s);
              },
            )

          ],
        ),
      ),
    );
  }

//   _googleLogin() async {
// ignore: todo
// // TODO: have to integrate for ios
//     try {
//       final GoogleSignInAccount googleSignInAccount =
//           await googleLogin.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       final UserCredential authResult =
//           await _auth.signInWithCredential(credential);
//       final User user = authResult.user;
//       if (user != null) {
//         assert(!user.isAnonymous);
//         assert(await user.getIdToken() != null);
//
//         final User currentUser = _auth.currentUser;
//         assert(user.uid == currentUser.uid);
//
//         print('signInWithGoogle succeeded: $user');
//
//         //return '$user';
//       }
//       if(googleSignInAccount!=null){
//         //createUser(googleSignInAccount.displayName, googleSignInAccount.email,
//             //googleSignInAccount.id, googleSignInAccount.email);
//         setLoggedIn();
//         ModelUser.User temp=ModelUser.User(id: user.uid, name: user.displayName, email: user.email, image: user.photoURL);
//         DatabaseHelper.instance.insert({
//           DatabaseHelper.instance.columnUserId:"",
//           DatabaseHelper.instance.columnEmail: temp.email,
//           DatabaseHelper.instance.columnName: temp.name,
//           DatabaseHelper.instance.columnImage: temp.image,
//         });
//         print("Google sign in successful");
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (BuildContext context) => MyApp()),
//             ModalRoute.withName('/')
//         );
//       }
//     } catch (error) {
//       print(error);
//     }
//   }


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
        print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile.name}! You ID: ${profile.userId}');


        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null)
          print('And your email is $email');
        setLoggedIn();
        ModelUser.User temp=ModelUser.User(id: profile.userId, name: profile.name, email: email!=null?email:"", image: imageUrl);
        DatabaseHelper.instance.insert({
          DatabaseHelper.instance.columnUserId:temp.id,
          DatabaseHelper.instance.columnEmail: temp.email,
          DatabaseHelper.instance.columnName: temp.name,
          DatabaseHelper.instance.columnImage: temp.image,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            ModalRoute.withName('/')
        );


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
}
