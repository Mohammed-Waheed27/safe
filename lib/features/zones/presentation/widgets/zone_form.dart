import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/zone_model.dart';
import '../bloc/zone_bloc.dart';
import '../../../../core/config/app_router.dart';

class ZoneForm extends StatefulWidget {
  final ZoneModel? zone;

  const ZoneForm({Key? key, this.zone}) : super(key: key);

  @override
  State<ZoneForm> createState() => _ZoneFormState();
}

class _ZoneFormState extends State<ZoneForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _zoneTokenController;
  late int _maximumCount;
  late int _threshold;

  String? _currentUserId;
  String? _defaultUserToken;
  bool _isLoadingUserData = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.zone?.name);
    _descriptionController = TextEditingController(
      text: widget.zone?.description,
    );
    _zoneTokenController = TextEditingController(text: widget.zone?.zoneToken);
    _maximumCount = widget.zone?.maximumCount ?? 100;
    _threshold = widget.zone?.threshold ?? 80;

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _currentUserId = await AppRouter.currentUserId;
      _defaultUserToken = await AppRouter.currentUserToken;

      // If creating new zone and no token set, use user's default token
      if (widget.zone == null && _defaultUserToken != null) {
        _zoneTokenController.text = _defaultUserToken!;
      }

      setState(() {
        _isLoadingUserData = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoadingUserData = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _zoneTokenController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentUserId == null || _currentUserId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      ZoneModel zone;

      if (widget.zone == null) {
        // Create new zone using factory method
        zone = ZoneModel.create(
          name: _nameController.text,
          description: _descriptionController.text,
          createdBy: _currentUserId!,
          userToken: _zoneTokenController.text.trim(),
          apiKey: '9b488108-0694-45dc-8c6d-a7456f50a37d', // Default API key
          maximumCount: _maximumCount,
          threshold: _threshold,
        );
        context.read<ZoneBloc>().add(CreateZone(zone: zone));
      } else {
        // Update existing zone
        zone = widget.zone!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          maximumCount: _maximumCount,
          threshold: _threshold,
          updatedAt: DateTime.now().toIso8601String(),
          videoSDK: widget.zone!.videoSDK.copyWith(
            token: _zoneTokenController.text.trim(),
          ),
        );
        context.read<ZoneBloc>().add(UpdateZone(zone: zone));
      }

      // Don't navigate manually - let the BLoC state handle it
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoadingUserData) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.zone == null ? 'Create Zone' : 'Edit Zone'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BlocListener<ZoneBloc, ZoneState>(
      listener: (context, state) {
        if (state is ZoneLoading) {
          setState(() {
            _isSaving = true;
          });
        } else if (state is ZoneCreated || state is ZoneUpdated) {
          setState(() {
            _isSaving = false;
          });
          // Success - navigation will be handled by the zones page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is ZoneCreated
                    ? 'Zone created successfully!'
                    : 'Zone updated successfully!',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ZoneError) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.zone == null ? 'Create Zone' : 'Edit Zone'),
          actions: [
            TextButton(
              onPressed: _isSaving ? null : _handleSubmit,
              child:
                  _isSaving
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Save'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Zone Name',
                  hintText: 'Enter zone name (e.g., Main Plaza)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zone name';
                  }
                  if (value.length < 3) {
                    return 'Zone name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter zone description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Zone Token Field
              TextFormField(
                controller: _zoneTokenController,
                decoration: InputDecoration(
                  labelText: 'Zone Token',
                  hintText:
                      _defaultUserToken ?? 'Enter VideoSDK token for this zone',
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText:
                      'VideoSDK token used for video sessions in this zone',
                  suffixIcon:
                      _defaultUserToken != null
                          ? IconButton(
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Use your default token',
                            onPressed: () {
                              _zoneTokenController.text = _defaultUserToken!;
                            },
                          )
                          : null,
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zone token';
                  }
                  if (value.length < 20) {
                    return 'Token appears to be invalid (too short)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24.0),
              Text(
                'Maximum Capacity: $_maximumCount people',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _maximumCount.toDouble(),
                      min: 10,
                      max: 500,
                      divisions: 49,
                      label: '$_maximumCount people',
                      onChanged: (value) {
                        setState(() {
                          _maximumCount = value.toInt();
                          if (_threshold > _maximumCount) {
                            _threshold = (_maximumCount * 0.8).toInt();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _maximumCount.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Text(
                'Alert Threshold: $_threshold people',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                'Alerts will trigger when this capacity is reached',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _threshold.toDouble(),
                      min: 10,
                      max: _maximumCount.toDouble(),
                      divisions: (_maximumCount - 10) ~/ 10,
                      label: '$_threshold people',
                      onChanged: (value) {
                        setState(() {
                          _threshold = value.toInt();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _threshold.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              // Preview card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preview', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8.0),
                      Text(
                        'Name: ${_nameController.text.isEmpty ? "Zone Name" : _nameController.text}',
                      ),
                      Text(
                        'Description: ${_descriptionController.text.isEmpty ? "Zone Description" : _descriptionController.text}',
                      ),
                      Text('Capacity: 0/$_maximumCount people'),
                      Text('Alert at: $_threshold people'),
                      Text(
                        'Token: ${_zoneTokenController.text.isEmpty ? "Not set" : "Set (${_zoneTokenController.text.length} chars)"}',
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: 0.0,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
