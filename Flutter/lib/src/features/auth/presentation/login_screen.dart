import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_controller.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/password_strength_indicator.dart';
import 'utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login form controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Signup form controllers
  final _signupUsernameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  // Focus nodes
  final _loginEmailFocus = FocusNode();
  final _loginPasswordFocus = FocusNode();
  final _signupUsernameFocus = FocusNode();
  final _signupEmailFocus = FocusNode();
  final _signupPasswordFocus = FocusNode();
  final _signupConfirmPasswordFocus = FocusNode();

  // State
  bool _isLoading = false;
  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _obscureConfirmPassword = true;

  // Validation errors
  String? _loginEmailError;
  String? _loginPasswordError;
  String? _signupUsernameError;
  String? _signupEmailError;
  String? _signupPasswordError;
  String? _signupConfirmPasswordError;

  // Password strength
  String _passwordStrength = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to password changes for strength indicator
    _signupPasswordController.addListener(() {
      setState(() {
        _passwordStrength = _signupPasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupUsernameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _loginEmailFocus.dispose();
    _loginPasswordFocus.dispose();
    _signupUsernameFocus.dispose();
    _signupEmailFocus.dispose();
    _signupPasswordFocus.dispose();
    _signupConfirmPasswordFocus.dispose();
    super.dispose();
  }

  bool _validateLoginForm() {
    setState(() {
      _loginEmailError = Validators.email(_loginEmailController.text);
      _loginPasswordError = Validators.password(_loginPasswordController.text);
    });

    return _loginEmailError == null && _loginPasswordError == null;
  }

  bool _validateSignupForm() {
    setState(() {
      _signupUsernameError = Validators.username(
        _signupUsernameController.text,
      );
      _signupEmailError = Validators.email(_signupEmailController.text);
      _signupPasswordError = Validators.password(
        _signupPasswordController.text,
      );
      _signupConfirmPasswordError = Validators.confirmPassword(
        _signupConfirmPasswordController.text,
        _signupPasswordController.text,
      );
    });

    return _signupUsernameError == null &&
        _signupEmailError == null &&
        _signupPasswordError == null &&
        _signupConfirmPasswordError == null;
  }

  Future<void> _login() async {
    if (!_validateLoginForm()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            _loginEmailController.text.trim(),
            _loginPasswordController.text,
          );

      if (mounted) {
        final authState = ref.read(authControllerProvider);
        if (authState.isAuthenticated) {
          // Succès - GoRouter redirigera automatiquement vers la page d'accueil
          _showSuccessSnackBar('Connexion réussie !');
        } else if (authState.errorMessage != null) {
          _showErrorSnackBar(
            'Connexion échouée: ${_formatError(authState.errorMessage!)}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Connexion échouée: ${_formatError(e.toString())}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUp() async {
    if (!_validateSignupForm()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            _signupUsernameController.text.trim(),
            _signupEmailController.text.trim(),
            _signupPasswordController.text,
          );

      if (mounted) {
        final authState = ref.read(authControllerProvider);
        if (authState.isAuthenticated) {
          // Succès - L'utilisateur est automatiquement connecté après inscription
          // GoRouter redirigera vers la page d'accueil
          _showSuccessSnackBar(
            'Compte créé ! Bienvenue ${authState.user?.username ?? ''} !',
          );
        } else if (authState.errorMessage != null) {
          _showErrorSnackBar(
            'Inscription échouée: ${_formatError(authState.errorMessage!)}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(
          'Inscription échouée: ${_formatError(e.toString())}',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Email ou mot de passe incorrect';
    }
    if (error.contains('Email already registered')) {
      return 'Cet email est déjà utilisé';
    }
    if (error.contains('User already registered')) {
      return 'Ce compte existe déjà';
    }
    return error;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
              theme.colorScheme.tertiary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  _buildHeader(),
                  const SizedBox(height: 40),

                  // Auth Card
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: size.width > 600 ? 500 : double.infinity,
                    ),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tabs
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelColor: theme.colorScheme.onPrimary,
                                unselectedLabelColor:
                                    theme.colorScheme.onSurfaceVariant,
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Tab(text: 'Connexion'),
                                  Tab(text: 'Inscription'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tab Content
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildLoginForm(),
                                  _buildSignupForm(),
                                ],
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.catching_pokemon,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'PokeClicker Live',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Attrapez-les tous!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _loginEmailController,
            label: 'Email',
            hintText: 'votre@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText: _loginEmailError,
            focusNode: _loginEmailFocus,
            onEditingComplete: () {
              _loginPasswordFocus.requestFocus();
            },
            onChanged: (_) {
              if (_loginEmailError != null) {
                setState(() => _loginEmailError = null);
              }
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _loginPasswordController,
            label: 'Mot de passe',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outlined,
            obscureText: _obscureLoginPassword,
            errorText: _loginPasswordError,
            focusNode: _loginPasswordFocus,
            onEditingComplete: _login,
            onChanged: (_) {
              if (_loginPasswordError != null) {
                setState(() => _loginPasswordError = null);
              }
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLoginPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() => _obscureLoginPassword = !_obscureLoginPassword);
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _signupUsernameController,
            label: 'Nom d\'utilisateur',
            hintText: 'PokemonMaster',
            prefixIcon: Icons.person_outlined,
            errorText: _signupUsernameError,
            focusNode: _signupUsernameFocus,
            onEditingComplete: () {
              _signupEmailFocus.requestFocus();
            },
            onChanged: (_) {
              if (_signupUsernameError != null) {
                setState(() => _signupUsernameError = null);
              }
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _signupEmailController,
            label: 'Email',
            hintText: 'votre@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText: _signupEmailError,
            focusNode: _signupEmailFocus,
            onEditingComplete: () {
              _signupPasswordFocus.requestFocus();
            },
            onChanged: (_) {
              if (_signupEmailError != null) {
                setState(() => _signupEmailError = null);
              }
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _signupPasswordController,
            label: 'Mot de passe',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outlined,
            obscureText: _obscureSignupPassword,
            errorText: _signupPasswordError,
            focusNode: _signupPasswordFocus,
            onEditingComplete: () {
              _signupConfirmPasswordFocus.requestFocus();
            },
            onChanged: (_) {
              if (_signupPasswordError != null) {
                setState(() => _signupPasswordError = null);
              }
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignupPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(
                  () => _obscureSignupPassword = !_obscureSignupPassword,
                );
              },
            ),
          ),
          PasswordStrengthIndicator(password: _passwordStrength),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _signupConfirmPasswordController,
            label: 'Confirmer le mot de passe',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outlined,
            obscureText: _obscureConfirmPassword,
            errorText: _signupConfirmPasswordError,
            focusNode: _signupConfirmPasswordFocus,
            onEditingComplete: _signUp,
            onChanged: (_) {
              if (_signupConfirmPasswordError != null) {
                setState(() => _signupConfirmPasswordError = null);
              }
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
