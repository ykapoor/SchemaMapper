import 'package:diagram_editor/diagram_editor.dart';
import 'package:json_mapper_arrows/ports_example/policy/canvas_policy.dart';
import 'package:json_mapper_arrows/ports_example/policy/component_design_policy.dart';
import 'package:json_mapper_arrows/ports_example/policy/component_policy.dart';
import 'package:json_mapper_arrows/ports_example/policy/custom_policy.dart';
import 'package:json_mapper_arrows/ports_example/policy/init_policy.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        //
        CanvasControlPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy {}
