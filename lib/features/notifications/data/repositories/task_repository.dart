import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/task.dart';

class TaskRepository {
  final SupabaseClient _supabaseClient;

  TaskRepository(this._supabaseClient);

  Future<void> createTask({
    required String roomId,
    required String priorityId,
    required String statusId,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      await _supabaseClient.from('tasks').insert({
        'room_id': roomId,
        'priority_id': priorityId,
        'status_id': statusId,
        'description': description,
        'due_date': dueDate.toUtc().toIso8601String(),
      });
    } catch (e) {
      print('Error creating task: $e');
      throw Exception('Failed to create task: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRooms() async {
    try {
      final response = await _supabaseClient
          .from('rooms')
          .select('id, room_number')
          .order('room_number');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load rooms: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPriorities() async {
    try {
      final response = await _supabaseClient
          .from('priorities')
          .select('id, name')
          .order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load priorities: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStatuses() async {
    try {
      final response = await _supabaseClient
          .from('taskstatuses')
          .select('id, name')
          .order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load statuses: $e');
    }
  }
}
