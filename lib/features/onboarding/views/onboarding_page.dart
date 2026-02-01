import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/sync_repository.dart';
import '../../settings/providers/settings_provider.dart';
import 'core_values_step.dart';
import 'north_star_step.dart';
import '../onboarding_presets.dart';

class OnboardingPage extends StatefulWidget {
  final List<String>? prefillCoreValues;
  final String? prefillNorthStarMetric;
  final bool popOnComplete;

  const OnboardingPage({
    super.key,
    this.prefillCoreValues,
    this.prefillNorthStarMetric,
    this.popOnComplete = false,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  final Set<String> _selectedCoreValues = {};
  bool _useCustomCoreValues = false;
  final _customCoreValuesController = TextEditingController();
  final List<String> _customCoreValues = [];

  String? _selectedNorthStar;
  bool _useCustomNorthStar = false;
  final _customNorthStarNameController = TextEditingController();
  final _customNorthStarUnitController = TextEditingController();
  final _customNorthStarTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillCoreValues();
    _prefillNorthStarMetric();
  }

  void _prefillCoreValues() {
    final values = widget.prefillCoreValues;
    if (values == null || values.isEmpty) return;
    for (final value in values) {
      if (coreValuePresets.contains(value)) {
        _selectedCoreValues.add(value);
      } else {
        _customCoreValues.add(value);
      }
    }
    if (_customCoreValues.isNotEmpty) {
      _useCustomCoreValues = true;
    }
  }

  void _prefillNorthStarMetric() {
    final metric = widget.prefillNorthStarMetric;
    if (metric == null || metric.isEmpty) return;
    if (northStarPresets.contains(metric)) {
      _selectedNorthStar = metric;
      return;
    }
    _useCustomNorthStar = true;
    final match = RegExp(r'^(.*)\\s*\\((.*)\\)$').firstMatch(metric);
    if (match == null) {
      _customNorthStarNameController.text = metric;
      return;
    }
    final name = match.group(1)?.trim() ?? '';
    final details = match.group(2)?.trim() ?? '';
    _customNorthStarNameController.text = name;
    final parts = details.split('/');
    if (parts.isEmpty) return;
    final left = parts.first.trim();
    final leftParts = left.split(' ');
    if (leftParts.isEmpty) return;
    _customNorthStarTargetController.text = leftParts.first.trim();
    if (leftParts.length > 1) {
      _customNorthStarUnitController.text = leftParts.sublist(1).join(' ').trim();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _customCoreValuesController.dispose();
    _customNorthStarNameController.dispose();
    _customNorthStarUnitController.dispose();
    _customNorthStarTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0${_currentPage + 1} / 02',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return TextButton(
                        onPressed: () => ref.read(authServiceProvider).signOut(),
                        child: const Text('LOG OUT', style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    CoreValuesStep(
                      selectedValues: _selectedCoreValues,
                      customValues: _customCoreValues,
                      useCustom: _useCustomCoreValues,
                      onToggleCustom: _setUseCustomCoreValues,
                      customController: _customCoreValuesController,
                      onToggleValue: _toggleCoreValue,
                      onAddCustomValue: _addCustomCoreValue,
                      onRemoveCustomValue: _removeCustomCoreValue,
                    ),
                    NorthStarStep(
                      selectedMetric: _selectedNorthStar,
                      useCustom: _useCustomNorthStar,
                      onToggleCustom: _setUseCustomNorthStar,
                      nameController: _customNorthStarNameController,
                      unitController: _customNorthStarUnitController,
                      targetController: _customNorthStarTargetController,
                      onSelectMetric: _selectNorthStarMetric,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('BACK', style: TextStyle(color: Colors.black)),
                    )
                  else
                    const SizedBox.shrink(),
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () => _nextStep(ref),
                        child: Text(_currentPage == 1 ? 'FINISH' : 'NEXT'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleCoreValue(String value) {
    setState(() {
      if (_selectedCoreValues.contains(value)) {
        _selectedCoreValues.remove(value);
        return;
      }
      if (_selectedCoreValues.length + _customCoreValues.length >= 3) return;
      _selectedCoreValues.add(value);
    });
  }

  void _setUseCustomCoreValues(bool value) {
    setState(() {
      _useCustomCoreValues = value;
      if (!value) {
        _customCoreValues.clear();
        _customCoreValuesController.clear();
      }
    });
  }

  void _setUseCustomNorthStar(bool value) {
    setState(() {
      _useCustomNorthStar = value;
      if (value) {
        _selectedNorthStar = null;
      } else {
        _customNorthStarNameController.clear();
        _customNorthStarUnitController.clear();
        _customNorthStarTargetController.clear();
      }
    });
  }

  void _selectNorthStarMetric(String metric) {
    setState(() {
      _selectedNorthStar = metric;
      _useCustomNorthStar = false;
      _customNorthStarNameController.clear();
      _customNorthStarUnitController.clear();
      _customNorthStarTargetController.clear();
    });
  }

  void _addCustomCoreValue() {
    final raw = _customCoreValuesController.text.trim();
    if (raw.isEmpty) return;
    final candidate = raw.split(',').first.trim();
    if (candidate.isEmpty) return;
    if (_customCoreValues.length + _selectedCoreValues.length >= 3) {
      _showMessage('You can select up to 3 core values.');
      return;
    }
    if (_selectedCoreValues.contains(candidate) || _customCoreValues.contains(candidate)) {
      _showMessage('That value is already selected.');
      return;
    }
    setState(() {
      _customCoreValues.add(candidate);
      _customCoreValuesController.clear();
    });
  }

  void _removeCustomCoreValue(String value) {
    setState(() {
      _customCoreValues.remove(value);
    });
  }

  void _nextStep(WidgetRef ref) async {
    if (_currentPage < 1) {
      unawaited(_pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ));
    } else {
      // Save data and finish
      final values = [..._selectedCoreValues, ..._customCoreValues];
      if (values.isEmpty) {
        _showMessage('Select at least one core value.');
        return;
      }

      String? metric = _selectedNorthStar;
      if (_useCustomNorthStar) {
        final name = _customNorthStarNameController.text.trim();
        final unit = _customNorthStarUnitController.text.trim();
        final target = _customNorthStarTargetController.text.trim();
        if (name.isNotEmpty && unit.isNotEmpty && target.isNotEmpty) {
          metric = '$name ($target $unit / week)';
        }
      }
      if (metric == null || metric.isEmpty) {
        _showMessage('Select a North Star metric.');
        return;
      }

      await ref.read(settingsControllerProvider.notifier).updateContext(
        coreValues: values,
        northStarMetric: metric,
      );
      await ref.read(syncRepositoryProvider).syncAll();
      
      if (mounted) {
        if (widget.popOnComplete) {
          Navigator.of(context).pop();
        } else {
          unawaited(Navigator.of(context).pushReplacementNamed('/'));
        }
      }
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
