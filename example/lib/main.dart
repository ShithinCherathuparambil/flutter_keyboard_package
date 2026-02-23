import 'package:flutter/material.dart';
import 'package:flutter_keyboard/flutter_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Keyboard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KeyboardDemoScreen(),
    );
  }
}

class KeyboardDemoScreen extends StatefulWidget {
  const KeyboardDemoScreen({super.key});

  @override
  State<KeyboardDemoScreen> createState() => _KeyboardDemoScreenState();
}

class _KeyboardDemoScreenState extends State<KeyboardDemoScreen> {
  final TextEditingController _futureController = TextEditingController();
  final TextEditingController _calculatorController = TextEditingController();
  final TextEditingController _numericController = TextEditingController();
  final TextEditingController _numericDecimalController =
      TextEditingController();
  final TextEditingController _alphanumericController = TextEditingController();
  final TextEditingController _alphabeticController = TextEditingController();
  final TextEditingController _specialController = TextEditingController();
  final TextEditingController _specialSecondaryController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hexController = TextEditingController();
  final TextEditingController _calcLayoutController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _scientificController = TextEditingController();

  String _futureSubmittedValue = '';
  String _calculatorResult = '';
  String _phoneSubmittedValue = '';

  @override
  void dispose() {
    _futureController.dispose();
    _calculatorController.dispose();
    _numericController.dispose();
    _numericDecimalController.dispose();
    _alphanumericController.dispose();
    _alphabeticController.dispose();
    _specialController.dispose();
    _specialSecondaryController.dispose();
    _emailController.dispose();
    _urlController.dispose();
    _phoneController.dispose();
    _hexController.dispose();
    _calcLayoutController.dispose();
    _otpController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _currencyController.dispose();
    _scientificController.dispose();
    super.dispose();
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildReadOnlyField(
    TextEditingController controller,
    String hint, {
    bool dark = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: dark ? const TextStyle(color: Colors.white) : null,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: dark,
        fillColor: dark ? const Color(0xFF141E30) : null,
        hintText: hint,
        hintStyle: dark ? const TextStyle(color: Colors.white54) : null,
      ),
      showCursor: true,
    );
  }

  Widget _buildKeyboardCard({
    required Widget child,
    required Color bg,
    required Color border,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  Widget _buildLayoutDemo({
    required String title,
    required String hint,
    required TextEditingController controller,
    required VirtualKeyboardLayout layout,
    required VirtualKeyboardStyle style,
    VirtualKeyboardLayout? specialCharactersLayout,
    VirtualKeyboardLayout? specialCharactersSecondaryLayout,
    bool allowMultipleDecimals = true,
    int? maxLength,
    bool insertNewLineOnEnter = true,
    ValueChanged<String>? onSubmitted,
    void Function(VirtualKeyboardKey)? onKeyPress,
    Widget? subtitle,
    Color cardColor = const Color(0xFFFFFFFF),
    Color borderColor = const Color(0xFFE0E0E0),
    bool darkInput = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(title),
        const SizedBox(height: 8),
        _buildReadOnlyField(controller, hint, dark: darkInput),
        if (subtitle != null) ...[const SizedBox(height: 8), subtitle],
        const SizedBox(height: 16),
        _buildKeyboardCard(
          bg: cardColor,
          border: borderColor,
          child: FlutterKeyboard(
            controller: controller,
            layout: layout,
            specialCharactersLayout: specialCharactersLayout,
            specialCharactersSecondaryLayout: specialCharactersSecondaryLayout,
            style: style,
            allowMultipleDecimals: allowMultipleDecimals,
            maxLength: maxLength,
            insertNewLineOnEnter: insertNewLineOnEnter,
            onSubmitted: onSubmitted,
            onKeyPress: onKeyPress,
          ),
        ),
      ],
    );
  }

  Widget _spacer() => const SizedBox(height: 48);

  @override
  Widget build(BuildContext context) {
    final baseStyle = VirtualKeyboardStyle(
      backgroundColor: Colors.transparent,
      keyBackgroundColor: Colors.white,
      keyBorderRadius: 8,
      keyPadding: const EdgeInsets.symmetric(vertical: 10),
      keyMargin: const EdgeInsets.all(3),
      keyTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('All Keyboard Layouts Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle('Future Keyboard Studio'),
            const SizedBox(height: 8),
            _buildReadOnlyField(
              _futureController,
              'Type with themes, snippets and predictions',
              dark: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Future submitted: $_futureSubmittedValue',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FutureKeyboard(
                controller: _futureController,
                onSubmitted: (value) {
                  setState(() {
                    _futureSubmittedValue = value;
                  });
                },
                quickSnippets: const ['.ai', '.dev', '@future.io', 'https://'],
                suggestionDictionary: const [
                  'future',
                  'futuristic',
                  'keyboard',
                  'interactive',
                  'customizable',
                  'flutter',
                ],
              ),
            ),
            _spacer(),

            _buildTitle('Calculator Keyboard'),
            const SizedBox(height: 8),
            _buildReadOnlyField(_calculatorController, 'Example: 12/3+5'),
            const SizedBox(height: 8),
            Text(
              'Result: $_calculatorResult',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _buildKeyboardCard(
              bg: Colors.orange.shade50,
              border: Colors.orange.shade200,
              child: CalculatorKeyboard(
                controller: _calculatorController,
                onEvaluated: (value) {
                  setState(() {
                    _calculatorResult = value;
                  });
                },
                onError: (message) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                },
                style: baseStyle.copyWith(
                  pressedColor: Colors.orange.withAlpha((255 * 0.12).round()),
                ),
              ),
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Numeric Layout',
              hint: 'Enter PIN',
              controller: _numericController,
              layout: VirtualKeyboardLayout.numeric(),
              style: baseStyle.copyWith(
                keyTextStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onKeyPress: (key) {
                if (key.action == VirtualKeyboardKeyAction.actionCustom) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Numeric custom action pressed'),
                    ),
                  );
                }
              },
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Numeric Decimal Layout',
              hint: 'Enter amount',
              controller: _numericDecimalController,
              layout: VirtualKeyboardLayout.numericDecimal(),
              style: baseStyle,
              allowMultipleDecimals: false,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Alphanumeric Layout',
              hint: 'Type a message',
              controller: _alphanumericController,
              layout: VirtualKeyboardLayout.alphanumeric(),
              specialCharactersLayout:
                  VirtualKeyboardLayout.specialCharacters(),
              specialCharactersSecondaryLayout:
                  VirtualKeyboardLayout.specialCharactersSecondary(),
              style: baseStyle.copyWith(
                backgroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF141E30), Color(0xFF243B55)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                keyDecoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withAlpha(40)),
                ),
                keyTextStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                keyIconColor: Colors.cyanAccent,
                pressedColor: Colors.cyan.withAlpha(70),
              ),
              cardColor: Colors.transparent,
              borderColor: const Color(0xFF243B55),
              darkInput: true,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Alphabetic Layout',
              hint: 'Letters only',
              controller: _alphabeticController,
              layout: VirtualKeyboardLayout.alphabetic(),
              style: baseStyle,
              cardColor: Colors.indigo.shade50,
              borderColor: Colors.indigo.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Special Characters Layout',
              hint: 'Type symbols',
              controller: _specialController,
              layout: VirtualKeyboardLayout.specialCharacters(),
              style: baseStyle,
              cardColor: Colors.purple.shade50,
              borderColor: Colors.purple.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Secondary Special Characters Layout',
              hint: 'More symbols',
              controller: _specialSecondaryController,
              layout: VirtualKeyboardLayout.specialCharactersSecondary(),
              style: baseStyle,
              cardColor: Colors.deepPurple.shade50,
              borderColor: Colors.deepPurple.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Email Layout',
              hint: 'Enter email address',
              controller: _emailController,
              layout: VirtualKeyboardLayout.email(),
              style: baseStyle,
              cardColor: Colors.blue.shade50,
              borderColor: Colors.blue.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'URL Layout',
              hint: 'Enter website URL',
              controller: _urlController,
              layout: VirtualKeyboardLayout.url(),
              style: baseStyle.copyWith(
                keyTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
                keyIconColor: Colors.teal,
              ),
              cardColor: Colors.teal.shade50,
              borderColor: Colors.teal.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Phone Layout',
              hint: 'Enter phone number',
              controller: _phoneController,
              layout: VirtualKeyboardLayout.phone(),
              style: baseStyle.copyWith(
                keyTextStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
                keyIconColor: Colors.green,
              ),
              maxLength: 15,
              insertNewLineOnEnter: false,
              onSubmitted: (value) {
                setState(() {
                  _phoneSubmittedValue = value;
                });
              },
              subtitle: Text(
                'Last submitted: $_phoneSubmittedValue',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              cardColor: Colors.green.shade50,
              borderColor: Colors.green.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Hexadecimal Layout',
              hint: 'Type hex values',
              controller: _hexController,
              layout: VirtualKeyboardLayout.hexadecimal(),
              style: baseStyle,
              cardColor: Colors.amber.shade50,
              borderColor: Colors.amber.shade300,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Calculator Layout (Raw)',
              hint: 'Raw calculator key matrix',
              controller: _calcLayoutController,
              layout: VirtualKeyboardLayout.calculator(),
              style: baseStyle,
              onKeyPress: (key) {
                if (key.action == VirtualKeyboardKeyAction.actionCustom) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Raw calculator check key')),
                  );
                }
              },
              cardColor: Colors.orange.shade50,
              borderColor: Colors.orange.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'OTP Layout',
              hint: 'Enter one-time passcode',
              controller: _otpController,
              layout: VirtualKeyboardLayout.otp(),
              style: baseStyle,
              maxLength: 8,
              onKeyPress: (key) {
                if (key.action == VirtualKeyboardKeyAction.actionCustom) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('OTP submitted: ${_otpController.text}'),
                    ),
                  );
                }
              },
              cardColor: Colors.cyan.shade50,
              borderColor: Colors.cyan.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Date Layout',
              hint: 'MM/DD/YYYY',
              controller: _dateController,
              layout: VirtualKeyboardLayout.date(),
              style: baseStyle,
              insertNewLineOnEnter: false,
              cardColor: Colors.red.shade50,
              borderColor: Colors.red.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Time Layout',
              hint: 'HH:MM AM/PM',
              controller: _timeController,
              layout: VirtualKeyboardLayout.time(),
              style: baseStyle,
              insertNewLineOnEnter: false,
              cardColor: Colors.lightBlue.shade50,
              borderColor: Colors.lightBlue.shade200,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Currency Layout',
              hint: 'Enter amount with currency symbols',
              controller: _currencyController,
              layout: VirtualKeyboardLayout.currency(),
              style: baseStyle,
              cardColor: Colors.lime.shade50,
              borderColor: Colors.lime.shade300,
            ),
            _spacer(),

            _buildLayoutDemo(
              title: 'Scientific Calculator Layout',
              hint: 'Use parentheses and powers',
              controller: _scientificController,
              layout: VirtualKeyboardLayout.scientificCalculator(),
              style: baseStyle,
              cardColor: Colors.brown.shade50,
              borderColor: Colors.brown.shade200,
            ),
          ],
        ),
      ),
    );
  }
}

extension on VirtualKeyboardStyle {
  VirtualKeyboardStyle copyWith({
    Color? backgroundColor,
    BoxDecoration? backgroundDecoration,
    Color? keyBackgroundColor,
    BoxDecoration? keyDecoration,
    TextStyle? keyTextStyle,
    Color? keyIconColor,
    double? keyBorderRadius,
    EdgeInsetsGeometry? keyPadding,
    EdgeInsetsGeometry? keyMargin,
    double? keyElevation,
    ShapeBorder? keyBorder,
    Color? pressedColor,
  }) {
    return VirtualKeyboardStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundDecoration: backgroundDecoration ?? this.backgroundDecoration,
      keyBackgroundColor: keyBackgroundColor ?? this.keyBackgroundColor,
      keyDecoration: keyDecoration ?? this.keyDecoration,
      keyTextStyle: keyTextStyle ?? this.keyTextStyle,
      keyIconColor: keyIconColor ?? this.keyIconColor,
      keyBorderRadius: keyBorderRadius ?? this.keyBorderRadius,
      keyPadding: keyPadding ?? this.keyPadding,
      keyMargin: keyMargin ?? this.keyMargin,
      keyElevation: keyElevation ?? this.keyElevation,
      keyBorder: keyBorder ?? this.keyBorder,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }
}
