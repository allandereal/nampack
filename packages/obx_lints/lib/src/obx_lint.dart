// ignore_for_file: deprecated_member_use

part of '../obx_lints.dart';

class _ObxLintRule extends DartLintRule {
  const _ObxLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_rx_value_getter_outside_obx',
    problemMessage: 'Do not access `value` outside `Obx()`, use `valueRaw` instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  List<Fix> getFixes() => [_ObxLintFix()];

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addPrefixedIdentifier((node) {
      final getterName = node.identifier.name;
      if (getterName == 'value' && node.identifier.inGetterContext()) {
        final parentType = node.prefix.staticType;
        final element = parentType?.element;
        final hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(element);
        if (!hasRxUpdater) return;
        final withinObx = _isWithinWidget(node, 'Obx');
        if (withinObx) return;
        reporter.reportErrorForNode(_code, node);
      }
    });
  }

  bool _isWithinWidget(AstNode node, String widgetName) {
    bool alreadyHadFunction = false;
    var parent = node.parent;
    while (parent != null) {
      if (parent is FunctionExpression) {
        if (alreadyHadFunction) {
          break;
        } else {
          alreadyHadFunction = true;
        }
      } else if (parent is InstanceCreationExpression) {
        final parentName = parent.beginToken.lexeme;
        if (parentName == widgetName) return true;
      }
      parent = parent.parent;
    }
    return false;
  }
}

class _ObxLintFix extends DartFix {
  _ObxLintFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      final element = node.staticElement;
      if (element == null || !analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(message: 'Replace with `valueRaw`', priority: 12);
      final changeBuilderAll = reporter.createChangeBuilder(message: 'Replace with `valueRaw` everywhere in this file`', priority: 11);

      final nameLength = element.name?.length ?? 0;
      final newSourceRange = SourceRange(node.sourceRange.end - nameLength, nameLength);
      const newReplacement = "valueRaw";

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(newSourceRange, newReplacement);
      });
      changeBuilderAll.addDartFileEdit((builder) {
        builder.addSimpleReplacement(newSourceRange, newReplacement);
        for (final other in others) {
          builder.addSimpleReplacement(SourceRange(other.sourceRange.end - nameLength, nameLength), newReplacement);
        }
      });
    });
  }
}
