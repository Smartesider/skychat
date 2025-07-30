import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/glassmorphism_container.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/organization_providers.dart';
import '../domain/models/organization_models.dart';
import '../../auth/auth_providers.dart';

class TaskManagementWidget extends ConsumerStatefulWidget {
  final String familyId;

  const TaskManagementWidget({
    super.key,
    required this.familyId,
  });

  @override
  ConsumerState<TaskManagementWidget> createState() => _TaskManagementWidgetState();
}

class _TaskManagementWidgetState extends ConsumerState<TaskManagementWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Alle'),
            Tab(text: 'Mine'),
            Tab(text: 'Fullført'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllTasksTab(),
              _buildMyTasksTab(),
              _buildCompletedTasksTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllTasksTab() {
    final tasks = ref.watch(tasksProvider(widget.familyId));

    return tasks.when(
      data: (taskList) {
        if (taskList.isEmpty) {
          return _buildEmptyState(
            'Ingen oppgaver ennå',
            'Opprett den første oppgaven for familien',
            Icons.task_alt,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: taskList.length,
          itemBuilder: (context, index) => _buildTaskCard(taskList[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState('Kunne ikke laste oppgaver'),
    );
  }

  Widget _buildMyTasksTab() {
    final myTasks = ref.watch(myTasksProvider(widget.familyId));

    return myTasks.when(
      data: (taskList) {
        if (taskList.isEmpty) {
          return _buildEmptyState(
            'Ingen oppgaver tildelt deg',
            'Du har ingen aktive oppgaver akkurat nå',
            Icons.check_circle_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: taskList.length,
          itemBuilder: (context, index) => _buildTaskCard(taskList[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState('Kunne ikke laste dine oppgaver'),
    );
  }

  Widget _buildCompletedTasksTab() {
    final completedTasks = ref.watch(completedTasksProvider(widget.familyId));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(completedTasks[index]),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final isCompleted = task.status == TaskStatus.completed;
    final user = ref.watch(currentUserProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTaskPriorityColor(task.priority),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                decoration: isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          _buildTaskStatusChip(task.status),
                        ],
                      ),
                      if (task.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (task.dueDate != null || task.assignedToName != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (task.dueDate != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: _getDueDateColor(task.dueDate!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getDueDateColor(task.dueDate!),
                      ),
                    ),
                  ],
                  if (task.assignedToName != null) ...[
                    if (task.dueDate != null) const SizedBox(width: 16),
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.assignedToName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: task.tags.map((tag) => _buildTagChip(tag)).toList(),
              ),
            ],
            if (task.checklist.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Sjekkliste (${task.completedChecklist.length}/${task.checklist.length})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: task.checklist.isEmpty 
                    ? 0 
                    : task.completedChecklist.length / task.checklist.length,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (task.points > 0) ...[
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.points} poeng',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (!isCompleted)
                      IconButton(
                        onPressed: () => _markTaskComplete(task),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        iconSize: 20,
                      ),
                    IconButton(
                      onPressed: () => _editTask(task),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: () => _deleteTask(task),
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColors.error.withOpacity(0.6),
                      ),
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChip(TaskStatus status) {
    Color color;
    String text;

    switch (status) {
      case TaskStatus.pending:
        color = AppColors.warning;
        text = 'Venter';
        break;
      case TaskStatus.inProgress:
        color = AppColors.info;
        text = 'Pågår';
        break;
      case TaskStatus.completed:
        color = AppColors.success;
        text = 'Fullført';
        break;
      case TaskStatus.cancelled:
        color = AppColors.error;
        text = 'Avbrutt';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 10,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateTaskDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Opprett oppgave'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Refresh the provider
              ref.invalidate(tasksProvider(widget.familyId));
            },
            child: const Text('Prøv igjen'),
          ),
        ],
      ),
    );
  }

  Color _getTaskPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.urgent:
        return AppColors.accent;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;

    if (daysUntilDue < 0) {
      return AppColors.error; // Overdue
    } else if (daysUntilDue <= 1) {
      return AppColors.warning; // Due soon
    } else {
      return Colors.white.withOpacity(0.6); // Normal
    }
  }

  void _markTaskComplete(TaskModel task) async {
    final user = ref.read(currentUserProvider).asData?.value;
    if (user == null) return;

    try {
      final actions = ref.read(organizationActionsProvider);
      await actions.completeTask(widget.familyId, task.id, user.uid);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oppgave "${task.title}" markert som fullført'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kunne ikke fullføre oppgave: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _editTask(TaskModel task) {
    // Show edit task dialog
    _showCreateTaskDialog(task: task);
  }

  void _deleteTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Slett oppgave',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Er du sikker på at du vil slette "${task.title}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final actions = ref.read(organizationActionsProvider);
                await actions.deleteTask(widget.familyId, task.id);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Oppgave "${task.title}" slettet'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Kunne ikke slette oppgave: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Slett',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog({TaskModel? task}) {
    // Implementation for create/edit task dialog will be added here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opprett/rediger oppgave dialog kommer snart'),
      ),
    );
  }
}
