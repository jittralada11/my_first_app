import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/response/get_trips_respones.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  List<GetTripsRespones> getTripsRespones = [];
  String url = '';
  late Future<void> loadData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData = getTrips();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    getTripsRespones = getTripsResponesFromJson(res.body);
    log(getTripsRespones.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false, // ซ่อนลูกศรย้อนกลับ
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('ข้อมูลส่วนตัว'), value: 'profile'),
              PopupMenuItem(child: Text('ออกจากระบบ'), value: 'logout'),

              // const PopupMenuItem<String>(value: 'profile', child: Text('')),
              // const PopupMenuItem<String>(
              //   value: 'logout',
              //   child: Text('ออกจากระบบ'),
              // ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ปลายทาง',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => getTrips(),
                          child: const Text('ทั้งหมด'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            getTripAsia();
                          },
                          child: const Text('เอเชีย'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            getTripThai();
                          },
                          child: const Text('ประเทศไทย'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            getTripEuro();
                          },
                          child: const Text('ยุโรป'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            getTripSouthAsia();
                          },
                          child: const Text('เอเชียตะวันออกเฉียงใต้'),
                        ),
                        // const SizedBox(width: 8),
                        // FilledButton(
                        //   onPressed: () {},
                        //   child: const Text('อเมริกาใต้'),
                        // ),
                        // const SizedBox(width: 8),
                        // FilledButton(
                        //   onPressed: () {},
                        //   child: const Text('ออสเตรเลีย'),
                        // ),
                        // const SizedBox(width: 8),
                        // FilledButton(
                        //   onPressed: () {},
                        //   child: const Text('อเมริกาเหนือ'),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: getTripsRespones
                          .map(
                            (trip) => Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(trip.name),
                                  Row(
                                    children: [
                                      Image.network(
                                        trip.coverimage,
                                        width: 180,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(
                                                  width: 180,
                                                  height: 120,
                                                ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // จัดข้อความชิดซ้าย
                                        children: [
                                          Text(
                                            trip.country,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text('ระยะเวลา: ${trip.duration}'),
                                          const SizedBox(height: 2),
                                          Text('ราคา: ${trip.price}'),
                                          const SizedBox(height: 12),
                                          FilledButton(
                                            onPressed: () => gotoTrip(trip.idx),
                                            child: const Text(
                                              'รายละเอียดเพิ่มเติม',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // const SizedBox(height: 24),
                  // ...trips.map((trip) => TripCard(trip: trip)).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
    // เพิ่ม logic การเปิดหน้ารายละเอียดที่นี่
  }

  Future<void> getTrips() async {
    log("url:$url");
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));

    log("apiendpoint:$API_ENDPOINT");
    setState(() {
      getTripsRespones = getTripsResponesFromJson(res.body);
      log(res.body);
      log(getTripsRespones.length.toString());
    });
  }

  // getTrips

  Future<void> getTripAsia() async {
    log("url:$url");
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));

    var allTrips = getTripsResponesFromJson(res.body);

    var asiaTrips = allTrips
        .where((trip) => trip.destinationZone.toUpperCase() == "เอเชีย")
        .toList();

    log("apiendpoint:$API_ENDPOINT");
    setState(() {
      // getTripsRespones = getTripsResponesFromJson(res.body);
      getTripsRespones = asiaTrips;
      log(res.body);
      log(getTripsRespones.length.toString());
    });
  }

  Future<void> getTripSouthAsia() async {
    log("url:$url");
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));

    var allTrips = getTripsResponesFromJson(res.body);

    var getTripSouthAsia = allTrips
        .where(
          (trip) =>
              trip.destinationZone.toUpperCase() == "เอเชียตะวันออกเฉียงใต้",
        )
        .toList();

    log("apiendpoint:$API_ENDPOINT");
    setState(() {
      // getTripsRespones = getTripsResponesFromJson(res.body);
      getTripsRespones = getTripSouthAsia;
      log(res.body);
      log(getTripsRespones.length.toString());
    });
  }

  Future<void> getTripThai() async {
    log("url:$url");
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));

    var allTrips = getTripsResponesFromJson(res.body);

    var getTripThai = allTrips
        .where((trip) => trip.destinationZone.toUpperCase() == "ประเทศไทย")
        .toList();

    log("apiendpoint:$API_ENDPOINT");
    setState(() {
      // getTripsRespones = getTripsResponesFromJson(res.body);
      getTripsRespones = getTripThai;
      log(res.body);
      log(getTripsRespones.length.toString());
    });
  }

  Future<void> getTripEuro() async {
    log("url:$url");
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));

    var allTrips = getTripsResponesFromJson(res.body);

    var getTripEuro = allTrips
        .where((trip) => trip.destinationZone.toUpperCase() == "ยุโรป")
        .toList();

    log("apiendpoint:$API_ENDPOINT");
    setState(() {
      // getTripsRespones = getTripsResponesFromJson(res.body);
      getTripsRespones = getTripEuro;
      log(res.body);
      log(getTripsRespones.length.toString());
    });
  }
}

class TripCard extends StatelessWidget {
  final Map<String, String> trip;
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 90,
                      height: 120,
                      child: Image.network(
                        trip['image'] ??
                            '', // fallback เป็นค่าว่าง ถ้า key ไม่มี
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(trip['country']!),
                      Text(trip['duration']!),
                      Text(trip['price']!),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          "รายละเอียดเพิ่มเติม",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
