import 'package:diagram_editor/diagram_editor.dart';
import 'package:json_mapper_arrows/grid_example/policy/policy_set.dart';
import 'package:json_mapper_arrows/grid_example/widget/snap_switch.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GridDiagramEditor());

class GridDiagramEditor extends StatefulWidget {
  const GridDiagramEditor({super.key});

  @override
  GridDiagramEditorState createState() => GridDiagramEditorState();
}

class GridDiagramEditorState extends State<GridDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DiagramEditor(
                  diagramEditorContext: DiagramEditorContext(
                    policySet: myPolicySet,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => myPolicySet.deleteAllComponents(),
                child: Container(
                  width: 80,
                  height: 32,
                  color: Colors.red,
                  child: const Center(child: Text('delete all')),
                ),
              ),
              SpanSwitch(policySet: myPolicySet),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('BACK TO MENU'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
