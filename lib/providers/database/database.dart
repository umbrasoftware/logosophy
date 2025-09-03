import 'package:supabase_flutter/supabase_flutter.dart';

late Supabase supabase;

Future<void> initSupabase(String supabaseUrl, String anonKey) async {
  supabase = await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
}
