import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart'; // ✅ CAMBIAR IMPORT
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_form_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/customer_search_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/customer_form_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/upcoming_appointments_page.dart';
import 'package:agenda_app/features/owner/catalogues/presentation/pages/catalogue_test_page.dart';
import '../../features/auth/data/presentation/pages/login_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/diary_page.dart';
import 'package:agenda_app/features/owner/presentation/dashbord/owner_home_page.dart';
import 'package:go_router/go_router.dart';
import '../di/auth_di.dart';

class AppRouter {
  static GoRouter router(AppDependencies deps) {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => LoginPage(
            authRepository: deps.authRepository,
          ),
        ),
        GoRoute(
          path: '/owner',
          builder: (_, __) => OwnerHomePage(
            repo: deps.appointmentsRepository,
          ),
        ),
        // Citas futuras/próximas
        GoRoute(
          path: '/owner/appointments/upcoming',
          builder: (_, __) => UpcomingAppointmentsPage(
            repo: deps.appointmentsRepository,
          ),
        ),
        //  Detalles de cita
        GoRoute(
          path: '/owner/appointments/:id',
          builder: (context, state) {
            // CORRECCIÓN: Cast a AppointmentEntity
            final appointment = state.extra as AppointmentEntity;
            return AppointmentDetailPage(
              appointment: appointment,
              repository: deps.appointmentsRepository, //  USAR deps, NO widget
              // Agregar callbacks 
              onAppointmentUpdated: (updated) async {
              },
              onAppointmentDeleted: (id) async {
              },
            );
          },
        ),
        //  Nueva ruta: Buscar cliente
        GoRoute(
          path: '/owner/appointments/cliente/buscar',
          builder: (_, __) => const CustomerSearchPage(),
        ),

        //  Nueva ruta: Crear cliente
        GoRoute(
          path: '/owner/appointments/cliente/new',
          builder: (context, state) {
            final cedula = state.extra as String?;
            return ClienteFormPage(cedulaPrellenada: cedula);
          },
        ),

        //  Ruta existente: Crear cita
        GoRoute(
          path: '/owner/citas',
          builder: (_, __) => AppointmentFormPage(
            repo: deps.appointmentsRepository,
          ),
        ),

        //  Agenda (JSON hoy)
        GoRoute(
          path: '/owner/agenda',
          builder: (_, __) => DiaryPage(
            repo: deps.appointmentsRepository,
          ),
        ),
        GoRoute(
          path: '/owner/test1',
          builder: (_, __) => TestPage(
            repo: deps.cataloguesRepository,
          ),
        ),
      ],
    );
  }
}
