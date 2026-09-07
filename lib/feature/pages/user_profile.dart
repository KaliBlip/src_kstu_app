import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/profile_details.dart';
import 'package:src_kstu_app/feature/pages/update_profile.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var name;
  var index;
  var yearOfCompletion;
  var yearOfAdmission;
  var email;
  var gender;
  var semester;
  var level;
  var image;
  var faculty;
  var department;
  var program;
  var phone;
  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('name');
      department = localStorage.getString('department');
      program = localStorage.getString('program');
      faculty = localStorage.getString('faculty');
      email = localStorage.getString('email');
      yearOfCompletion = localStorage.getString('yrOfCompletion');
      yearOfAdmission = localStorage.getString('yrOfAdmission');
      gender = localStorage.getString('gender');
      image = localStorage.getString('user_img');
      index = localStorage.getInt('index');
      phone = localStorage.getString('phone');
      semester = localStorage.getInt('semester');
      level = localStorage.getString('level');
    });
    // print(image);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return Scaffold(
      backgroundColor: topColor,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: topColor,
          icon: Icon(CupertinoIcons.layers, color: Colors.white,),
          onPressed: () async {
            _dialog.show(
                message: 'Waiting...',
                type: SimpleFontelicoProgressDialogType.hurricane);
            await Future.delayed(Duration(seconds: 1));
            _dialog.hide();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateProfilePage()));
          },
          label: Text('Edit Profile', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),)),
      body: Center(
              child: Padding(
      padding: const EdgeInsets.only(top: 40),
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
                    flex: 4,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: const BoxDecoration(
                          color: topColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard()),
                                            (route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: bottomColor,
                                    size: 25,
                                  ),
                                ),
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: bottomColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  maxRadius: 60,
                                  minRadius: 60,
                                  backgroundColor: bottomColor,
                                  backgroundImage: image != "1"
                                      ? NetworkImage(
                                          "${user_img_uri}${image}")
                                      : NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${name}",
                                  style: GoogleFonts.poppins(
                                      color: bottomColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${yearOfAdmission} - ${yearOfCompletion}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: bottomColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            ProfileDetails(
                              subtitle: "${name}",
                              title: "Full Name",
                            ),
                            ProfileDetails(
                              subtitle: "${index}",
                              title: "Student Number",
                            ),
                            ProfileDetails(
                              subtitle: "${phone}",
                              title: "Phone Number",
                            ),
                            ProfileDetails(
                              subtitle: "${gender}",
                              title: "Gender",
                            ),
                            ProfileDetails(
                              subtitle: "${email}",
                              title: "Student Email",
                            ),
                            ProfileDetails(
                              subtitle: "${department}",
                              title: "Department",
                            ),
                            ProfileDetails(
                              subtitle: "${program}",
                              title: "Program",
                            ),
                            ProfileDetails(
                              subtitle: "${faculty}",
                              title: "Faculty",
                            ),
                            ProfileDetails(
                              subtitle: "${level}",
                              title: "Level",
                            ),
                            ProfileDetails(
                              subtitle: '${semester}',
                              title: "Semester",
                            ),
                            ProfileDetails(
                              subtitle: '${yearOfAdmission}',
                              title: "Year Of Admission",
                            ),
                            ProfileDetails(
                              subtitle: '${yearOfCompletion}',
                              title: "Year Of Completion",
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
              ),
            ),
    );
  }
}
