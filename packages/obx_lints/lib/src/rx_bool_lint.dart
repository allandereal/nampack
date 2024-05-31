// ignore_for_file: deprecated_member_use

part of '../obx_lints.dart';

class _RxBoolLintRule extends DartLintRule {
  const _RxBoolLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_rx_toggle',
    problemMessage: 'use `toggle()` instead',
    errorSeverity: ErrorSeverity.INFO,
  );

  @override
  List<Fix> getFixes() => [_RxBoolLintFix()];

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addAssignmentExpression((node) {
      if (node.operator.type == TokenType.EQ) {
        final toggleablePart = _toggleAbleLeftSide(node.leftHandSide, node.rightHandSide);
        if (toggleablePart != null) {
          reporter.reportErrorForNode(_code, node, [], [], toggleablePart);
        }
      }
    });
  }

  String? _toggleAbleLeftSide(Expression leftPart, Expression rightHandSide) {
    if (leftPart is PrefixedIdentifier && rightHandSide is PrefixExpression && rightHandSide.operator.type == TokenType.BANG) {
      final hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(leftPart.prefix.staticElement);
      if (!hasRxUpdater) return null;
      final rightPart = rightHandSide.operand;
      if (rightPart is PrefixedIdentifier) {
        if (leftPart.name == rightPart.name || (leftPart.identifier.name == 'value' && rightPart.identifier.name == 'valueR')) {
          return leftPart.prefix.name;
        }
      }
    }
    return null;
  }
}

class _RxBoolLintFix extends DartFix {
  _RxBoolLintFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addAssignmentExpression((node) {
      if (analysisError.sourceRange.intersects(node.sourceRange)) {
        final changeBuilder = reporter.createChangeBuilder(message: 'Replace with `toggle()`', priority: ObxLintPriority.prefer_rx_toggle.value);

        final name = node.beginToken;
        final newSourceRange = node.sourceRange;
        const newReplacement = ".toggle()";

        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(newSourceRange, "$name$newReplacement");
        });

        if (others.isNotEmpty) {
          final changeBuilderAll = reporter.createChangeBuilder(message: 'Replace with `toggle() everywhere in this file`', priority: ObxLintPriority.prefer_rx_toggle_all.value);
          changeBuilderAll.addDartFileEdit((builder) {
            builder.addSimpleReplacement(newSourceRange, "$name$newReplacement");
            final length = others.length;
            for (int i = 0; i < length; i++) {
              final other = others[i];
              final otherName = other.data as String;
              builder.addSimpleReplacement(other.sourceRange, "$otherName$newReplacement");
            }
          });
        }
      }
    });
  }
}
