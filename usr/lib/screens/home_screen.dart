import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/scanner_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 20 Forex Currencies
  final List<String> currencies = [
    'EUR/USD', 'GBP/USD', 'USD/JPY', 'USD/CHF', 'AUD/USD',
    'USD/CAD', 'NZD/USD', 'EUR/GBP', 'EUR/JPY', 'GBP/JPY',
    'CHF/JPY', 'EUR/AUD', 'EUR/CAD', 'EUR/CHF', 'GBP/AUD',
    'GBP/CAD', 'GBP/CHF', 'AUD/JPY', 'AUD/CAD', 'AUD/NZD'
  ];

  final List<String> timeframes = ['5 sec', '1 min', '5 min', '1 hour'];

  String selectedCurrency = 'EUR/USD';
  String selectedTimeframe = '1 min';
  
  bool isScanning = false;
  String? aiPrediction; // 'UP' or 'DOWN'
  bool tradePlaced = false;

  void startAiAnalysis() {
    setState(() {
      isScanning = true;
      aiPrediction = null;
      tradePlaced = false;
    });

    // Simulate AI processing time
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isScanning = false;
        // As per user request, showing a DOWN trade scenario
        aiPrediction = 'DOWN'; 
        tradePlaced = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smart_toy, color: Color(0xFF00C853)),
            const SizedBox(width: 8),
            const Text(
              'Nano AI',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00C853).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Color(0xFF00C853),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Camera / Chart Scanner Area
          Expanded(
            flex: 5,
            child: ScannerView(
              isScanning: isScanning,
              prediction: aiPrediction,
            ),
          ),
          
          // Controls Area
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2329),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency Selector
                  const Text(
                    'Select Asset (20 Pairs)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B0E11),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCurrency,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF1E2329),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        items: currencies.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Row(
                              children: [
                                const Icon(Icons.currency_exchange, size: 18, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(
                                  currency,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCurrency = newValue!;
                            aiPrediction = null;
                            tradePlaced = false;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Timeframe Selector
                  const Text(
                    'Expiration Time',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: timeframes.map((time) {
                      final isSelected = selectedTimeframe == time;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTimeframe = time;
                            aiPrediction = null;
                            tradePlaced = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00C853).withOpacity(0.2) : const Color(0xFF0B0E11),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF00C853) : Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF00C853) : Colors.grey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const Spacer(),

                  // AI Result & Trade Status
                  if (aiPrediction != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: aiPrediction == 'UP' 
                            ? const Color(0xFF00C853).withOpacity(0.1) 
                            : const Color(0xFFD50000).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: aiPrediction == 'UP' 
                              ? const Color(0xFF00C853).withOpacity(0.5) 
                              : const Color(0xFFD50000).withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            aiPrediction == 'UP' ? Icons.trending_up : Icons.trending_down,
                            color: aiPrediction == 'UP' ? const Color(0xFF00C853) : const Color(0xFFD50000),
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Signal: $aiPrediction',
                                  style: TextStyle(
                                    color: aiPrediction == 'UP' ? const Color(0xFF00C853) : const Color(0xFFD50000),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                if (tradePlaced)
                                  const Text(
                                    'Trade Placed Successfully',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          const Text(
                            '98% Accuracy',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isScanning ? null : startAiAnalysis,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isScanning
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Analyzing Chart...',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.document_scanner),
                                SizedBox(width: 8),
                                Text(
                                  'Scan Chart & Predict',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
