import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/features/admin/presentation/providers/admin_events_providers.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';

/// Bottom sheet para crear o editar un evento (admin)
class AdminEventFormBottomSheet extends ConsumerStatefulWidget {
  final Event? event; // Si es null, es creación; si no, es edición

  const AdminEventFormBottomSheet({super.key, this.event});

  @override
  ConsumerState<AdminEventFormBottomSheet> createState() => _AdminEventFormBottomSheetState();
}

class _AdminEventFormBottomSheetState extends ConsumerState<AdminEventFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _image1Controller = TextEditingController();
  final _image2Controller = TextEditingController();

  String? _selectedCategoryUuid;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      // Modo edición: prellenar campos
      _nameController.text = widget.event!.name;
      _descriptionController.text = widget.event!.description ?? '';
      _locationController.text = widget.event!.location ?? '';
      _startDateController.text = widget.event!.startDate;
      _endDateController.text = widget.event!.endDate ?? '';
      _selectedCategoryUuid = widget.event!.category?.uuid;
      
      if (widget.event!.images.isNotEmpty) {
        _image1Controller.text = widget.event!.images[0].imageUrl;
      }
      if (widget.event!.images.length > 1) {
        _image2Controller.text = widget.event!.images[1].imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().split('T')[0]; // YYYY-MM-DD
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryUuid == null) {
      AppSnackBar.info(context, AppLocalizations.of(context)!.pleaseselectacategory);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrls = <String>[];
      if (_image1Controller.text.isNotEmpty) {
        imageUrls.add(_image1Controller.text.trim());
      }
      if (_image2Controller.text.isNotEmpty) {
        imageUrls.add(_image2Controller.text.trim());
      }

      if (imageUrls.isEmpty) {
        throw Exception(AppLocalizations.of(context)!.atleastoneimagerequired);
      }

      final notifier = ref.read(adminEventsNotifierProvider.notifier);

      if (widget.event == null) {
        // Crear evento
        await notifier.createNewEvent(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          categoryUuid: _selectedCategoryUuid!,
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          startDate: _startDateController.text.trim(),
          endDate: _endDateController.text.trim().isEmpty ? null : _endDateController.text.trim(),
          imageUrls: imageUrls,
        );

        if (mounted) {
          AppSnackBar.success(context, AppLocalizations.of(context)!.eventcreatedsuccessfully);
        }
      } else {
        // Editar evento
        await notifier.updateExistingEvent(
          uuid: widget.event!.uuid,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          categoryUuid: _selectedCategoryUuid,
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          startDate: _startDateController.text.trim(),
          endDate: _endDateController.text.trim().isEmpty ? null : _endDateController.text.trim(),
          imageUrls: imageUrls,
        );

        if (mounted) {
          AppSnackBar.success(context, AppLocalizations.of(context)!.eventupdatedsuccessfully);
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesAsync = ref.watch(adminEventCategoriesProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.appBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle indicator
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.event == null
                            ? AppLocalizations.of(context)!.createevent
                            : AppLocalizations.of(context)!.editevent,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Formulario
              Expanded(
                child: categoriesAsync.when(
                  data: (categories) => _buildForm(context, scrollController, categories),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text('Error al cargar categorías: $error'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ScrollController scrollController, List<EventCategory> categories) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Form(
      key: _formKey,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          // Nombre del evento (obligatorio)
          AppTextField(
            controller: _nameController,
            labelText: '${AppLocalizations.of(context)!.eventname} *',
            maxLength: 150,
            validator: Validators.name(context, maxLength: 150),
          ),
          const SizedBox(height: 16),

          // Descripción (opcional)
          AppTextField(
            controller: _descriptionController,
            labelText: AppLocalizations.of(context)!.description,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Categoría (obligatorio)
          DropdownButtonFormField<String>(
            initialValue: _selectedCategoryUuid,
            decoration: InputDecoration(
              labelText: '${AppLocalizations.of(context)!.category} *',
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category.uuid,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryUuid = value;
              });
            },
            validator: Validators.required(context, fieldName: AppLocalizations.of(context)!.category),
          ),
          const SizedBox(height: 16),

          // Ubicación (opcional)
          AppTextField(
            controller: _locationController,
            labelText: AppLocalizations.of(context)!.location,
            maxLength: 255,
          ),
          const SizedBox(height: 16),

          // Fecha de inicio (obligatorio)
          TextFormField(
            controller: _startDateController,
            decoration: InputDecoration(
              labelText: '${AppLocalizations.of(context)!.startdate} *',
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, _startDateController),
              ),
            ),
            readOnly: true,
            validator: Validators.required(context, fieldName: AppLocalizations.of(context)!.startdate),
          ),
          const SizedBox(height: 16),

          // Fecha de fin (opcional)
          TextFormField(
            controller: _endDateController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.enddate,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, _endDateController),
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16),

          // Imagen 1 (obligatorio)
          AppTextField(
            controller: _image1Controller,
            labelText: '${AppLocalizations.of(context)!.imageurl} 1 *',
            hintText: 'https://example.com/image1.jpg',
            validator: Validators.url(context),
          ),
          const SizedBox(height: 16),

          // Imagen 2 (opcional)
          AppTextField(
            controller: _image2Controller,
            labelText: '${AppLocalizations.of(context)!.imageurl} 2',
            hintText: 'https://example.com/image2.jpg',
            validator: Validators.urlOptional(context),
          ),
          const SizedBox(height: 24),

          // Botón de submit
          AppFilledButton(
            onPressed: _isLoading ? null : _submit,
            loading: _isLoading,
            label: widget.event == null
                ? AppLocalizations.of(context)!.create
                : AppLocalizations.of(context)!.save,
            icon: widget.event == null ? Icons.add : Icons.save,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
