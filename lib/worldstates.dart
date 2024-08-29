import 'package:crona_tracker_app/Model/world_states_model.dart';
import 'package:crona_tracker_app/countries_list.dart';
import 'package:crona_tracker_app/services/stats_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = const <Color>[
    Color(0xff4285F4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatsService statsService = StatsService();
  
    return Scaffold(
  
      body: SafeArea(
  
        child: Padding(
          padding: const EdgeInsets.all(15.0),
       
          child: Column(
       
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
       
              FutureBuilder(
                future: statsService.fetchWorldStatesRecord(),
                builder: (context, AsyncSnapshot<CovidStats> snapshot){
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                dataMap:  {
                  'Total cases': double.parse(snapshot.data!.cases.toString()),
                  'Recovered':double.parse(snapshot.data!.recovered.toString()),
                  'Deaths':double.parse(snapshot.data!.deaths.toString()),
                },
                chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                legendOptions:
                    const LegendOptions(legendPosition: LegendPosition.left),
                animationDuration: const Duration(milliseconds: 1200),
                chartType: ChartType.ring,
                colorList: colorList,
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                  child: Column(
                children: [
                  Reuseable(title: 'Total Cases', value:snapshot.data!.cases.toString()),
                  Reuseable(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                  Reuseable(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                   Reuseable(title: 'Active Cases', value: snapshot.data!.active.toString()),
                  Reuseable(title: 'Crititcal', value: snapshot.data!.critical.toString()),
                  Reuseable(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                   Reuseable(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),

                ],
              )),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const CountriesList()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1aa260),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 50,
                    child: const Center(
                      child: Text(
                        'Track Counteries',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
                      ],
                    );
                  }
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Reuseable extends StatelessWidget {
  String title, value;
  Reuseable({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              
              Text(value),
            ],
          ),
         
          const Divider(),
        ],
      ),
    );
  }
}
