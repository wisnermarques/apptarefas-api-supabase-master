import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://nddazqssbociyzyqdwec.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kZGF6cXNzYm9jaXl6eXFkd2VjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5MzgwMjgsImV4cCI6MjA2MzUxNDAyOH0.rsKMYec1naDM9IMO6-FBA7ohT_1AYv14jPaJzXYuy-8',
    );
  }
}
