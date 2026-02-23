import 'dart:async';

import 'package:flutter/material.dart';

/// Modes for the interactive future keyboard.
enum FutureKeyboardMode { letters, numbers, symbols }

/// Theme model for [FutureKeyboard].
class FutureKeyboardThemeData {
  const FutureKeyboardThemeData({
    required this.name,
    required this.backgroundGradient,
    required this.keyColor,
    required this.keyTextColor,
    required this.toolbarColor,
    required this.accentColor,
  });

  final String name;
  final Gradient backgroundGradient;
  final Color keyColor;
  final Color keyTextColor;
  final Color toolbarColor;
  final Color accentColor;

  static const List<FutureKeyboardThemeData> presets = [
    FutureKeyboardThemeData(
      name: 'Midnight',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      keyColor: Color(0xFF122A35),
      keyTextColor: Colors.white,
      toolbarColor: Color(0xFF0C1B22),
      accentColor: Color(0xFF40C4FF),
    ),
    FutureKeyboardThemeData(
      name: 'Sunset',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF2B1A28), Color(0xFF5D2747), Color(0xFFB84A62)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      keyColor: Color(0xFF4A203A),
      keyTextColor: Color(0xFFFFF3E0),
      toolbarColor: Color(0xFF2A1021),
      accentColor: Color(0xFFFFB300),
    ),
    FutureKeyboardThemeData(
      name: 'Mint Grid',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF041A16), Color(0xFF0B2F27), Color(0xFF176356)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      keyColor: Color(0xFF0B352E),
      keyTextColor: Color(0xFFE8FFF8),
      toolbarColor: Color(0xFF07221D),
      accentColor: Color(0xFF00E5A8),
    ),
  ];
}

/// A highly interactive and customizable keyboard with built-in themes,
/// suggestions, snippets and dynamic key sizing.
class FutureKeyboard extends StatefulWidget {
  const FutureKeyboard({
    super.key,
    required this.controller,
    this.onTextChanged,
    this.onSubmitted,
    this.themes = FutureKeyboardThemeData.presets,
    this.quickSnippets = const ['@gmail.com', '.com', 'https://'],
    this.maxSuggestions = 4,
    this.showToolbar = true,
    this.showPredictions = true,
    this.minKeyHeight = 44,
    this.maxKeyHeight = 70,
    this.initialKeyHeight = 52,
    this.enableAutoCapitalize = true,
    this.suggestionDictionary,
  }) : assert(themes.length > 0, 'themes must not be empty');

  final TextEditingController controller;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? onSubmitted;

  /// Available visual themes for the keyboard.
  final List<FutureKeyboardThemeData> themes;

  /// Quick insertion snippets shown in the toolbar.
  final List<String> quickSnippets;

  /// Max number of suggestions to show.
  final int maxSuggestions;

  final bool showToolbar;
  final bool showPredictions;
  final double minKeyHeight;
  final double maxKeyHeight;
  final double initialKeyHeight;
  final bool enableAutoCapitalize;

  /// Optional custom dictionary used for word prediction.
  final List<String>? suggestionDictionary;

  @override
  State<FutureKeyboard> createState() => _FutureKeyboardState();
}

class _FutureKeyboardState extends State<FutureKeyboard> {
  static const List<String> _defaultDictionary = [
    'hello',
    'hey',
    'future',
    'flutter',
    'keyboard',
    'interactive',
    'customize',
    'customizable',
    'design',
    'project',
    'feature',
    'performance',
    'awesome',
    'today',
    'tomorrow',
    'thank',
    'thanks',
    'please',
    'update',
    'release',
    'build',
    'testing',
    'ready',
    'done',
  ];

  final Set<String> _typedWords = <String>{};
  FutureKeyboardMode _mode = FutureKeyboardMode.letters;
  int _selectedThemeIndex = 0;
  bool _isUppercase = false;
  late double _keyHeight;

  FutureKeyboardThemeData get _theme => widget.themes[_selectedThemeIndex];

  @override
  void initState() {
    super.initState();
    _keyHeight = widget.initialKeyHeight.clamp(
      widget.minKeyHeight,
      widget.maxKeyHeight,
    );
  }

  List<String> get _suggestions {
    if (!widget.showPredictions) return const [];

    final word = _currentWord;
    if (word.isEmpty) return const [];

    final query = word.toLowerCase();
    final dictionary = widget.suggestionDictionary ?? _defaultDictionary;
    final combined = {..._typedWords, ...dictionary}.toList();

    combined.sort((a, b) {
      final aStarts = a.toLowerCase().startsWith(query);
      final bStarts = b.toLowerCase().startsWith(query);
      if (aStarts != bStarts) {
        return aStarts ? -1 : 1;
      }
      return a.length.compareTo(b.length);
    });

    return combined
        .where(
          (w) => w.toLowerCase().contains(query) && w.length >= query.length,
        )
        .take(widget.maxSuggestions)
        .toList(growable: false);
  }

  String get _currentWord {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final cursor = selection.isValid ? selection.start : text.length;
    if (cursor <= 0 || cursor > text.length) return '';

    final prefix = text.substring(0, cursor);
    final parts = prefix.split(RegExp(r'[^A-Za-z]+'));
    return parts.isEmpty ? '' : parts.last;
  }

  void _insertText(String insertion) {
    final controller = widget.controller;
    final text = controller.text;
    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);

    final updated = text.replaceRange(
      selection.start,
      selection.end,
      insertion,
    );
    final cursor = selection.start + insertion.length;

    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: cursor),
    );

    _collectWords(updated);
    widget.onTextChanged?.call(updated);
  }

  void _replaceCurrentWord(String replacement) {
    final controller = widget.controller;
    final text = controller.text;
    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);

    final cursor = selection.start;
    int start = cursor;
    while (start > 0 && RegExp(r'[A-Za-z]').hasMatch(text[start - 1])) {
      start--;
    }

    final updated = text.replaceRange(start, cursor, replacement);
    final endCursor = start + replacement.length;

    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: endCursor),
    );

    _collectWords(updated);
    widget.onTextChanged?.call(updated);
  }

  void _collectWords(String text) {
    for (final word in text.split(RegExp(r'[^A-Za-z]+'))) {
      if (word.length > 2) {
        _typedWords.add(word.toLowerCase());
      }
    }
  }

  void _deleteBackward() {
    final controller = widget.controller;
    final text = controller.text;
    if (text.isEmpty) return;

    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);

    if (!selection.isCollapsed) {
      final updated = text.replaceRange(selection.start, selection.end, '');
      controller.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: selection.start),
      );
      widget.onTextChanged?.call(updated);
      return;
    }

    if (selection.start == 0) return;

    final updated = text.replaceRange(selection.start - 1, selection.start, '');
    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: selection.start - 1),
    );
    widget.onTextChanged?.call(updated);
  }

  void _submit() {
    widget.onSubmitted?.call(widget.controller.text);
  }

  void _handleKey(_FutureKey key) {
    switch (key.action) {
      case _FutureKeyAction.text:
        String text = key.label ?? '';
        if (_isUppercase && !key.alwaysLowercase) {
          text = text.toUpperCase();
        }
        _insertText(text);
        break;
      case _FutureKeyAction.shift:
        setState(() {
          _isUppercase = !_isUppercase;
        });
        break;
      case _FutureKeyAction.backspace:
        _deleteBackward();
        break;
      case _FutureKeyAction.space:
        _insertText(' ');
        break;
      case _FutureKeyAction.enter:
        _insertText('\n');
        _submit();
        break;
      case _FutureKeyAction.switchMode:
        setState(() {
          _mode = key.mode ?? FutureKeyboardMode.letters;
        });
        break;
      case _FutureKeyAction.snippet:
        _insertText(key.label ?? '');
        break;
    }
    setState(() {});
  }

  List<List<_FutureKey>> get _layout {
    switch (_mode) {
      case FutureKeyboardMode.letters:
        return [
          _keys('qwertyuiop'),
          _keys('asdfghjkl'),
          [_FutureKey.shift(), ..._keys('zxcvbnm'), _FutureKey.backspace()],
          [
            _FutureKey.mode('123', FutureKeyboardMode.numbers, flex: 2),
            _FutureKey.space(flex: 6),
            _FutureKey.enter(flex: 2),
          ],
        ];
      case FutureKeyboardMode.numbers:
        return [
          _keys('1234567890'),
          _keys('-/:;()\$&@"'),
          [
            _FutureKey.mode('#+=', FutureKeyboardMode.symbols, flex: 2),
            ...['.', ',', '?', '!'].map(_FutureKey.text),
            _FutureKey.backspace(flex: 2),
          ],
          [
            _FutureKey.mode('ABC', FutureKeyboardMode.letters, flex: 2),
            _FutureKey.space(flex: 6),
            _FutureKey.enter(flex: 2),
          ],
        ];
      case FutureKeyboardMode.symbols:
        return [
          _keys('[]{}#%^*+='),
          _keys('_\\|~<>€£¥•'),
          [
            _FutureKey.mode('123', FutureKeyboardMode.numbers, flex: 2),
            ...['.', ',', '?', '!'].map(_FutureKey.text),
            _FutureKey.backspace(flex: 2),
          ],
          [
            _FutureKey.mode('ABC', FutureKeyboardMode.letters, flex: 2),
            _FutureKey.space(flex: 6),
            _FutureKey.enter(flex: 2),
          ],
        ];
    }
  }

  List<_FutureKey> _keys(String chars) {
    return chars.split('').map(_FutureKey.text).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(gradient: _theme.backgroundGradient),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showToolbar) _buildToolbar(),
          if (_suggestions.isNotEmpty) _buildSuggestions(),
          ..._layout.map(_buildRow),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      color: _theme.toolbarColor.withAlpha(230),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.quickSnippets
                      .map(
                        (snippet) => _CompactActionChip(
                          label: snippet,
                          onTap: () {
                            _handleKey(_FutureKey.snippet(snippet));
                          },
                          color: _theme.accentColor.withAlpha(35),
                          textColor: _theme.keyTextColor,
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<int>(
                onSelected: (index) {
                  setState(() {
                    _selectedThemeIndex = index;
                  });
                },
                tooltip: 'Theme',
                itemBuilder: (_) {
                  return List.generate(widget.themes.length, (index) {
                    final selected = index == _selectedThemeIndex;
                    return PopupMenuItem<int>(
                      value: index,
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selected
                                ? _theme.accentColor
                                : _theme.keyTextColor.withAlpha(180),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.themes[index].name),
                        ],
                      ),
                    );
                  });
                },
                color: _theme.keyColor,
                icon: Icon(Icons.palette, color: _theme.keyTextColor),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Key size',
                style: TextStyle(
                  color: _theme.keyTextColor.withAlpha(220),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _keyHeight,
                  min: widget.minKeyHeight,
                  max: widget.maxKeyHeight,
                  activeColor: _theme.accentColor,
                  inactiveColor: _theme.keyTextColor.withAlpha(70),
                  onChanged: (value) {
                    setState(() {
                      _keyHeight = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, index) => const SizedBox(width: 6),
        itemBuilder: (_, index) {
          final suggestion = _suggestions[index];
          return _CompactActionChip(
            label: suggestion,
            onTap: () => _replaceCurrentWord(suggestion),
            color: _theme.accentColor.withAlpha(40),
            textColor: _theme.keyTextColor,
          );
        },
      ),
    );
  }

  Widget _buildRow(List<_FutureKey> row) {
    return Row(
      children: row
          .map(
            (key) => _FutureKeyButton(
              keyData: key,
              keyHeight: _keyHeight,
              theme: _theme,
              isUppercase: _isUppercase,
              active: key.action == _FutureKeyAction.shift && _isUppercase,
              onTap: () => _handleKey(key),
              onLongBackspaceTick: key.action == _FutureKeyAction.backspace
                  ? _deleteBackward
                  : null,
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CompactActionChip extends StatelessWidget {
  const _CompactActionChip({
    required this.label,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _FutureKeyButton extends StatefulWidget {
  const _FutureKeyButton({
    required this.keyData,
    required this.keyHeight,
    required this.theme,
    required this.isUppercase,
    required this.active,
    required this.onTap,
    this.onLongBackspaceTick,
  });

  final _FutureKey keyData;
  final double keyHeight;
  final FutureKeyboardThemeData theme;
  final bool isUppercase;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback? onLongBackspaceTick;

  @override
  State<_FutureKeyButton> createState() => _FutureKeyButtonState();
}

class _FutureKeyButtonState extends State<_FutureKeyButton> {
  bool _pressed = false;
  Timer? _repeatTimer;

  void _startBackspaceRepeat() {
    if (widget.onLongBackspaceTick == null) return;
    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      widget.onLongBackspaceTick?.call();
    });
  }

  void _stopBackspaceRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  void dispose() {
    _stopBackspaceRepeat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyColor = widget.active
        ? widget.theme.accentColor.withAlpha(80)
        : widget.theme.keyColor;
    String displayLabel = widget.keyData.label ?? '';
    if (widget.isUppercase &&
        widget.keyData.action == _FutureKeyAction.text &&
        !widget.keyData.alwaysLowercase) {
      displayLabel = displayLabel.toUpperCase();
    }

    return Expanded(
      flex: widget.keyData.flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onLongPressStart: (_) => _startBackspaceRepeat(),
          onLongPressEnd: (_) => _stopBackspaceRepeat(),
          child: AnimatedScale(
            scale: _pressed ? 0.95 : 1,
            duration: const Duration(milliseconds: 80),
            child: Material(
              color: keyColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: widget.theme.accentColor.withAlpha(65),
                onTap: widget.onTap,
                child: Container(
                  height: widget.keyHeight,
                  alignment: Alignment.center,
                  child: widget.keyData.icon != null
                      ? Icon(
                          widget.keyData.icon,
                          color: widget.theme.keyTextColor,
                        )
                      : Text(
                          displayLabel,
                          style: TextStyle(
                            color: widget.theme.keyTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _FutureKeyAction {
  text,
  backspace,
  space,
  enter,
  shift,
  switchMode,
  snippet,
}

class _FutureKey {
  const _FutureKey({
    this.label,
    required this.action,
    this.flex = 1,
    this.icon,
    this.mode,
    this.alwaysLowercase = false,
  });

  final String? label;
  final _FutureKeyAction action;
  final int flex;
  final IconData? icon;
  final FutureKeyboardMode? mode;
  final bool alwaysLowercase;

  factory _FutureKey.text(String text, {int flex = 1}) {
    return _FutureKey(label: text, action: _FutureKeyAction.text, flex: flex);
  }

  factory _FutureKey.space({int flex = 6}) {
    return _FutureKey(
      label: 'space',
      action: _FutureKeyAction.space,
      flex: flex,
    );
  }

  factory _FutureKey.enter({int flex = 2}) {
    return _FutureKey(
      action: _FutureKeyAction.enter,
      icon: Icons.keyboard_return,
      flex: flex,
    );
  }

  factory _FutureKey.backspace({int flex = 2}) {
    return _FutureKey(
      action: _FutureKeyAction.backspace,
      icon: Icons.backspace_outlined,
      flex: flex,
    );
  }

  factory _FutureKey.shift({int flex = 2}) {
    return _FutureKey(
      action: _FutureKeyAction.shift,
      icon: Icons.arrow_upward,
      flex: flex,
    );
  }

  factory _FutureKey.mode(
    String label,
    FutureKeyboardMode mode, {
    int flex = 2,
  }) {
    return _FutureKey(
      label: label,
      action: _FutureKeyAction.switchMode,
      mode: mode,
      flex: flex,
      alwaysLowercase: true,
    );
  }

  factory _FutureKey.snippet(String text, {int flex = 1}) {
    return _FutureKey(
      label: text,
      action: _FutureKeyAction.snippet,
      flex: flex,
    );
  }
}
