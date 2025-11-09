import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/routine.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'calendar/calendar_screen.dart';
import 'home/home_screen.dart';
import 'pomodoro/pomodoro_screen.dart';
import 'settings/setting_screen.dart';
import 'stats/stats_screen.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({
    super.key,
    required this.authService,
    required this.databaseService,
  });

  final AuthService authService;
  final DatabaseService databaseService;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

enum _AuthMode { login, register }

class _AppWrapperState extends State<AppWrapper> {
  int _selectedIndex = 0;
  bool _loadingSession = true;
  bool _submitting = false;
  _AuthMode _mode = _AuthMode.login;
  UserModel? _currentUser;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final user = await widget.authService.loadSession();
    if (!mounted) return;
    setState(() {
      _currentUser = user;
      _loadingSession = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == _AuthMode.login ? _AuthMode.register : _AuthMode.login;
    });
  }

  Future<void> _submitAuth() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _submitting = true;
    });

    try {
      UserModel user;
      if (_mode == _AuthMode.login) {
        user = await widget.authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        user = await widget.authService.register(
          displayName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      _clearForm();
      setState(() {
        _currentUser = user;
        _selectedIndex = 0;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.messageKey.tr())));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('auth_unexpected_error'.tr())));
    } finally {
      if (!mounted) return;
      setState(() {
        _submitting = false;
      });
    }
  }

  Future<void> _handleSignOut() async {
    await widget.authService.signOut();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('logout_success'.tr())));
    setState(() {
      _currentUser = null;
      _selectedIndex = 0;
      _mode = _AuthMode.login;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentUser == null) {
      return _AuthScaffold(
        formKey: _formKey,
        mode: _mode,
        submitting: _submitting,
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        onSubmit: _submitAuth,
        onToggleMode: _toggleMode,
      );
    }

    final pages = <Widget>[
      HomeScreen(user: _currentUser!, onSignOut: _handleSignOut),
      RoutineTab(databaseService: widget.databaseService),
      const CalendarScreen(),
      const PomodoroScreen(),
      const StatsScreen(),
      SettingsScreen(onSignOut: _handleSignOut),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Routine'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Pomodoro'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({
    required this.formKey,
    required this.mode,
    required this.submitting,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final GlobalKey<FormState> formKey;
  final _AuthMode mode;
  final bool submitting;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final isLogin = mode == _AuthMode.login;

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'login'.tr() : 'register'.tr())),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isLogin ? 'loginMessage'.tr() : 'register'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (!isLogin) ...[
                      TextFormField(
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'full_name'.tr(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'field_required'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'email'.tr()),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'field_required'.tr();
                        }
                        if (!RegExp(r'^.+@.+\..+$').hasMatch(value.trim())) {
                          return 'invalid_email'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: isLogin
                          ? TextInputAction.done
                          : TextInputAction.next,
                      decoration: InputDecoration(labelText: 'password'.tr()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'field_required'.tr();
                        }
                        if (value.length < 6) {
                          return 'password_too_short'.tr();
                        }
                        return null;
                      },
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'confirm_password'.tr(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'.tr();
                          }
                          if (value != passwordController.text) {
                            return 'passwords_do_not_match'.tr();
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: submitting ? null : onSubmit,
                      child: submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isLogin ? 'login'.tr() : 'register'.tr()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? 'registerPrompt'.tr()
                              : 'already_registered'.tr(),
                        ),
                        TextButton(
                          onPressed: submitting ? null : onToggleMode,
                          child: Text(isLogin ? 'register'.tr() : 'login'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoutineTab extends StatelessWidget {
  const RoutineTab({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoutineTask>>(
      stream: databaseService.getRoutines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final routines = snapshot.data ?? const <RoutineTask>[];

        return Scaffold(
          appBar: AppBar(title: Text('routine'.tr())),
          body: routines.isEmpty
              ? Center(child: Text('no_routines'.tr()))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: routines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final routine = routines[index];
                    return ListTile(
                      leading: Icon(
                        routine.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                      ),
                      title: Text(routine.name),
                      subtitle: Text(routine.time),
                    );
                  },
                ),
        );
      },
    );
  }
}
