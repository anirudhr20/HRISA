import 'package:flutter/material.dart';
import 'package:hrisa/screens/input_page.dart';
import 'package:hrisa/screens/login_page.dart';
import 'package:hrisa/custom_widgets/bottom_button.dart';
import 'package:hrisa/utilities/constants.dart';
import 'package:hrisa/utilities/advices.dart';
import 'package:hrisa/utilities/firestore_write.dart';
import 'package:hrisa/utilities/sms_report.dart';
import 'package:hrisa/utilities/pdf_hrisa.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:open_file/open_file.dart';

class Recommendation extends StatefulWidget {
  static const routeName = 'Recommendation';

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  String hrisaRecomendation = "";
  bool showSpinner = false;

  Future<void> sendToCollection() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await createHrisaPatientDocument();
     // await sendReport(); //in utilities/send_report.dart
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Recommendation',
            style: kHrisaText,
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ListView(
              children: <Widget>[
                Text(
                  'Recommendation/Advice',
                  style: kHrisaText.copyWith(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                Text(
                  advices[hrisaValues.hrisaRisk],
                  style: kHrisaText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                BottomButton(
                  text: 'Finish',
                  onPressed: () {
                    //createHrisaPatientDocument();
                  },
                ),
                BottomButton(
                  text: 'Print PDF',
                  onPressed: () {
                    generatePdf();
                    OpenFile.open(pathToPdf);
                  },
                ),
                BottomButton(
                  text: 'Screen Next',
                  onPressed: () async {
//                    hrisaValues.hrisaRecommendation = advices[hrisaValues.hrisaRisk];
                    print(user.uid);
                    try {
                      await sendToCollection();
                      await sendReport();

                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          InputPage.routeName,
                          ModalRoute.withName(LoginPage.routeName));
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                ),
                BottomButton(
                  text: 'Log Out',
                  onPressed: () async {
//                    hrisaValues.hrisaRecommendation = advices[hrisaValues.hrisaRisk];
                    print(user.uid);
                    try {
                      await sendToCollection();
                      await sendReport();
                      await auth.signOut();

                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginPage.routeName,
                          ModalRoute.withName(LoginPage.routeName));
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
