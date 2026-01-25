import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/appointment_detail_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/appointment_form_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/customer/customer_search_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/customer/customer_form_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/upcoming_appointments_page.dart';
import 'package:agenda_app/features/owner/catalogues/presentation/pages/catalogue_test_page.dart';
import 'package:agenda_app/features/auth/presentation/pages/login_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/diary_page.dart';
import 'package:agenda_app/features/owner/presentation/dashbord/owner_home_page.dart';
import 'package:agenda_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/app_dependencies.dart';

class AppRouter {
  static GoRouter router(AppDependencies deps) {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => BlocProvider(
            create: (_) => AuthBloc(
              loginUseCase: deps.loginOwnerUseCase,
              logoutUseCase: deps.logoutOwnerUseCase,
              getCurrentOwnerUseCase: deps.getCurrentOwnerUseCase,
            ),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/owner',
          builder: (_, __) => OwnerHomePage(
            repo: deps.appointmentsRepository,
          ),
        ),
        GoRoute(
          path: '/owner/appointments/upcoming',
          builder: (_, __) => UpcomingAppointmentsPage(
            repo: deps.appointmentsRepository,
          ),
        ),
        GoRoute(
          path: '/owner/appointments/:id',
          builder: (context, state) {
            final appointment = state.extra as AppointmentEntity;
            return AppointmentDetailPage(
              appointment: appointment,
              repository: deps.appointmentsRepository,
              onAppointmentUpdated: (updated) async {},
              onAppointmentDeleted: (id) async {},
            );
          },
        ),
        GoRoute(
          path: '/owner/appointments/cliente/buscar',
          builder: (_, __) => const CustomerSearchPage(),
        ),
        GoRoute(
          path: '/owner/appointments/cliente/new',
          builder: (context, state) {
            final cedula = state.extra as String?;
            return ClienteFormPage(cedulaPrellenada: cedula);
          },
        ),
        GoRoute(
          path: '/owner/citas',
          builder: (_, __) => const AppointmentFormPage(),
        ),
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
