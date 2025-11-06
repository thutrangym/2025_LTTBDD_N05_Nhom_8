import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/app_state.dart';
import '../../core/widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    RadioGroup<AppTheme>(
                      groupValue: appState.theme,
                      onChanged: (value) {
                        if (value != null) {
                          appState.setTheme(value);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<AppTheme>(
                            title: Text('light'.tr()),
                            value: AppTheme.light,
                          ),
                          RadioListTile<AppTheme>(
                            title: Text('dark'.tr()),
                            value: AppTheme.dark,
                          ),
                          RadioListTile<AppTheme>(
                            title: Text('system'.tr()),
                            value: AppTheme.system,
                          ),
                        ],
                      ),
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
                    RadioGroup<AppLanguage>(
                      groupValue: appState.language,
                      onChanged: (value) {
                        if (value != null) {
                          appState.setLanguage(value);
                          if (value == AppLanguage.en) {
                            context.setLocale(const Locale('en', 'US'));
                          } else {
                            context.setLocale(const Locale('vi', 'VN'));
                          }
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<AppLanguage>(
                            title: Text('english'.tr()),
                            value: AppLanguage.en,
                          ),
                          RadioListTile<AppLanguage>(
                            title: Text('vietnamese'.tr()),
                            value: AppLanguage.vi,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
