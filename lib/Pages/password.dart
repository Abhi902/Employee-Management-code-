import 'package:CompanyDatabase/Pages/HomePage.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordVerifier extends StatefulWidget {
  const PasswordVerifier({super.key});

  @override
  State<PasswordVerifier> createState() => _PasswordVerifierState();
}

class _PasswordVerifierState extends State<PasswordVerifier> {
  @override
  Widget build(BuildContext context) {
    return VerificationScreen1();
  }
}

class VerificationScreen1 extends StatefulWidget {
  @override
  _VerificationScreen1State createState() => _VerificationScreen1State();
}

class _VerificationScreen1State extends State<VerificationScreen1> {
  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  int numberOfFields = 4;
  bool clearText = false;
  List<Map<String, dynamic>> userIdentity = [];

  void _fetchCurrentUser() async {
    userIdentity = await FirebaseService.fetchAllUsers();
    print(userIdentity.toString());
  }

  String? code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "JSI",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 23.sp,
            color: fontColor,
            decorationThickness: 5,
            fontFamily: fontFamily,
          ),
        ),
        backgroundColor: themeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
            ),
            Center(
              child: OtpTextField(
                numberOfFields: numberOfFields,
                borderColor: Color(0xFF512DA8),
                focusedBorderColor: themeColor,
                clearText: clearText,
                showFieldAsBox: true,
                textStyle: theme.textTheme.titleMedium,
                onCodeChanged: (String value) {
                  //Handle each value
                },
                handleControllers: (controllers) {
                  //get all textFields controller, if needed
                  controls = controllers;
                },
                onSubmit: (String verificationCode) {
                  //set clear text to clear text from all fields
                  setState(() {
                    clearText = true;
                    code = verificationCode;
                  });

                  //navigate to different screen code goes here
                  if (verificationCode == userIdentity[0]["appPassword"]) {
                    // Password matches, navigate to new screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    // Wrong password, show popup
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Wrong Password'),
                          content: Text('Please enter the correct password.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }, // end onSubmit
              ),
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "This helps us verify every user in our app.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText1,
                ),
              ),
            ),
            Spacer(flex: 3),
            // CustomButton(
            //   onPressed: () {
            //     if (code == userIdentity[0]["appPassword"]) {
            //       // Password matches, navigate to new screen
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => HomePage()),
            //       );
            //     } else {
            //       // Wrong password, show popup
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             backgroundColor: Colors.white,
            //             title: Text('Wrong Password'),
            //             content: Text('Please enter the correct password.'),
            //             actions: [
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.of(context).pop();
            //                 },
            //                 child: Text('OK'),
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     }
            //   },
            //   title: "Confirm",
            //   //¯  color: primaryColor,
            //   textStyle: theme.textTheme.subtitle1?.copyWith(
            //     color: Colors.white,
            //   ),
            // ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.title,
    this.onPressed,
    this.height = 60,
    this.elevation = 1,
    this.color = Colors.purple,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final double height;
  final double elevation;
  final String title;
  final Color color;

  // final BorderSide borderSide;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      height: height.h,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
