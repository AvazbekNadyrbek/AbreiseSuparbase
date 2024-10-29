import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/room_repository.dart';
import '../../domain/models/room_type.dart';
import '../../../notifications/domain/models/department.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  Department? _selectedDepartment;
  RoomType? _selectedRoomType;
  List<Department> _departments = [];
  List<RoomType> _roomTypes = [];

  final _roomRepository = RoomRepository(
    Supabase.instance.client,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final departments = await _roomRepository.getDepartments();
      final roomTypes = await _roomRepository.getRoomTypes();

      setState(() {
        _departments = departments;
        _roomTypes = roomTypes;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedDepartment != null &&
        _selectedRoomType != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _roomRepository.createRoom(
          roomNumber: _nameController.text,
          departmentId: _selectedDepartment!.id,
          typeId: _selectedRoomType!.id,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Комната успешно создана'),
              backgroundColor: Colors.green,
            ),
          );
          _nameController.clear();
          setState(() {
            _selectedDepartment = null;
            _selectedRoomType = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Добавление новой комнаты',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Номер комнаты',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.meeting_room),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите номер комнаты';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Department>(
                        value: _selectedDepartment,
                        decoration: const InputDecoration(
                          labelText: 'Департамент',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: _departments.map((Department department) {
                          return DropdownMenuItem<Department>(
                            value: department,
                            child: Text(department.name),
                          );
                        }).toList(),
                        onChanged: (Department? newValue) {
                          setState(() {
                            _selectedDepartment = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Пожалуйста, выберите департамент';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RoomType>(
                        value: _selectedRoomType,
                        decoration: const InputDecoration(
                          labelText: 'Тип комнаты',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _roomTypes.map((RoomType type) {
                          return DropdownMenuItem<RoomType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                        onChanged: (RoomType? newValue) {
                          setState(() {
                            _selectedRoomType = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Пожалуйста, выберите тип комнаты';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Создать комнату'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
