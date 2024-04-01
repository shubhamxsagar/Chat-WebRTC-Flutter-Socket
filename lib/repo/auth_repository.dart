// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:the_haha_guys/core/type_defs.dart';
// import 'package:the_haha_guys/models/user_model.dart';

// class AuthRepository {
//   final GoogleSignIn _googleSignIn;

//   AuthRepository({required GoogleSignIn googleSignIn})
//       : _googleSignIn = googleSignIn;

//       FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async{
//         try{
//           final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//           final googleAuth = await googleUser?.authentication;

//           final DateTime expirationTime = DateTime.now().add(
//         Duration(seconds: googleAuth?.idToken != null ? 3600 : 3600), // Adjust the duration based on your use case
//       );

//           final credential = auth.AccessCredentials(
//             auth.AccessToken('Bearer', googleAuth!.accessToken!, expirationTime,),
//             googleAuth.idToken,
//             ['email'],
//         );

//           if(isFromLogin){

//           }
//         }
//       }
// }
