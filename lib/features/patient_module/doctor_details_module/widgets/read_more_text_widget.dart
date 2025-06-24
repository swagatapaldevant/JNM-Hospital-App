import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final TextStyle? linkStyle;

  const ReadMoreText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
    this.linkStyle,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = true;
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = widget.style ??
        const TextStyle(fontSize: 12, color: Color(0xFF6B7280)); 
    final readMoreStyle = widget.linkStyle ??
        const TextStyle(color: Colors.teal, fontWeight: FontWeight.w500, fontSize: 12);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: defaultTextStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        _isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: defaultTextStyle,
              maxLines: _readMore && _isOverflowing ? widget.trimLines : null,
              overflow:
              _readMore && _isOverflowing ? TextOverflow.ellipsis : null,
            ),
            if (_isOverflowing)
              GestureDetector(
                onTap: () {
                  setState(() => _readMore = !_readMore);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _readMore ? 'Read more' : 'Read less',
                    style: readMoreStyle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
