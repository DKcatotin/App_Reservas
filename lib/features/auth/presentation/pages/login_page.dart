import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/usecases/login_owner_usecase.dart';

class LoginPage extends StatefulWidget {
  final LoginOwnerUseCase loginUseCase;

  const LoginPage({
    super.key,
    required this.loginUseCase,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userCtrl =
      TextEditingController(text: 'admin@admin.com');
  final TextEditingController _passCtrl =
      TextEditingController(text: 'admin');

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    print('🔵 Iniciando login...'); // DEBUG
    
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      print('🔵 Llamando loginUseCase...'); // DEBUG
      
      final result = await widget.loginUseCase(
        email: _userCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      print('🔵 Resultado recibido: $result'); // DEBUG

      result.fold(
        (failure) {
          print('🔴 Error: ${failure.message}'); // DEBUG
          setState(() {
            _error = failure.message;
          });
        },
        (owner) {
          print('🟢 Login exitoso! Usuario: ${owner.fullName}'); // DEBUG
          print('🟢 Navegando a /owner...'); // DEBUG
          
          if (!mounted) {
            print('⚠️ Widget no montado'); // DEBUG
            return;
          }
          
          context.go('/owner');
          print('🟢 Navegación ejecutada'); // DEBUG
        },
      );
    } catch (e, stackTrace) {
      print('🔴 Excepción capturada: $e'); // DEBUG
      print('🔴 StackTrace: $stackTrace'); // DEBUG
      
      setState(() {
        _error = 'Error inesperado: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFFF8F5FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// LOGO / TITLE
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront,
                              size: 40,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Francis Nails',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Owner App',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 24),

                          /// USER
                          TextField(
                            controller: _userCtrl,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            enabled: !_loading,
                          ),
                          const SizedBox(height: 16),

                          /// PASSWORD
                          TextField(
                            controller: _passCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            enabled: !_loading,
                            onSubmitted: (_) => _login(),
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          /// BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B5CF6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
