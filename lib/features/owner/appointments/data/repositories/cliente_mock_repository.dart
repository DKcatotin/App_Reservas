import 'package:agenda_app/features/owner/appointments/data/models/customer_model.dart';

class ClienteMockRepository {
  // Lista en memoria que simula una base de datos
  final List<ClienteModel> _clientes = [
    ClienteModel(cedula: '1713456789', nombre: 'Juan Pérez', celular: '0998765432'),
    ClienteModel(cedula: '1719876543', nombre: 'María López', celular: '0987654321'),
    ClienteModel(cedula: '1712345678', nombre: 'Carlos Ruiz', celular: '0996543210'),
  ];

  // Buscar cliente por cédula
  ClienteModel? buscarPorCedula(String cedula) {
    try {
      return _clientes.firstWhere((cliente) => cliente.cedula == cedula);
    } catch (e) {
      return null; // No existe
    }
  }

  // Crear nuevo cliente
  ClienteModel crearCliente({
    required String cedula,
    required String nombre,
    required String celular,
  }) {
    final nuevoCliente = ClienteModel(
      cedula: cedula,
      nombre: nombre,
      celular: celular,
    );
    _clientes.add(nuevoCliente);
    return nuevoCliente;
  }

  // Obtener todos los clientes (opcional)
  List<ClienteModel> obtenerTodos() => _clientes;
}