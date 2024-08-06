import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<Map?> getEmployee() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString("userId");
    print(id);
    Response response =
        await Dio().get("http://16.171.199.210:3000/employees/Details/68");
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('بيانات الموظف', context, true),
      body: FutureBuilder(
        future: getEmployee(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!["employee"].entries.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        snapshot.data!["employee"].entries.toList()[index].key),
                    Text(snapshot.data!["employee"].entries
                        .toList()[index]
                        .value
                        .toString()),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
