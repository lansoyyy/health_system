import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBold(
                text: 'NEWS AND UPDATES', fontSize: 24, color: Colors.black),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 800,
              child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: ((context, index) {
                    return const Divider();
                  }),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                                child: const Center(
                                  child: Text('Image here'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextBold(
                                  text: 'Headline',
                                  fontSize: 18,
                                  color: Colors.black),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBold(
                                  text: 'Title',
                                  fontSize: 22,
                                  color: Colors.black),
                              SizedBox(
                                width: 500,
                                child: TextRegular(
                                    text:
                                        'Deserunt occaecat qui voluptate consequat. Deserunt qui amet dolore tempor aliqua esse aliquip amet laborum qui duis qui. Labore eiusmod culpa officia ullamco aliqua anim sit quis adipisicing labore. Et est nulla nostrud ut in do incididunt incididunt commodo. Cillum est officia mollit nulla do consectetur Lorem aliqua duis cillum. Voluptate nostrud ad dolor ea elit sit quis fugiat. Dolor incididunt tempor sint esse quis deserunt est aliquip incididunt exercitation elit proident. Do sint consectetur veniam anim aliqua sint incididunt tempor. Proident aliqua pariatur aliqua in ipsum minim nisi exercitation dolore do quis occaecat irure. Tempor ut ea nulla occaecat aute amet. Aute aliqua officia anim eiusmod laboris aliquip duis. Sint culpa elit consectetur enim esse reprehenderit Lorem. Enim culpa velit laboris fugiat officia cupidatat exercitation id. Ex anim nulla duis fugiat velit. Sint amet id labore sint do officia do aute tempor anim. Lorem fugiat commodo commodo ut sint cupidatat esse duis labore. Qui laboris laboris sunt non commodo dolor id eiusmod minim irure. Officia esse labore quis anim mollit aliqua. Elit velit commodo ipsum magna ullamco officia reprehenderit ullamco ut mollit fugiat. Est quis consequat adipisicing nostrud irure. Tempor tempor excepteur ea esse non occaecat incididunt officia nisi duis. Enim incididunt aliquip dolor ut officia reprehenderit ullamco sit ullamco pariatur laboris sunt. Occaecat officia fugiat sit officia nulla esse in sint cupidatat mollit. Ipsum proident tempor veniam nulla sint amet aliquip. Elit magna exercitation nulla esse fugiat do. Adipisicing eu commodo ipsum qui elit sit do quis elit ipsum dolore elit do id. Elit sint sunt eu proident qui mollit commodo excepteur. Cillum fugiat pariatur in veniam Lorem ad amet cupidatat deserunt amet ad magna enim. Ullamco ad commodo est dolore ex Lorem adipisicing esse ipsum qui et minim. Occaecat ut proident laborum est veniam incididunt cillum nulla aliqua eu nostrud deserunt sit. Amet sunt qui enim consectetur. Adipisicing nisi culpa dolor sint laborum. Non anim ea anim enim eiusmod cupidatat sunt. Laborum eu laboris minim eiusmod laborum incididunt adipisicing cupidatat non culpa do laboris irure cillum. Voluptate voluptate sint minim tempor incididunt. Ipsum velit dolore exercitation excepteur magna. Minim ad eu commodo deserunt ad incididunt dolore cillum. Do culpa est nostrud aliquip. Occaecat minim exercitation aute nulla aliqua duis enim amet pariatur. Non minim voluptate ad anim exercitation do veniam aliquip ut veniam exercitation elit. Est ipsum cupidatat do laboris sunt fugiat esse ut aliquip tempor. Exercitation laborum ipsum ex excepteur sunt exercitation exercitation non non eu fugiat nulla. Quis ullamco proident magna sunt velit ea dolore non. Velit eiusmod irure incididunt aute proident excepteur enim id labore quis laboris. Occaecat minim sunt laboris reprehenderit dolore quis ut ex consequat dolor cillum nisi. Eu officia ad laborum exercitation fugiat consectetur excepteur labore proident reprehenderit ad id in. Veniam dolor magna quis esse irure et occaecat qui.',
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
