// ignore_for_file: deprecated_member_use, unused_element

library obx_lints;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:obx_lints/core/enum.dart';

part 'src/obx_lint.dart';
part 'src/rx_bool_lint.dart';

PluginBase createPlugin() => _RxCustomLinter();

class _RxCustomLinter extends PluginBase {
  static bool hasRxUpdaterMixin(Element? parentElement) {
    return hasSuperType(parentElement, 'RxUpdatersMixin');
  }

  static bool hasRxOUpdaterMixin(Element? parentElement) {
    return hasSuperType(parentElement, 'RxOUpdatersMixin');
  }

  static bool isRxBase(Element? parentElement) {
    return hasSuperType(parentElement, 'RxBase');
  }

  static bool _checkGoodType(InterfaceType type, String name) {
    return type.getDisplayString(withNullability: false).startsWith(name);
  }

  static bool hasSuperType(Element? parentElement, String mixinName) {
    InterfaceType? supertype;
    List<InterfaceType>? supertypes;
    if (parentElement is ClassElement) {
      if (_checkGoodType(parentElement.thisType, mixinName)) return true;
      supertypes = parentElement.allSupertypes;
      supertype = parentElement.supertype;
    } else if (parentElement is InterfaceElement) {
      supertypes = parentElement.allSupertypes;
      supertype = parentElement.supertype;
    } else if (parentElement is LocalVariableElement) {
      if (parentElement.type is InterfaceType) {
        final e = parentElement.type as InterfaceType;
        supertype = e;
        supertypes = e.allSupertypes;
      }
    }
    if (supertype != null && _checkGoodType(supertype, mixinName)) return true;
    if (supertypes != null) {
      final length = supertypes.length;
      for (int i = 0; i < length; i++) {
        final supertype = supertypes[i];
        if (_checkGoodType(supertype, mixinName)) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      const _ObxNoGetterLintRule(),
      const _ObxLintRule(),
      const _RxBoolLintRule(),
    ];
  }
}
