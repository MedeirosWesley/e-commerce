import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic> userData = {};

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  void signUp(
      {@required Map<String, dynamic>? userData,
      @required String? pass,
      @required VoidCallback? onSuccess,
      @required VoidCallback? onFail}) {
    setLoad();
    _auth
        .createUserWithEmailAndPassword(
            email: userData!["email"], password: pass!)
        .then((u) async {
      user = u.user;

      await _saveUserData(userData);

      onSuccess!();
      setLoad();
    }).catchError((e) {
      onFail!();
      setLoad();
    });
  }

  void signIn(
      {@required String? email,
      @required String? pass,
      @required VoidCallback? onSuccess,
      @required VoidCallback? onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email!, password: pass!)
        .then((u) async {
      user = u.user;

      await _loadCurrentUser();
      onSuccess!();
      setLoad();
    }).catchError((e) {
      onFail!();
      setLoad();
    });
    await Future.delayed(const Duration(seconds: 3));
  }

  void setLoad() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set(userData);
  }

  bool isLoggedIn() {
    return user != null;
  }

  void signOut() async {
    await _auth.signOut();
    userData = {};
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    user ??= _auth.currentUser!;
    if (user != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }
}
