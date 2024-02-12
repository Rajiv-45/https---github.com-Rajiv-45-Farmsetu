import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool progressindicator = false;
  List<String> regions = [
    'England',
    'Wales',
    'Scotland',
    'Northern Ireland',
    'England & Wales',
    'England N',
    'England S',
    'Scotland N',
    'Scotland E',
    'Scotland W',
    'England E & NE',
    'England NW/Wales N',
    'Midlands',
    'East Anglia',
    'England SW/Wales S',
    'England SE/Central S'
  ];
  List<String> regions2 = [
    'England',
    'Wales',
    'Scotland',
    'Northern Ireland',
    'England & Wales',
    'England N',
    'England S',
    'Scotland N',
    'Scotland E',
    'Scotland W',
    'England E & NE',
    'England NW/Wales N',
    'Midlands',
    'East Anglia',
    'England SW/Wales S',
    'England SE/Central S'
  ];
  List<String> parameter = [
    'Max temp',
    'Min temp',
    'Mean temp',
    'Sunshine',
    'Rainfall',
    'Rain days >= 21.0mm',
    'Days of air frost',
  ];
  List<String> parameter2 = [
    'Tmax',
    'Tmin',
    'Mean temp',
    'Sunshine',
    'Rainfall',
    'Rain days >= 21.0mm',
    'Days of air frost',
  ];

  String getParameter(String val) {
    return parameter2[parameter.indexOf(val)];
  }

  String getRegion(String val) {
    return val.replaceAll(' ', '_');
  }

  List<String> data = [];
  String? selectedRegion;
  String? selectedParameter;
  bool rank = false;
  bool year = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 100,
              child: SvgPicture.network(
                  "https://assets-global.website-files.com/61488622a1cd5425b4941603/65898e0a111941704502051e_landing-banner-01Artboard%201.svg"),
            ),
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Welcome to Farmsetu',
                  style: TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                    value: rank,
                    onChanged: (val) {
                      setState(() {
                        rank = val!;
                      });
                    }),
                const Text(
                  'Rank ordered statistics',
                  style: TextStyle(
                      fontFamily: "Urbanist", fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: year,
                    onChanged: (val) {
                      setState(() {
                        year = val!;
                      });
                    }),
                const Text(
                  'Year ordered statistics',
                  style: TextStyle(
                      fontFamily: "Urbanist", fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                value: selectedRegion,
                hint: const Text(
                  'Select a Region',
                  style: TextStyle(
                      fontFamily: "Urbanist", fontWeight: FontWeight.w600),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedRegion = newValue!;
                  });
                },
                items: regions.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                value: selectedParameter,
                hint: const Text(
                  'Select a Parameter',
                  style: TextStyle(
                      fontFamily: "Urbanist", fontWeight: FontWeight.w600),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedParameter = newValue!;
                  });
                },
                items: parameter.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedRegion != null && selectedParameter != null) {
                  setState(() {
                    progressindicator = true;
                  });
                  String url =
                      'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/${getParameter(selectedParameter!)}/${rank ? 'ranked' : ''}${year ? 'year' : ''}/${getRegion(selectedRegion!)}.txt';
                  print("URL: $url");
                  progressindicator = true;
                  final res = await http.get(
                    Uri.parse(url),
                  );
                  print(res.body);
                  List<String> datal = res.body.split('\n');
                  setState(() {
                    data = datal.sublist(5);
                    progressindicator = false;
                  });
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontFamily: "Urbanist",
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (data.isNotEmpty)
              SizedBox(
                height: data.length * (40),
                child: Column(
                  children: [
                    if (progressindicator) Text("Wait it is loading"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        List<String> datal = data[i].split(' ');
                        return SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListView.separated(
                            itemCount: datal.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, idx) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemBuilder: (context, idx) {
                              if (i == 0) {
                                return Text(
                                  datal[idx],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Urbanist"),
                                );
                              } else {
                                return Text(
                                  datal[idx],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (data.isEmpty)
              Column(
                children: [
                  Text(
                    "No data found",
                    style: TextStyle(fontFamily: "Urbanist"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (progressindicator) Text("Wait it is Loading")
                ],
              )
          ]),
        ),
      ),
    );
  }
}
