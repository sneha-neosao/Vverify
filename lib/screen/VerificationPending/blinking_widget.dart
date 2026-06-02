import 'package:flutter/material.dart';

class BlinkingStatus extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;

  const BlinkingStatus({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  _BlinkingStatusState createState() => _BlinkingStatusState();
}

class _BlinkingStatusState extends State<BlinkingStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1.0, end: 0.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Row(
        children: [
          Icon(widget.icon, color: widget.color, size: 14),
          const SizedBox(width: 4),
          Text(
            widget.text,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.color,
                ),
          ),
        ],
      ),
    );
  }
}
