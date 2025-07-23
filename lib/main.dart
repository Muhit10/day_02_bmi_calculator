import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  // State variables
  double height = 170.0;
  double weight = 70.0;
  int age = 25;
  bool isMale = true;
  double bmiValue = 0.0;
  String bmiCategory = '';
  Color bmiColor = Colors.grey;
  bool hasCalculated = false;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _resultAnimation;
  late Animation<double> _genderAnimation;
  late Animation<double> _sliderAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _resultAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _genderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _sliderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculate BMI with gender-specific adjustments
  void calculateBMI() {
    // Basic BMI calculation
    double heightInMeters = height / 100;
    double rawBMI = weight / (heightInMeters * heightInMeters);

    // Apply gender-specific adjustments
    if (isMale) {
      // Male BMI categories
      if (rawBMI < 18.5) {
        bmiCategory = 'Underweight';
        bmiColor = Colors.blue;
      } else if (rawBMI >= 18.5 && rawBMI < 25.0) {
        bmiCategory = 'Normal';
        bmiColor = Colors.green;
      } else if (rawBMI >= 25.0 && rawBMI < 30.0) {
        bmiCategory = 'Overweight';
        bmiColor = Colors.orange;
      } else {
        bmiCategory = 'Obese';
        bmiColor = Colors.red;
      }
    } else {
      // Female BMI categories (slightly different thresholds)
      if (rawBMI < 17.5) {
        bmiCategory = 'Underweight';
        bmiColor = Colors.blue;
      } else if (rawBMI >= 17.5 && rawBMI < 24.0) {
        bmiCategory = 'Normal';
        bmiColor = Colors.green;
      } else if (rawBMI >= 24.0 && rawBMI < 29.0) {
        bmiCategory = 'Overweight';
        bmiColor = Colors.orange;
      } else {
        bmiCategory = 'Obese';
        bmiColor = Colors.red;
      }
    }

    // Age-based adjustment (simplified)
    if (age < 18) {
      // For younger people, BMI thresholds are typically lower
      rawBMI = rawBMI * 0.95;
    } else if (age > 65) {
      // For older people, BMI thresholds are typically higher
      rawBMI = rawBMI * 1.05;
    }

    setState(() {
      bmiValue = rawBMI;
      hasCalculated = true;
    });

    // Animate the result card
    _animationController.reset();
    _animationController.forward();
  }

  // Reset the calculator
  void resetCalculator() {
    setState(() {
      height = 170.0;
      weight = 70.0;
      age = 25;
      isMale = true;
      bmiValue = 0.0;
      bmiCategory = '';
      bmiColor = Colors.grey;
      hasCalculated = false;
    });

    // Animate the UI elements
    _animationController.reset();
    _animationController.forward();
  }

  // Build gender selector with animation
  Widget _buildGenderSelector() {
    return AnimatedBuilder(
      animation: _genderAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_genderAnimation.value * 0.2),
          child: Opacity(
            opacity: _genderAnimation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = true;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.male,
                              size: 80,
                              color: isMale
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isMale
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isMale
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = false;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.female,
                              size: 80,
                              color: !isMale
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: !isMale
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: !isMale
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build slider card with animation
  Widget _buildSliderCard(String title, double value, double min, double max,
      String unit, Function(double) onChanged) {
    return AnimatedBuilder(
      animation: _sliderAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _sliderAnimation.value)),
          child: Opacity(
            opacity: _sliderAnimation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: isMale
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: value,
                      min: min,
                      max: max,
                      activeColor: isMale
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      onChanged: (newValue) {
                        onChanged(newValue);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          min.toStringAsFixed(0) + ' ' + unit,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          max.toStringAsFixed(0) + ' ' + unit,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build age selector with animation
  Widget _buildAgeSelector() {
    return AnimatedBuilder(
      animation: _sliderAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _sliderAnimation.value)),
          child: Opacity(
            opacity: _sliderAnimation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      age.toString(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: isMale
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircularButton(
                          icon: Icons.remove,
                          onPressed: () {
                            setState(() {
                              if (age > 1) age--;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildCircularButton(
                          icon: Icons.add,
                          onPressed: () {
                            setState(() {
                              if (age < 120) age++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build circular button for age selector
  Widget _buildCircularButton({required IconData icon, required Function onPressed}) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isMale
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isMale
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  // Build action buttons with animation
  Widget _buildActionButtons() {
    return AnimatedBuilder(
      animation: _sliderAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _sliderAnimation.value)),
          child: Opacity(
            opacity: _sliderAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  if (hasCalculated)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: resetCalculator,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: hasCalculated ? 8.0 : 0.0),
                      child: ElevatedButton.icon(
                        onPressed: calculateBMI,
                        icon: Icon(hasCalculated
                            ? Icons.calculate
                            : Icons.play_arrow),
                        label: Text(
                            hasCalculated ? 'Recalculate' : 'Calculate BMI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMale
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build result card with animation
  Widget _buildResultCard() {
    if (!hasCalculated) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _resultAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _resultAnimation.value,
          child: Opacity(
            opacity: _resultAnimation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Result',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      bmiCategory.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      bmiValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHealthTip(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build health tip based on BMI category and gender
  Widget _buildHealthTip() {
    String tipText = '';

    if (isMale) {
      // Health tips for males
      switch (bmiCategory) {
        case 'Underweight':
          tipText =
              'Consider increasing your caloric intake with protein-rich foods and strength training to build muscle mass.';
          break;
        case 'Normal':
          tipText =
              'Great job! Maintain your healthy lifestyle with regular exercise and balanced nutrition.';
          break;
        case 'Overweight':
          tipText =
              'Focus on increasing physical activity, especially cardio and strength training, while moderating portion sizes.';
          break;
        case 'Obese':
          tipText =
              'Consider consulting a healthcare professional for a personalized weight management plan including diet, exercise, and lifestyle changes.';
          break;
      }
    } else {
      // Health tips for females
      switch (bmiCategory) {
        case 'Underweight':
          tipText =
              'Focus on nutrient-dense foods and consider adding strength training to build lean muscle while maintaining bone density.';
          break;
        case 'Normal':
          tipText =
              'Excellent! Continue your balanced approach to nutrition and regular physical activity to maintain your health.';
          break;
        case 'Overweight':
          tipText =
              'Consider a combination of cardio, strength training, and mindful eating practices to achieve a healthy weight.';
          break;
        case 'Obese':
          tipText =
              'Speak with a healthcare provider about creating a sustainable plan for weight management that addresses your specific health needs.';
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        tipText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGenderSelector(),
              const SizedBox(height: 16),
              _buildSliderCard(
                'Height',
                height,
                120.0,
                220.0,
                'cm',
                (newValue) {
                  setState(() {
                    height = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSliderCard(
                'Weight',
                weight,
                30.0,
                150.0,
                'kg',
                (newValue) {
                  setState(() {
                    weight = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAgeSelector(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              if (hasCalculated) const SizedBox(height: 16),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }
}
