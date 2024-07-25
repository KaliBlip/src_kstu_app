import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/models/api_response.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool ispassword = true;
  bool oldpassword = true;
  bool loading = false;
  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void updatePasswords() async {
    ApiResponse response = await updatePassword(oldPasswordController.text,
        passwordController.text, passwordConfirmationController.text);
    if (response.error == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (contex) => Dashboard()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: topColor,
        elevation: 2.0,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          disabledTextColor: Colors.white,
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
    } else {
      // print('response.data');
      // print(response.data);
      // print('******');
      // print('response.error');
      // print(response.error);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
        backgroundColor: Colors.red.shade700,
        elevation: 2.0,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          disabledTextColor: Colors.white,
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: topColor,
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Row(children: [
                    Container(
                      color: bottomColor,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    Container(
                      color: topColor,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ]),
                  Column(
                    children: [
                      Expanded(
                          // flex: 1,
                          child: Container(
                        height: 20,
                        decoration: const BoxDecoration(
                            color: topColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10),
                          child: Column(children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()),
                                        (route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: bottomColor,
                                    size: 25,
                                  ),
                                ),
                                const Text(
                                  "Update Password",
                                  style: TextStyle(
                                      color: bottomColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ]),
                        ),
                      )),
                      Expanded(
                          flex: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: bottomColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30))),
                            child: Form(
                              key: formkey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 10),
                                      child: TextFormField(
                                        validator: ((value) {
                                          if (value!.isEmpty) {
                                            return "Current password is required";
                                          }
                                          return null;
                                        }),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: oldpassword,
                                        controller: oldPasswordController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          label: Text("Current Password"),
                                          hintText: '',
                                          prefixIcon: Icon(
                                              CupertinoIcons.lock_circle_fill),
                                          suffixIcon: IconButton(
                                            icon: Icon(oldpassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                oldpassword = !oldpassword;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 10),
                                      child: TextFormField(
                                        validator: ((value) {
                                          if (value!.isEmpty) {
                                            return "New Password is required";
                                          }
                                          return null;
                                        }),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        controller: passwordController,
                                        obscureText: ispassword,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          label: Text("New Password"),
                                          hintText: '',
                                          prefixIcon: Icon(
                                              CupertinoIcons.lock_slash_fill),
                                          suffixIcon: IconButton(
                                            icon: Icon(ispassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                ispassword = !ispassword;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 10),
                                      child: TextFormField(
                                        validator: ((value) {
                                          if (value!.isEmpty) {
                                            return "New Password Confirmation is required";
                                          }
                                          return null;
                                        }),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        controller:
                                            passwordConfirmationController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          label: Text("Confirm New Password"),
                                          hintText: '',
                                          prefixIcon:
                                              Icon(CupertinoIcons.lock_fill),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          _dialog.show(
                                              message: 'Updating...',
                                              type:
                                                  SimpleFontelicoProgressDialogType
                                                      .hurricane);
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          _dialog.hide();
                                          if (formkey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                              updatePasswords();
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: topColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: loading
                                                ? SpinKitFadingCircle(
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: index.isEven
                                                              ? bottomColor
                                                              : bottomColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      );
                                                    },
                                                    size: 40,
                                                  )
                                                : Text(
                                                    "Change Password",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

}
