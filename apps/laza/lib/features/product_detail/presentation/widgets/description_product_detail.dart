import 'package:flutter/material.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';

class DescriptionProductDetail extends StatefulWidget {
  final String text;
  final int? maxLines;
  final TextStyle? style;
  final Color? readMoreColor;
  final Color? readLessColor;
  final bool? trimCollapsedText;
  final bool? expandEnabled;
  final bool? showTrimmedLines;
  final bool? collapsed;
  final Function? onReadMorePressed;
  final Function? onReadLessPressed;
  final String? readMoreText;
  final String? readLessText;

  const DescriptionProductDetail({
    super.key,
    required this.text,
    this.maxLines,
    this.style,
    this.readMoreColor,
    this.readLessColor,
    this.trimCollapsedText,
    this.expandEnabled,
    this.showTrimmedLines,
    this.collapsed = false,
    this.onReadMorePressed,
    this.onReadLessPressed,
    this.readMoreText = 'Read More...',
    this.readLessText = 'Read Less',
  });

  @override
  DescriptionProductDetailState createState() =>
      DescriptionProductDetailState();
}

class DescriptionProductDetailState extends State<DescriptionProductDetail> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.collapsed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.current.description,
            style: context.textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            _expanded
                ? widget.text
                : widget.trimCollapsedText == true
                    ? _getTrimmedText(widget.text, widget.maxLines ?? 2)
                    : widget.text,
            maxLines: _expanded ? null : widget.maxLines,
            style: widget.style,
            overflow: TextOverflow.ellipsis,
          ),
          widget.expandEnabled == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                    if (_expanded) {
                      widget.onReadMorePressed?.call();
                    } else {
                      widget.onReadLessPressed?.call();
                    }
                  },
                  child: _expanded
                      ? Text(
                          widget.readMoreText!,
                          style: widget.style?.copyWith(
                            color: widget.readMoreColor,
                          ),
                        )
                      : Text(
                          widget.readLessText!,
                          style: widget.style?.copyWith(
                            color: widget.readLessColor,
                          ),
                        ))
              : const SizedBox.shrink(),
          widget.showTrimmedLines == true && !_expanded
              ? Text(
                  _getTrimmedText(
                    widget.text,
                    widget.maxLines ?? 2,
                  ),
                  style: widget.style,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  String _getTrimmedText(String text, int maxLines) {
    final lines = text.split('\n');
    if (lines.length <= maxLines) return text;
    return lines.sublist(0, maxLines).join('\n');
  }
}
