import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class RainbowItem extends StatelessWidget {
  final Color color;
  final double width;

  const RainbowItem({
    super.key,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: color.toString(),
      child: Container(width: width, color: color),
    );
  }
}

// Maps to store source and target JSON data
Map<String, dynamic> sourceJson = {};
Map<String, dynamic> targetJson = {};

// Map to store mappings between source and target keys
Map<String, String> mappings = {};

class ComplexRainbowComponent extends StatefulWidget {
  final ComponentData componentData;
  const ComplexRainbowComponent({
    super.key,
    required this.componentData,
  });

  @override
  State<ComplexRainbowComponent> createState() =>
      _ComplexRainbowComponentState();
}

class _ComplexRainbowComponentState extends State<ComplexRainbowComponent> {
  late ComponentData componentData;

  @override
  void initState() {
    super.initState();
    // Initialize localMappings with the mappings passed to the widget
    componentData = widget.componentData;
  }

  List<Widget> _buildJsonTree(Map<String, dynamic> json,
      [String parentKey = '']) {
    return json.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;
      final fullKey = parentKey.isEmpty ? key : '$parentKey.$key';

      if (value is Map<String, dynamic>) {
        // Nested JSON object
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(key),
          children: _buildJsonTree(value, fullKey),
        );
      } else {
        // Leaf JSON field (for dropping targets)
        return Builder(
          builder: (BuildContext context) {
            return DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return ListTile(
                  title: Text('$fullKey: [${value.toString()}]'),
                  subtitle: candidateData.isNotEmpty
                      ? Text("Drop to map with ${candidateData.first}")
                      : const Text("Drag source field here"),
                );
              },
              onAcceptWithDetails: (sourceKey) {
                // // Handle mapping logic here
                // onMappingCreated(sourceKey.data, fullKey);
                // //mappings.add(Mapping(source: sourceKey.data, dest: fullKey));
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Mapped $sourceKey to $fullKey')),
                // );
              },
            );
          },
        );
      }
    }).toList();
  }

  Future<void> loadJsonFromFile(bool isSource) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      Map<String, dynamic> jsonData = json.decode(content);
      //debugPrint(convertJsonToNestedMap(jsonData).toString());
      //final jsonString = jsonEncode(jsonData);
      //debugPrint(jsonString);
      debugPrint(jsonData.keys.length.toString());
      debugPrint(mappings.length.toString());

      setState(() {
        mappings.clear();
        if (isSource) {
          sourceJson = jsonData;
        } else {
          targetJson = jsonData;
        }
      });

      //mappingPanelKey.currentState?.clearMappings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: componentData.data.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 4,
            color: componentData.data.isHighlightVisible
                ? Colors.pink
                : Colors.black,
          ),
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => loadJsonFromFile(false),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Adjusts the roundness
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                backgroundColor: Colors.black, // Background color
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(width: 2.0),
                  Text("Open Target File",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Text('Target JSON Structure',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: _buildJsonTree(targetJson),
              ),
            ),
          ],
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     const SizedBox(height: 8),
        //     const Center(
        //       child: Text(
        //         'title text',
        //         style: TextStyle(fontSize: 32),
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     ),
        //     const Divider(
        //       color: Colors.grey,
        //       thickness: 1,
        //       height: 8,
        //       indent: 24,
        //       endIndent: 24,
        //     ),
        //     const Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Icon(Icons.emoji_emotions, color: Colors.grey, size: 64),
        //         Icon(Icons.gesture, color: Colors.amber, size: 64),
        //         SizedBox(width: 8),
        //         Text(
        //           'some text',
        //           style: TextStyle(fontSize: 16),
        //           maxLines: 2,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ],
        //     ),
        //     const SizedBox(height: 16),
        //     const Text(
        //       'This is a bit more complex component... try to scroll the rainbow below.',
        //       style: TextStyle(fontSize: 11),
        //     ),
        //     Center(
        //       child: Padding(
        //         padding: const EdgeInsets.all(24),
        //         child: SizedBox(
        //           height: 80,
        //           child: ListView(
        //             scrollDirection: Axis.horizontal,
        //             children: const <Widget>[
        //               RainbowItem(width: 80, color: Colors.red),
        //               RainbowItem(width: 80, color: Colors.orange),
        //               RainbowItem(width: 80, color: Colors.amber),
        //               RainbowItem(width: 80, color: Colors.yellow),
        //               RainbowItem(width: 80, color: Colors.lime),
        //               RainbowItem(width: 80, color: Colors.green),
        //               RainbowItem(width: 80, color: Colors.cyan),
        //               RainbowItem(width: 80, color: Colors.blue),
        //               RainbowItem(width: 80, color: Colors.indigo),
        //               RainbowItem(width: 80, color: Colors.purple),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
