import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/register.dart';
import 'package:my_first_app/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNo = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/03e3a91c28a8fe908615e9cfb96884a8.jpg',
                ),

                // หมายเลขโทรศัพท์
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 30),
                  child: Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextField(
                    controller: phoneNoCtl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),

                // รหัสผ่าน
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "รหัสผ่าน",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: TextField(
                    controller: passwordCtl,
                    keyboardType: TextInputType.phone,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),

                // ปุ่ม ลงทะเบียนใหม่ / เข้าสู่ระบบ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: register,
                        child: const Text('ลงทะเบียนใหม่'),
                      ),
                    ),
                    FilledButton(
                      onPressed: login,
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),

                // แสดงข้อความ text
                Text(text, style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    // var data = {"phone": phoneNoCtl, "password": password};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    log("url : $url");
    log("api endpoint : $API_ENDPOINT");
    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          // log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          log(customerLoginPostResponse.customer.idx.toString());
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}
