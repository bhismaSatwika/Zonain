import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonain/common/navigation.dart';
import 'package:zonain/common/style.dart';
import 'package:zonain/model/user_details.dart';
import 'package:zonain/provider/map_provider.dart';
import 'package:zonain/ui/profile_page.dart';
import 'package:zonain/ui/see_reports_page.dart';
import 'package:zonain/widget/report_bottom_sheet.dart';
import 'package:zonain/widget/user_map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBackground,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigation.intentWithData(
                  Profile.routeName,
                  UserDetails(
                      "Sievin",
                      'https://i.pinimg.com/originals/26/42/26/26422665b452967ebc301deadb2a036d.jpg',
                      'Jalan Pulau Bali No 50'));
            },
            child: ClipRRect(
              child: Image.network(
                'https://i.pinimg.com/originals/26/42/26/26422665b452967ebc301deadb2a036d.jpg',
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        title: const Text('Sievin'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => MapProvider(),
        builder: (ctx, _) {
          return Column(
            children: [
              Container(
                color: appBackground,
                width: width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Alarm'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Emergency call'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 3,
                child: MapWidget(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: appBackground,
                  height: 100,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text('Report Crime'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (ctx) => const ReportBottomSheet(),
                          ).then((value) {
                            Provider.of<MapProvider>(ctx, listen: false)
                                .getReports();
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, SeeReportsPage.routeName);
                        },
                        child: const Text('See Report'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
