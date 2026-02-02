import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brantaspinjam/services/user_service.dart';
import 'package:brantaspinjam/widgets/card_dashboard.dart';

class LogAktivitasScreen extends StatefulWidget {
  const LogAktivitasScreen({super.key});

  @override
  State<LogAktivitasScreen> createState() => _LogAktivitasScreenState();
}

class _LogAktivitasScreenState extends State<LogAktivitasScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      final data = await UserService().getLogs();
      setState(() => logs = data);
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadLogs,
              child: logs.isEmpty
                  ? const Center(child: Text("Belum ada aktivitas"))
                  : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = logs[index];

                        DateTime dateTime = DateTime.parse(item['waktu']);
                        String formattedDate = DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(dateTime);

                        return ActivityCard(
                          title: item['users']['name'] ?? 'User Unknown',
                          subtitle: item['aktivitas'],
                          date: formattedDate,
                        );
                      },
                    ),
            ),
    );
  }
}
