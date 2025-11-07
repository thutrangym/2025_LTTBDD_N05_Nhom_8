import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/app_state.dart';
import '../../core/widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, this.onSignOut});

  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'theme'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        RadioListTile<AppTheme>(
                          title: Text('light'.tr()),
                          value: AppTheme.light,
                          groupValue: appState.theme,
                          onChanged: (value) {
                            if (value != null) {
                              appState.setTheme(value);
                            }
                          },
                        ),
                        RadioListTile<AppTheme>(
                          title: Text('dark'.tr()),
                          value: AppTheme.dark,
                          groupValue: appState.theme,
                          onChanged: (value) {
                            if (value != null) {
                              appState.setTheme(value);
                            }
                          },
                        ),
                        RadioListTile<AppTheme>(
                          title: Text('system'.tr()),
                          value: AppTheme.system,
                          groupValue: appState.theme,
                          onChanged: (value) {
                            if (value != null) {
                              appState.setTheme(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'language'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        RadioListTile<AppLanguage>(
                          title: Text('english'.tr()),
                          value: AppLanguage.en,
                          groupValue: appState.language,
                          onChanged: (value) {
                            if (value != null) {
                              appState.setLanguage(value);
                              context.setLocale(const Locale('en'));
                            }
                          },
                        ),
                        RadioListTile<AppLanguage>(
                          title: Text('vietnamese'.tr()),
                          value: AppLanguage.vi,
                          groupValue: appState.language,
                          onChanged: (value) {
                            if (value != null) {
                              appState.setLanguage(value);
                              context.setLocale(const Locale('vi'));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await appState.saveSettings();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('settings_saved'.tr())),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: Text('save'.tr()),
                ),
              ),
              if (onSignOut != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    await onSignOut!.call();
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      navigator.pop();
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: Text('logout'.tr()),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
