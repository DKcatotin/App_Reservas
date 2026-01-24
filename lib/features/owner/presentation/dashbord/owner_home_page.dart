import 'package:agenda_app/core/di/app_dependencies.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/get_appointments_by_day.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/get_upcoming_appointments.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../appointments/data/repositories/appointments_repository_impl.dart';

class OwnerHomePage extends StatefulWidget {
  final AppointmentsRepositoryImpl repo;

  const OwnerHomePage({
    super.key,
    required this.repo,
  });

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  //  Declarar use cases
  late final GetAppointmentsByDayUseCase _getTodayUseCase;
  late final GetUpcomingAppointmentsUseCase _getUpcomingUseCase;

  //  CAMBIAR: Appointment → AppointmentEntity
  List<AppointmentEntity> _servicios = [];
  List<AppointmentEntity> _upcoming = [];
  
  bool _isLoading = true;
   bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    //  Inicializar use cases
    _getTodayUseCase = GetAppointmentsByDayUseCase(widget.repo);
    _getUpcomingUseCase = GetUpcomingAppointmentsUseCase(widget.repo);
    
    _loadData();
  }

 Future<void> _loadData() async {
  setState(() => _isLoading = true);
  
  await Future.wait([
    _loadServicios(),
    _loadUpcoming(),
  ]);
  
  if (mounted) {
    setState(() {
      _isLoading = false;
      _isInitialized = true; //  Marcar como inicializado
    });
  }
}
  Future<void> _loadUpcoming() async {
  try {
    //  Usar use case
    final data = await _getUpcomingUseCase.call();
    
    if (mounted) {
      setState(() {
        // Filtrar para excluir las citas de HOY (ya se hace en el use case)
        // El use case ya devuelve solo citas futuras (desde mañana)
        _upcoming = data;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _upcoming = [];
      });
    }
  }
}

Future<void> _loadServicios() async {
  try {
    //  Usar use case para obtener citas de hoy
    final data = await _getTodayUseCase.today();
    
    if (mounted) {
      setState(() {
        // Eliminar duplicados basándose en el ID de la cita
        final Map<String, AppointmentEntity> uniqueMap = {};
        for (var appointment in data) {
          uniqueMap[appointment.id] = appointment;
        }
        _servicios = uniqueMap.values.toList();
        _error = null;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _error = 'Error al cargar las citas: $e';
      });
    }
  }
}


  

 Future<void> _logout(BuildContext context) async {
  // Usar el UseCase de logout
  await AppDependencies().logoutOwnerUseCase();
  
  if (context.mounted) {
    context.go('/login');
  }
}

  Color _getStatusColor(String statusLabel) {
    switch (statusLabel.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFFFBBF24);
      case 'confirmada':
        return const Color(0xFF10B981);
      case 'terminada':
        return const Color(0xFF10B981);
      case 'cancelada':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    // PANTALLA DE CARGA
    if (!_isInitialized || _isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha:0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cargando...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // PANTALLA DE ERROR
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: _buildErrorView(),
      );
    }
    
    // CONTENIDO PRINCIPAL
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
  /// HEADER
  SliverToBoxAdapter(
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha:0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.spa, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Francis Nails & Beauty Spa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha:0.9),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu agenda de hoy',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),

  /// ESTADÍSTICAS
  SliverToBoxAdapter(
    child: Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: _buildModernStatCard(
                icon: Icons.event_available,
                value: '${_servicios.length}',
                label: 'Citas hoy',
                color: const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernStatCard(
                icon: Icons.people,
                value: '${_servicios.map((e) => e.customer.id).toSet().length}',
                label: 'Clientas',
                color: const Color(0xFF9333EA),
              ),
            ),
          ],
        ),
      ),
    ),
  ),

  /// =======================
  /// CITAS DE HOY - HEADER
  /// =======================
  SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: const Text(
        'Citas de hoy',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        ),
      ),
    ),
  ),

  /// CITAS DE HOY - LISTA
  if (_servicios.isEmpty)
    SliverToBoxAdapter(child: _buildEmptyState())
  else
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPremiumCitaCard(_servicios[index]),
          ),
          childCount: _servicios.length,
        ),
      ),
    ),

  /// ==========================
  /// PRÓXIMAS CITAS - HEADER
  /// ==========================
  SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Próximas citas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          if (_upcoming.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                await context.push('/owner/appointments/upcoming');
                await _loadData();
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Ver todas'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF7C3AED),
              ),
            ),
        ],
      ),
    ),
  ),

  /// PRÓXIMAS CITAS - LISTA (máx 3)
  if (_upcoming.isEmpty)
    const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          'No hay citas futuras programadas',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    )
  else
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPremiumCitaCard(_upcoming[index]),
          ),
          childCount: _upcoming.length > 3 ? 3 : _upcoming.length,
        ),
      ),
    ),

  /// BOTONES
  SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          _buildPrimaryButton(
            label: 'Agendar nueva cita',
            icon: Icons.add_circle_outline,
            onPressed: () async {
              await context.push('/owner/appointments/cliente/buscar');
              await _loadData();
            },
          ),
          const SizedBox(height: 12),
          _buildSecondaryButton(
            label: 'Probar ruta privada',
            icon: Icons.bug_report_outlined,
            onPressed: () => context.go('/owner/test1'),
          ),
        ],
      ),
    ),
  ),

  const SliverToBoxAdapter(child: SizedBox(height: 100)),
],

        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.03),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _buildNavItem(Icons.home_rounded, 'Inicio', true, () {}),
    _buildNavItem(Icons.calendar_today_rounded, 'Agenda', false, () async {
      await context.push('/owner/agenda'); 
      await _loadData();
    }),
  ],
)
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPremiumCitaCard(AppointmentEntity cita) { 
  final time = TimeOfDay.fromDateTime(cita.startAt).format(context);
  final serviceName = cita.services.isNotEmpty ? cita.services.first.name : 'Sin servicio';
  final statusColor = _getStatusColor(cita.status.name);

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey[100]!, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          //Navegar al detalle con la cita
          await context.push(
            '/owner/appointments/${cita.id}',
            extra: cita, // Ya es AppointmentEntity
          );
          await _loadData();
        },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF7C3AED),
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cita.customer.fullName?? 'Sin nombre',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.spa, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              serviceName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha:0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cita.status.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF7C3AED),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha:0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha:0.2), width: 2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7C3AED), size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C3AED),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha:0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy,
                size: 48,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No hay citas para hoy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Es un buen momento para\nagregar una nueva cita',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey[600],
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}