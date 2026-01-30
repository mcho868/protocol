import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/session_provider.dart';
import 'session_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROTOCOL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'SYSTEMS THINKING FOR\nEXECUTIVE PERFORMANCE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              delegate: SliverChildListDelegate([
                _ProtocolCard(
                  title: 'CLARITY\nCOACH',
                  description: 'Untangle complex thoughts.',
                  onTap: () => _startSession(context, ref, 'Clarity Coach'),
                ),
                _ProtocolCard(
                  title: 'DECISION\nCOACH',
                  description: 'Analyze second-order effects.',
                  onTap: () => _startSession(context, ref, 'Decision Coach'),
                ),
                _ProtocolCard(
                  title: 'ACTION\nCOACH',
                  description: 'High-leverage execution.',
                  onTap: () => _startSession(context, ref, 'Action Coach'),
                ),
                _ProtocolCard(
                  title: 'WEEKLY\nREVIEW',
                  description: 'Audit your systems.',
                  onTap: () => _startSession(context, ref, 'Weekly Review Coach'),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 48, 24, 16),
              child: Text(
                'RECENT SESSIONS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          sessionsAsync.when(
            data: (sessions) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final session = sessions[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      session.protocolType?.toUpperCase() ?? 'UNKNOWN',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      session.timestamp?.toString().substring(0, 16) ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                    onTap: () => unawaited(Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionPage(sessionId: session.id),
                      ),
                    )),
                  );
                },
                childCount: sessions.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverToBoxAdapter(
              child: Text('Error: $err'),
            ),
          ),
        ],
      ),
    );
  }

  void _startSession(BuildContext context, WidgetRef ref, String type) async {
    final id = await ref.read(sessionControllerProvider.notifier).createSession(type);
    if (context.mounted) {
      unawaited(Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SessionPage(sessionId: id),
        ),
      ));
    }
  }
}

class _ProtocolCard extends StatelessWidget {
  const _ProtocolCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
