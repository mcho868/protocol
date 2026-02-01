import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../onboarding/views/onboarding_page.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_value_list.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final name = _displayName(user);
    final email = user?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: settingsAsync.when(
        data: (contextData) {
          final coreValues = contextData?.coreValues ?? [];
          final northStar = contextData?.northStarMetric ?? 'Not set';

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SettingsSection(
                title: 'PROFILE',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsItem(label: 'Name', value: name),
                    SettingsItem(label: 'Email', value: email),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SettingsSection(
                title: 'CORE VALUES',
                actionText: 'EDIT',
                onAction: () => _editContext(context, coreValues, northStar),
                child: SettingsValueList(values: coreValues),
              ),
              const SizedBox(height: 32),
              SettingsSection(
                title: 'NORTH STAR',
                actionText: 'EDIT',
                onAction: () => _editContext(context, coreValues, northStar),
                child: Text(
                  northStar,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _displayName(User? user) {
    final metadata = user?.userMetadata ?? {};
    final name = metadata['full_name'] ?? metadata['name'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    return user?.email ?? 'User';
  }

  void _editContext(
    BuildContext context,
    List<String> coreValues,
    String northStar,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingPage(
          prefillCoreValues: coreValues,
          prefillNorthStarMetric: northStar == 'Not set' ? null : northStar,
          popOnComplete: true,
        ),
      ),
    );
  }
}
