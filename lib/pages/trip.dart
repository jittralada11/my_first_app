import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late Future<void> loadData;
  late GetTripsRespones tripIdxGetResponse;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายละเอียดทริป")),
      body: Column(
        children: [
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripIdxGetResponse.name,
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      tripIdxGetResponse.country,
                      style: TextStyle(fontSize: 20),
                    ),
                    Image.network(
                      tripIdxGetResponse.coverimage,
                      width: 400,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          SizedBox(width: 180, height: 120),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tripIdxGetResponse.price} บาท'),
                        Text(tripIdxGetResponse.destinationZone),
                      ],
                    ),
                    Text(tripIdxGetResponse.detail),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () {},
                          child: const Text('จองเลย!!!'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              // return Text(widget.idx.toString(), style: TextStyle(fontSize: 50));
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    log("trst");
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = getTripsResponesFromJson(res.body);
  }
}
