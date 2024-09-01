import 'package:flutter/material.dart';
import 'package:tracking_app/pages/graphs/graph_page.dart';
import 'package:tracking_app/services/auth.dart';
import 'package:tracking_app/utils/loading.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade50,
          title: const Text("PD Tracker"),
          elevation: 0,
        ),
        backgroundColor: Colors.blueGrey.shade50,
        drawer: Drawer(
          child: loading
              ? const Loading()
              : ListView(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text("Sign Out"),
                      onTap: () async {
                        setState(() {
                          loading = false;
                        });
                        await AuthService().signOut(context);
                        setState(() {
                          loading = true;
                        });
                      },
                    )
                  ],
                ),
        ),
        body: const GraphPage());
  }
}
