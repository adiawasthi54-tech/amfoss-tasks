import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

// ---------- Paper sizes (in centimeters: width x height) ----------
const Map<String, Size> paperSizes = {
  'A4 (21 x 29.7 cm)': Size(21, 29.7),
  'A3 (29.7 x 42 cm)': Size(29.7, 42),
  'A5 (14.8 x 21 cm)': Size(14.8, 21),
  'US Letter (21.6 x 27.9 cm)': Size(21.6, 27.9),
  'Square (20 x 20 cm)': Size(20, 20),
};

// Preset line colors the artist can tap to choose from
const List<Color> presetColors = [
  Colors.yellow,
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.black,
  Colors.white,
  Colors.orange,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes;

  // Grid mode: true = calculate grid from paper size, false = manual rows/columns
  bool _usePaperSize = false;

  // Manual mode settings
  int _rows = 4;
  int _columns = 4;

  // Paper mode settings
  String _selectedPaper = 'A4 (21 x 29.7 cm)';
  double _squareSizeCm = 2.5; // size of each grid square, in cm

  // Shared grid styling
  double _thickness = 2;
  Color _lineColor = Colors.yellow;
  double _opacity = 0.8;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // Works out how many rows/columns to draw based on the current mode
  ({int rows, int columns, double aspectRatio}) _calculateGrid() {
    if (_usePaperSize) {
      final paper = paperSizes[_selectedPaper]!;
      int cols = (paper.width / _squareSizeCm).round().clamp(1, 60);
      int rws = (paper.height / _squareSizeCm).round().clamp(1, 60);
      return (
        rows: rws,
        columns: cols,
        aspectRatio: paper.width / paper.height,
      );
    } else {
      return (rows: _rows, columns: _columns, aspectRatio: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = _calculateGrid();

    return Scaffold(
      appBar: AppBar(title: const Text('Artist Grid Tool')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Image + grid preview ----------
            AspectRatio(
              aspectRatio: grid.aspectRatio,
              child: Container(
                color: Colors.grey[300],
                child: _imageBytes == null
                    ? const Center(child: Text('No image yet'))
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(_imageBytes!, fit: BoxFit.cover),
                          CustomPaint(
                            painter: GridPainter(
                              rows: grid.rows,
                              columns: grid.columns,
                              color: _lineColor,
                              strokeWidth: _thickness,
                              opacity: _opacity,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Import Reference Image'),
            ),

            const Divider(height: 32),

            // ---------- Mode switch ----------
            const Text(
              'Grid Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Manual Rows/Columns')),
                ButtonSegment(value: true, label: Text('By Paper Size')),
              ],
              selected: {_usePaperSize},
              onSelectionChanged: (selection) {
                setState(() {
                  _usePaperSize = selection.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // ---------- Manual mode controls ----------
            if (!_usePaperSize) ...[
              Text('Columns: $_columns'),
              Slider(
                value: _columns.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: '$_columns',
                onChanged: (value) => setState(() => _columns = value.round()),
              ),
              Text('Rows: $_rows'),
              Slider(
                value: _rows.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: '$_rows',
                onChanged: (value) => setState(() => _rows = value.round()),
              ),
            ],

            // ---------- Paper mode controls ----------
            if (_usePaperSize) ...[
              const Text('Paper Size'),
              DropdownButton<String>(
                value: _selectedPaper,
                isExpanded: true,
                items: paperSizes.keys
                    .map(
                      (name) =>
                          DropdownMenuItem(value: name, child: Text(name)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedPaper = value);
                },
              ),
              const SizedBox(height: 12),
              Text('Grid Square Size: ${_squareSizeCm.toStringAsFixed(1)} cm'),
              Slider(
                value: _squareSizeCm,
                min: 0.5,
                max: 10,
                divisions: 19,
                label: '${_squareSizeCm.toStringAsFixed(1)} cm',
                onChanged: (value) => setState(() => _squareSizeCm = value),
              ),
              Text(
                'Resulting grid: ${grid.columns} columns x ${grid.rows} rows',
              ),
            ],

            const Divider(height: 32),

            // ---------- Line thickness ----------
            Text('Line Thickness: ${_thickness.toStringAsFixed(1)}'),
            Slider(
              value: _thickness,
              min: 0.5,
              max: 8,
              divisions: 15,
              label: _thickness.toStringAsFixed(1),
              onChanged: (value) => setState(() => _thickness = value),
            ),

            // ---------- Line opacity ----------
            Text('Line Opacity: ${(_opacity * 100).round()}%'),
            Slider(
              value: _opacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: '${(_opacity * 100).round()}%',
              onChanged: (value) => setState(() => _opacity = value),
            ),

            // ---------- Line color ----------
            const Text('Line Color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: presetColors.map((color) {
                final bool isSelected = color == _lineColor;
                return GestureDetector(
                  onTap: () => setState(() => _lineColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------- Draws the grid lines ----------
class GridPainter extends CustomPainter {
  final int rows;
  final int columns;
  final Color color;
  final double strokeWidth;
  final double opacity;

  GridPainter({
    required this.rows,
    required this.columns,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = strokeWidth;

    for (int i = 1; i < columns; i++) {
      double x = size.width / columns * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 1; i < rows; i++) {
      double y = size.height / rows * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.columns != columns ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.opacity != opacity;
  }
}
