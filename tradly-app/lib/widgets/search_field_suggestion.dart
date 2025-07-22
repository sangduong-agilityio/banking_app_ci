import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:async';

class LocationSuggestionField extends StatefulWidget {
  const LocationSuggestionField({
    super.key,
    required this.controller,
    required this.label,
    required this.suggestionsCallback,
    this.onSelected,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.minCharsForSuggestions = 1,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  final TextEditingController controller;
  final String label;
  final Future<List<String>> Function(String) suggestionsCallback;
  final Function(String)? onSelected;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int minCharsForSuggestions;
  final Duration debounceDuration;

  @override
  State<LocationSuggestionField> createState() =>
      _LocationSuggestionFieldState();
}

class _LocationSuggestionFieldState extends State<LocationSuggestionField> {
  late final SuggestionsController<String> _suggestionsController;
  late final FocusNode _focusNode;
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _suggestionsController = SuggestionsController<String>();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();

    if (value.length < widget.minCharsForSuggestions) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted) {
        _suggestionsController.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TypeAheadField<String>(
          controller: widget.controller,
          focusNode: _focusNode,
          suggestionsController: _suggestionsController,
          debounceDuration: Duration.zero,
          builder: (context, controller, focusNode) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: widget.validator,
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : widget.suffixIcon,
              ),
            );
          },
          suggestionsCallback: (pattern) async {
            if (pattern.length < widget.minCharsForSuggestions) {
              setState(() => _isLoading = false);
              return [];
            }

            try {
              final suggestions = await widget.suggestionsCallback(pattern);
              if (mounted) {
                setState(() => _isLoading = false);
              }
              return suggestions;
            } catch (e) {
              if (mounted) {
                setState(() => _isLoading = false);
              }
              return [];
            }
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              dense: true,
              title: Text(
                suggestion,
                style: const TextStyle(fontSize: 14),
              ),
              leading: Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey.shade600,
              ),
            );
          },
          onSelected: (suggestion) {
            widget.controller.text = suggestion;
            widget.onSelected?.call(suggestion);
            _focusNode.unfocus();
          },
          loadingBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading suggestions...'),
                ],
              ),
            );
          },
          emptyBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'No suggestions found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          },
          errorBuilder: (context, error) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading suggestions: ${error.toString()}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            );
          },
          decorationBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }
}
