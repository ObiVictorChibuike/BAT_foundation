import 'package:batnf/universal.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void sendEmail({required String email}) async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: email,
      );
      String  url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print( 'Could not launch $url');
      }
    }
    void sendACall({required String phoneNumber}) async {
      final Uri params = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      String  url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print( 'Could not launch $url');
      }
    }
    Future<void> launchUrlStart({required String url}) async {
      if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: const TextWidget(
            text: "Contact Us",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.mail),
                SizedBox(
                  width: 15,
                ),
                TextWidget(
                  text: "Email Address",
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: (){
                sendEmail(email: "BATNF_Foundation@bat.com");
              },
                child: const TextWidget(text: "BATNF_Foundation@bat.com")),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                Icon(Icons.location_on_rounded),
                SizedBox(
                  width: 15,
                ),
                TextWidget(
                  text: "Postal Address",
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const TextWidget(
                text: "BAT Nigeria Foundation, 2, Olumegbon Street Ikoyi, Lagos State, Nigeria."),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 15,
                ),
                TextWidget(
                  text: "Telephone",
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: (){
                sendACall(phoneNumber: "+2347046002033");
              },
                child: const TextWidget(text: "(+234) 7046002033")),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: (){
                  sendACall(phoneNumber: "+2347046002000");
                },
                child: const TextWidget(text: "(+234) 7046002000")),
            const SizedBox(
              height: 30,
            ),
            const TextWidget(
                text: "Follow us across our social media pages for updates"),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: ()=>launchUrlStart(url: "https://www.facebook.com/BATNFoundation/"),
                    child: Image.asset("assets/images/facebook.png")),
                GestureDetector(
                    onTap: ()=>launchUrlStart(url: "https://twitter.com/i/flow/login?redirect_after_login=%2Fbatnfoundation%2F"),
                    child: Image.asset("assets/images/twitter.png")),
                GestureDetector(
                    onTap: ()=>launchUrlStart(url: "https://www.instagram.com/batnfoundation/"),
                    child: Image.asset("assets/images/insta.png")),
                GestureDetector(
                    onTap: ()=>launchUrlStart(url: "https://www.youtube.com/channel/UCektzc9hBeVRLPqEsQuqfzQ"),
                    child: Image.asset("assets/images/youtube.png")),
                GestureDetector(
                    onTap: ()=>launchUrlStart(url: "https://www.linkedin.com/company/batnfoundation/"),
                    child: Image.asset("assets/images/linkedin.png")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
