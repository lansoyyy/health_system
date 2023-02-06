import 'package:flutter/material.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';

import '../../widgets/text_widget.dart';

class AboutUsTab extends StatelessWidget {
  const AboutUsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('user') == 'admin'
          ? FloatingActionButton(
              backgroundColor: primary,
              onPressed: (() {}),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ))
          : const SizedBox(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        image: AssetImage('assets/images/cover.png'),
                        fit: BoxFit.fitWidth,
                        opacity: 1)),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: TextRegular(
                    text:
                        'We are a team of dedicated professionals who are committed to helping the health professionals and medical workers of the municipality of Sumilao. We understand the importance of accurate and up-to-date information in the fight against COVID-19, and that is why we have created a website that utilizes Geographic Information Systems to track the locations of patients and provide data on the patients in a specific area.\n\nOur website is user-friendly and easy to navigate, allowing health professionals and medical workers to quickly access the information they need. We are constantly updating our database to ensure that the information we provide is accurate and up-to-date. We believe that by providing this valuable service, we can help to improve the health and well-being of the people in the municipality of Sumilao.\n\nOur vision is to create a world where health professionals and medical workers have access to the most accurate and up-to-date information, in order to better serve their communities and save lives. We strive to empower them with the tools they need to make informed decisions and respond quickly to the evolving needs of their patients',
                    fontSize: 20,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/mapsumil.png',
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: TextRegular(
                    text:
                        'We, the team behind the website, would like to take a moment to express our deepest gratitude for the tireless work that you do every day.\n\nWe understand the challenges that you face on the front lines of the fight against COVID-19, and we are honored to be able to provide you with the tools you need to make informed decisions and respond quickly to the evolving needs of your patients.\n\nThe support and feedback we received from you have been invaluable in the development of our website, and we are proud to have been able to make a difference in the fight against COVID-19. We would like to thank you for your trust in our team, and for your dedication to improving the health and well-being of the people in the municipality of Sumilao.\n\nWe will continue to work tirelessly to improve our website and provide you with the most accurate and up-to-date information, and we look forward to your continued support and collaboration.',
                    fontSize: 20,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(
                          text: "Let's stay in touch",
                          fontSize: 24,
                          color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          TextRegular(
                              text: '+(63) 9505937901',
                              fontSize: 14,
                              color: Colors.black)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded),
                          const SizedBox(
                            width: 10,
                          ),
                          TextRegular(
                              text: '8701 Sumilao, Bukidon',
                              fontSize: 14,
                              color: Colors.black)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
