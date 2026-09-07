
import 'dart:io';
import 'package:src_kstu_app/feature/pages/profile_details.dart';
import 'package:src_kstu_app/feature/pages/user_profile.dart';
import 'package:src_kstu_app/models/user.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/constant.dart';
import 'package:connectivity/connectivity.dart';
class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
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
  final picker = ImagePicker();
  File? pickimage;
   String pickimagePath='';

  String? imageConvert;
  late PickedFile imageFile_;
  final ImagePicker picker_ = ImagePicker();

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
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }
  
 void pickImage(ImageSource src) async {
  var pickedFile = await picker.pickImage(source: src);
  if (pickedFile != null) {
    // String extension = path.basename(pickedFile.path);
    setState(() {
      pickimagePath = pickedFile.path;
      pickimage = File(pickimagePath);
   
    });
    Navigator.of(context).pop();

  } else {
    errDialog();
  }
}


  bool loading = false;

  Future<dynamic> errDialog({String ?msg}){
  return showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      title: Text(
        'Error',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade700,
        ),
      ),
      content: Text(
        msg??'No image picked',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);
}

Future<dynamic> successImageUploadDialog(){
  return showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      title: Text(
        'Success',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
      content: Text(
        'Image Upload Success',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'COOL!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);
}
  Widget bottomSheet() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
        right: Radius.circular(40),
        left: Radius.circular(40),
      )),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: [
        Text("Choose Profile Photo", style: TextStyle(fontSize: 20.0)),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                pickImage(ImageSource.camera);
              },
              child: FaIcon(
                FontAwesomeIcons.camera,

                // color: Colors.grey,
              ),
            ),
            InkWell(
              onTap: () {
                pickImage(ImageSource.gallery);
              },
              child: FaIcon(
                FontAwesomeIcons.image,
                // color: Colors.grey,
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget ImgProfile() {
    print("${user_img_uri}${image}");
    return Center(
      child: Stack(children: [
        (pickimage != null)
            ? CircleAvatar(
                radius: 80.0,
                backgroundImage: FileImage(pickimage!),
              )
            : image != '1'
                ? CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage("${user_img_uri}${image}"),
                  )
                : CircleAvatar(
                    radius: 80.0,
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                  ),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (builder) => bottomSheet());
                },
                child: Icon(Icons.camera_alt, color: Colors.black, size: 30.0)))
      ]),
    );
  }

  void _saveupdatedProfile() async {
    successImageUploadDialog();
    var user = await getUserDetails();
    User userData = user.data as User;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_img", userData.userImg ?? '');

   
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserProfilePage()),
        (route) => false);
  }

  void updateUserProfiles() async {
   if (pickimagePath   == '') {
      setState(() {
        loading = !loading;
      });
  errDialog();
  // pickimagePath is null or empty
} else {
  // pickimagePath is not null or empty
  var connectivityResult = await (Connectivity().checkConnectivity());
   if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
        print('Ye inter');
   var response = await updateUserProfile(pickimagePath);

         if (response.statusCode == 200) {
      setState(() {
        loading = !loading;
      });

      _saveupdatedProfile();
    } else {
        setState(() {
        loading = !loading;
      });
     errDialog(msg:'oops,Kindly use another image');
    }

      }else{
        print('No inter');
         setState(() {
        loading = !loading;
      });
     errDialog(msg:'oops,Kindly connect to the internet');

      }

   
}
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Container(
                      decoration: const BoxDecoration(
                          color: topColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Column(children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserProfilePage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: bottomColor,
                                  size: 20,
                                ),
                              ),
                              const Text(
                                "Update Profile",
                                style: TextStyle(
                                    color: bottomColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ]),
                      ),
                    )),
                    Expanded(
                        flex: 9,
                        child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: bottomColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30))),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 18.0),
                                child: Form(
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      ImgProfile(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ProfileDetails(
                                        subtitle: "${name}",
                                        title: "Full Name",
                                      ),
                                      ProfileDetails(
                                        subtitle: "${email}",
                                        title: "Student Email",
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
                                        subtitle: "${gender}",
                                        title: "Gender",
                                      ),
                                      ProfileDetails(
                                        subtitle: "${level}",
                                        title: "Level",
                                      ),
                                      ProfileDetails(
                                        subtitle: semester == 1 ? 'First' : "Second",
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
                                ))))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: topColor,
          icon: Icon(Icons.send, color: Colors.white,),
          onPressed: () async {
            // print('yoh');
            setState(() {
              loading = !loading;
            });
              updateUserProfiles();

          },
          label: loading
              ? SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? bottomColor : bottomColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                  size: 40,
                )
              : Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
    );
  }
  

}

// ignore: must_be_immutable
class TextFormFields extends StatelessWidget {
  TextFormFields({super.key, required this.title, required this.icons});
  Text title;
  Icon icons;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        label: title,
        prefixIcon: icons,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
