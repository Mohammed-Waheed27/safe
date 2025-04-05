import 'package:flutter/material.dart';
import 'package:hrsm/core/theme/colors/C.dart';

class AnalysisTypeDropdown extends StatefulWidget {
  const AnalysisTypeDropdown({super.key});

  @override
  State<AnalysisTypeDropdown> createState() => _AnalysisTypeDropdownState();
}

class _AnalysisTypeDropdownState extends State<AnalysisTypeDropdown> {
  final List<AnalysisTypeOption> _options = [
    AnalysisTypeOption(
      title: 'Standard Analysis',
      description: 'Basic monitoring with human detection and standard alerts',
    ),
    AnalysisTypeOption(
      title: 'Advanced Analysis',
      description: 'Enhanced object recognition with AI',
    ),
    AnalysisTypeOption(
      title: 'Premium Analysis',
      description: 'Full real-time with behavioral analytics',
    ),
    AnalysisTypeOption(
      title: 'Custom Analysis',
      description: 'Tailored to specific monitoring needs',
    ),
  ];

  bool _isExpanded = false;
  AnalysisTypeOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = _options[0]; // Default to Standard Analysis
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: C.grey2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedOption?.title ?? 'Select analysis type',
                    style: TextStyle(
                      color: _selectedOption != null ? Colors.black : C.grey2,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: C.grey2,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: C.grey2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: _options.map((option) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedOption = option;
                      _isExpanded = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedOption == option ? C.orange2 : null,
                      border: Border(
                        bottom: BorderSide(
                          color: option != _options.last
                              ? C.grey2
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: C.grey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class AnalysisTypeOption {
  final String title;
  final String description;

  AnalysisTypeOption({
    required this.title,
    required this.description,
  });
}
