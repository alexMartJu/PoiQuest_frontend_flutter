import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/data/datasources/ticket_validator_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/data/repositories/ticket_validator_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/validation_history_item.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/repositories/ticket_validator_repository.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/usecases/validate_ticket_usecase.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/usecases/get_validation_history_usecase.dart';

/// Providers y Notifiers de la feature `ticket_validator`.
///
/// Responsabilidad: exponer las abstracciones necesarias para la capa
/// de presentación (UI) y orquestar la comunicación con la capa de dominio
/// y datos.
///
/// Flujo resumido: `TicketValidatorPage` (UI) -> providers (Riverpod)
/// -> usecases (`ValidateTicket`, `GetValidationHistory`) -> repository
/// -> data source (`TicketValidatorRemoteDataSource`) -> HTTP.

// Provider que expone la instancia del data source HTTP (Dio).
// Se utiliza `const` cuando es posible para optimizar y favorecer la
// inmutabilidad; permite inyectar otra implementación en tests si es necesario.
final ticketValidatorRemoteDataSourceProvider =
    Provider<TicketValidatorRemoteDataSource>((ref) {
  return const TicketValidatorRemoteDataSource();
});

// Provider del repositorio
final ticketValidatorRepositoryProvider =
    Provider<TicketValidatorRepository>((ref) {
  final dataSource = ref.watch(ticketValidatorRemoteDataSourceProvider);
  return TicketValidatorRepositoryImpl(remoteDataSource: dataSource);
});

// Usecase providers
final validateTicketUseCaseProvider = Provider<ValidateTicket>((ref) {
  return ValidateTicket(ref.watch(ticketValidatorRepositoryProvider));
});

final getValidationHistoryUseCaseProvider =
    Provider<GetValidationHistory>((ref) {
  return GetValidationHistory(ref.watch(ticketValidatorRepositoryProvider));
});

// Provider para la fecha seleccionada en el historial (por defecto hoy)
final historySelectedDateProvider =
    NotifierProvider<HistorySelectedDateNotifier, DateTime>(
  HistorySelectedDateNotifier.new,
);

/// Notifier sencillo que guarda la fecha seleccionada por el usuario.
/// Usado por la UI para filtrar el historial de validaciones.
class HistorySelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void select(DateTime date) => state = date;
}

// Provider del historial de validaciones filtrado por fecha seleccionada
final validationHistoryProvider =
    FutureProvider<List<ValidationHistoryItem>>((ref) async {
  final usecase = ref.watch(getValidationHistoryUseCaseProvider);
  final selectedDate = ref.watch(historySelectedDateProvider);
  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
  return usecase(dateStr);
});
