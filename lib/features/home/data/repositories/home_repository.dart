import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepository {
  final SupabaseClient _supabaseClient;

  HomeRepository(this._supabaseClient);

  Future<List<Map<String, dynamic>>> getTasks() async {
    try {
      final response = await _supabaseClient.from('tasks').select('''
            id,
            description,
            due_date,
            rooms!inner(room_number),
            priorities!inner(name),
            taskstatuses!inner(name)
          ''').order('due_date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatusId) async {
    try {
      await _supabaseClient
          .from('tasks')
          .update({'status_id': newStatusId}).eq('id', taskId);
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }
}
