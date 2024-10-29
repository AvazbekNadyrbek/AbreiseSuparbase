import 'package:supabase_flutter/supabase_flutter.dart';

class DepartmentRepository {
  final SupabaseClient _supabaseClient;

  DepartmentRepository(this._supabaseClient);

  Future<void> createDepartment(String name) async {
    try {
      await _supabaseClient.from('departments').insert({'name': name});
    } catch (e) {
      throw Exception('Failed to create department: $e');
    }
  }
}
