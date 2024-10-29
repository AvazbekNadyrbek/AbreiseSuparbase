import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/task_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(hours: 1));

  String? _selectedRoomId;
  String? _selectedPriorityId;
  String? _selectedStatusId;

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> _priorities = [];
  List<Map<String, dynamic>> _statuses = [];

  final _taskRepository = TaskRepository(
    Supabase.instance.client,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final rooms = await _taskRepository.getRooms();
      final priorities = await _taskRepository.getPriorities();
      final statuses = await _taskRepository.getStatuses();

      setState(() {
        _rooms = rooms;
        _priorities = priorities;
        _statuses = statuses;
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

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedRoomId != null &&
        _selectedPriorityId != null &&
        _selectedStatusId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _taskRepository.createTask(
          roomId: _selectedRoomId!,
          priorityId: _selectedPriorityId!,
          statusId: _selectedStatusId!,
          description: _descriptionController.text,
          dueDate: _selectedDueDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Задача успешно создана'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
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

  void _clearForm() {
    _descriptionController.clear();
    setState(() {
      _selectedRoomId = null;
      _selectedPriorityId = null;
      _selectedStatusId = null;
      _selectedDueDate = DateTime.now().add(const Duration(hours: 1));
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      'Создание новой задачи',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _selectedRoomId,
                      decoration: const InputDecoration(
                        labelText: 'Комната',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.meeting_room),
                      ),
                      items: _rooms.map((room) {
                        return DropdownMenuItem<String>(
                          value: room['id'],
                          child: Text(room['room_number']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Пожалуйста, выберите комнату';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPriorityId,
                      decoration: const InputDecoration(
                        labelText: 'Приоритет',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items: _priorities.map((priority) {
                        return DropdownMenuItem<String>(
                          value: priority['id'],
                          child: Text(priority['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriorityId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Пожалуйста, выберите приоритет';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatusId,
                      decoration: const InputDecoration(
                        labelText: 'Статус',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pending_actions),
                      ),
                      items: _statuses.map((status) {
                        return DropdownMenuItem<String>(
                          value: status['id'],
                          child: Text(status['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Пожалуйста, выберите статус';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectDateTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Срок выполнения',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_selectedDueDate.day.toString().padLeft(2, '0')}/'
                          '${_selectedDueDate.month.toString().padLeft(2, '0')}/'
                          '${_selectedDueDate.year} - '
                          '${_selectedDueDate.hour.toString().padLeft(2, '0')}:'
                          '${_selectedDueDate.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Описание',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите описание задачи';
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
                          : const Text('Создать задачу'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
