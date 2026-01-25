import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://bgjuhsqwbsvwgeixrvvh.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJnanVoc3F3YnN2d2dlaXhydnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMzI4OTMsImV4cCI6MjA4MzkwODg5M30.yZ7ohXkH4TtIaaUIQqmC6H5J6CEpRevfHQZvL1Tcy_s';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
