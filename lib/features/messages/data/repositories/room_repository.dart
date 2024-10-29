import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/room_type.dart';
import '../../../notifications/domain/models/department.dart';

class RoomRepository {
  final SupabaseClient _supabaseClient;

  RoomRepository(this._supabaseClient);

  Future<void> createRoom({
    required String roomNumber,
    required String departmentId,
    required String typeId,
  }) async {
    try {
      await _supabaseClient.from('rooms').insert({
        'room_number': roomNumber,
        'departament_id': departmentId,
        'type_id': typeId,
      });
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  Future<List<Department>> getDepartments() async {
    try {
      final response =
          await _supabaseClient.from('departments').select().order('name');

      return (response as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load departments: $e');
    }
  }

  Future<List<RoomType>> getRoomTypes() async {
    try {
      final response =
          await _supabaseClient.from('roomtypes').select().order('name');

      return (response as List).map((json) => RoomType.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load room types: $e');
    }
  }
}
