import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/request/customer_register_post_req.dart';
import 'package:my_first_app/pages/login.dart';
import 'package:my_first_app/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emaiCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController confirmpasswordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 16),
                  child: Text(
                    "ชื่อ-นามสกุล",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 2,
                  ),
                  child: TextField(
                    controller: fullnameCtl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 16),
                  child: Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 2,
                  ),
                  child: TextField(
                    controller: phoneCtl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  child: Text(
                    "อีเมล",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 2,
                  ),
                  child: TextField(
                    controller: emaiCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  child: Text(
                    "รหัสผ่าน",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 2,
                  ),
                  child: TextField(
                    controller: passwordCtl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  child: Text(
                    "ยืนยันรหัสผ่าน",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 2,
                  ),
                  child: TextField(
                    controller: confirmpasswordCtl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FilledButton(
                        onPressed: register,
                        child: const Text('สมัครสมาชิก'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'หากมีบัญชีอยู่แล้ว?',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: login,
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ],
                    ),
                  ],
                ),
                // Center(child: Text(text, style: TextStyle(fontSize: 20))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void register() {
    String password = passwordCtl.text;
    String confirmpassword = confirmpasswordCtl.text;

    if (password == confirmpassword) {
      CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
        phone: phoneCtl.text,
        fullname: fullnameCtl.text,
        email: emaiCtl.text,
        image: '',
        password: passwordCtl.text,
      );
      http.post(
        Uri.parse("$API_ENDPOINT/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerRegisterPostRequestToJson(req),
      );
    }else {
      log('can not register because password is not correct');
    }
  }

  // void showtrip() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ShowTripPage()),
  //   );
  // }
}
