import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/customer_idx_get_res.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = '';
  late Future<void> loadData;
  late GetCustomerRespones customerIdxGetResponse;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // log(value);
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'ยืนยันการยกเลิกสมาชิก?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ปิด'),
                        ),
                        FilledButton(
                          onPressed: delete,
                          child: const Text('ยืนยัน'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Load Done
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      customerIdxGetResponse.image,
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อ-นามสกุล', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        initialValue: customerIdxGetResponse.fullname,
                        // controller: TextEditingController(
                        //   text: customerIdxGetResponse.fullname,
                        // ),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          customerIdxGetResponse.fullname = value;
                        },
                      ),
                      // Text(
                      //   customerIdxGetResponse.fullname,
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        // controller: TextEditingController(
                        //   text: customerIdxGetResponse.phone,
                        // ),
                        initialValue: customerIdxGetResponse.phone,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          customerIdxGetResponse.phone = value;
                        },
                      ),
                      // Text(
                      //   customerIdxGetResponse.phone,
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      Text('Email', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        // controller: TextEditingController(
                        //   text: customerIdxGetResponse.email,
                        // ),
                        initialValue: customerIdxGetResponse.email,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          customerIdxGetResponse.email = value;
                        },
                      ),
                      Text('รูปโปรไฟล์', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        initialValue: customerIdxGetResponse.image,
                        // controller: TextEditingController(
                        //   text: customerIdxGetResponse.image,
                        // ),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          customerIdxGetResponse.image = value;
                        },
                      ),

                      FilledButton(
                        onPressed: update,
                        child: Text("แก้ไขข้อมูล"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> update() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var json = {
      "fullname": customerIdxGetResponse.fullname,
      "phone": customerIdxGetResponse.phone,
      "email": customerIdxGetResponse.email,
      "image": customerIdxGetResponse.image,
    };
    var res = await http.put(
      Uri.parse('$url/customers/${widget.idx}'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode(json),
    );
    log(res.body);
  }

  Future<void> loadDataAsync() async {
    // log("trst");
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customerIdxGetResponse = getCustomerResponesFromJson(res.body);
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
    log(res.statusCode.toString());
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
