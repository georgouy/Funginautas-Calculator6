import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/calculation_card_widget.dart';
import './widgets/date_section_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';

class CalculationHistory extends StatefulWidget {
  const CalculationHistory({super.key});

  @override
  State<CalculationHistory> createState() => _CalculationHistoryState();
}

class _CalculationHistoryState extends State<CalculationHistory> {
  bool _isSearchVisible = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock calculation history data
  final List<Map<String, dynamic>> _calculationHistory = [
    {
      "id": 1,
      "type": "CVG",
      "date": "2024-01-15",
      "timestamp": "14:30",
      "inputs": {"cocoCoir": 500.0},
      "results": {
        "cocoCoir": 500.0,
        "water": 1250.0,
        "gypsum": 25.0,
        "vermiculite": 500.0
      },
      "notes": "Perfect substrate mix for oyster mushrooms"
    },
    {
      "id": 2,
      "type": "LC",
      "date": "2024-01-15",
      "timestamp": "10:15",
      "inputs": {
        "water": 1000.0,
        "ingredient": "Malt Extract",
        "percentage": 2
      },
      "results": {"water": 1000.0, "maltExtract": 20.0},
      "notes": "Standard LC preparation"
    },
    {
      "id": 3,
      "type": "CVG",
      "date": "2024-01-14",
      "timestamp": "16:45",
      "inputs": {"cocoCoir": 750.0},
      "results": {
        "cocoCoir": 750.0,
        "water": 1875.0,
        "gypsum": 37.5,
        "vermiculite": 750.0
      },
      "notes": "Large batch for shiitake cultivation"
    },
    {
      "id": 4,
      "type": "LC",
      "date": "2024-01-14",
      "timestamp": "09:20",
      "inputs": {"water": 500.0, "ingredient": "Honey", "percentage": 4},
      "results": {"water": 500.0, "honey": 20.0},
      "notes": "High concentration for aggressive growth"
    },
    {
      "id": 5,
      "type": "CVG",
      "date": "2024-01-13",
      "timestamp": "13:10",
      "inputs": {"cocoCoir": 300.0},
      "results": {
        "cocoCoir": 300.0,
        "water": 750.0,
        "gypsum": 15.0,
        "vermiculite": 300.0
      },
      "notes": "Small test batch"
    }
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_searchQuery.isEmpty) return _calculationHistory;

    return _calculationHistory.where((calculation) {
      final type = (calculation["type"] as String).toLowerCase();
      final notes = (calculation["notes"] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return type.contains(query) || notes.contains(query);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedHistory {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final calculation in _filteredHistory) {
      final date = calculation["date"] as String;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(calculation);
    }

    return grouped;
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear History',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to clear all calculation history? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculationHistory.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calculation history cleared'),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _onCalculationAction(String action, Map<String, dynamic> calculation) {
    switch (action) {
      case 'view':
        _showCalculationDetails(calculation);
        break;
      case 'recalculate':
        _recalculateFromHistory(calculation);
        break;
      case 'share':
        _shareCalculation(calculation);
        break;
      case 'delete':
        _deleteCalculation(calculation);
        break;
      case 'duplicate':
        _duplicateCalculation(calculation);
        break;
      case 'export':
        _exportCalculation(calculation);
        break;
    }
  }

  void _showCalculationDetails(Map<String, dynamic> calculation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: calculation["type"] == "CVG"
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${calculation["type"]} Calculator',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: calculation["type"] == "CVG"
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${calculation["date"]} ${calculation["timestamp"]}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                'Input Values',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              _buildDetailSection(
                  calculation["inputs"] as Map<String, dynamic>),
              SizedBox(height: 2.h),
              Text(
                'Results',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              _buildDetailSection(
                  calculation["results"] as Map<String, dynamic>),
              if (calculation["notes"] != null &&
                  (calculation["notes"] as String).isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  'Notes',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    calculation["notes"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Column(
        children: data.entries.map((entry) {
          String label = _formatLabel(entry.key);
          String value = _formatValue(entry.key, entry.value);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  value,
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatLabel(String key) {
    switch (key) {
      case 'cocoCoir':
        return 'Coco Coir';
      case 'water':
        return 'Water';
      case 'gypsum':
        return 'Gypsum';
      case 'vermiculite':
        return 'Vermiculite';
      case 'maltExtract':
        return 'Malt Extract';
      case 'honey':
        return 'Honey';
      case 'ingredient':
        return 'Ingredient';
      case 'percentage':
        return 'Percentage';
      default:
        return key;
    }
  }

  String _formatValue(String key, dynamic value) {
    if (value is double) {
      if (key == 'water' || key == 'vermiculite') {
        return '${value.toStringAsFixed(1)} ml';
      } else {
        return '${value.toStringAsFixed(1)} g';
      }
    } else if (value is int) {
      return '$value%';
    } else {
      return value.toString();
    }
  }

  void _recalculateFromHistory(Map<String, dynamic> calculation) {
    final type = calculation["type"] as String;
    if (type == "CVG") {
      Navigator.pushNamed(context, '/cvg-substrate-calculator');
    } else {
      Navigator.pushNamed(context, '/lc-broth-calculator');
    }
  }

  void _shareCalculation(Map<String, dynamic> calculation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${calculation["type"]} calculation...'),
      ),
    );
  }

  void _deleteCalculation(Map<String, dynamic> calculation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Calculation',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this calculation?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculationHistory
                      .removeWhere((item) => item["id"] == calculation["id"]);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calculation deleted'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _duplicateCalculation(Map<String, dynamic> calculation) {
    final newCalculation = Map<String, dynamic>.from(calculation);
    newCalculation["id"] = DateTime.now().millisecondsSinceEpoch;
    newCalculation["date"] = DateTime.now().toString().split(' ')[0];
    newCalculation["timestamp"] =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    setState(() {
      _calculationHistory.insert(0, newCalculation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculation duplicated'),
      ),
    );
  }

  void _exportCalculation(Map<String, dynamic> calculation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${calculation["type"]} calculation...'),
      ),
    );
  }

  void _startNewCalculation() {
    Navigator.pushNamed(context, '/calculator-selector-dashboard');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Calculation History',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          if (_calculationHistory.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          Expanded(
            child: _calculationHistory.isEmpty
                ? EmptyStateWidget(onStartCalculation: _startNewCalculation)
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('History refreshed'),
                        ),
                      );
                    },
                    child: _filteredHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'search_off',
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                  size: 64,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'No results found',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Try adjusting your search terms',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            itemCount: _groupedHistory.length,
                            itemBuilder: (context, index) {
                              final date =
                                  _groupedHistory.keys.elementAt(index);
                              final calculations = _groupedHistory[date]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateSectionHeaderWidget(date: date),
                                  ...calculations.map(
                                    (calculation) => CalculationCardWidget(
                                      calculation: calculation,
                                      onAction: _onCalculationAction,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _calculationHistory.isNotEmpty
          ? FloatingActionButton(
              onPressed: _startNewCalculation,
              backgroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
              foregroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 24,
              ),
            )
          : null,
    );
  }
}
