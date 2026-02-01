import 'package:flutter/material.dart';

class ListEditor extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  const ListEditor({
    super.key,
    required this.hintText,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends State<ListEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onAdd(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _handleAdd(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _handleAdd,
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < widget.items.length; i += 1)
              Chip(
                label: Text(widget.items[i]),
                onDeleted: () => widget.onRemove(i),
              ),
          ],
        ),
      ],
    );
  }
}
