// ignore_for_file: deprecated_member_use

part of '../obx_lints.dart';

class _ObxLintRule extends DartLintRule {
  const _ObxLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_rx_value_getter_outside_obx',
    problemMessage: 'Do not access `valueR` outside `Obx()`, use `value` instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  List<Fix> getFixes() => [_ObxLintFix()];

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addPrefixedIdentifier((node) {
      final report = _canReport(
        node: node,
        getterName: 'valueR',
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObx: (hasObxParent) => !hasObxParent,
      );
      if (report) reporter.reportErrorForNode(code, node);
    });
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
      _fixObxLint(
        node: node,
        replaceWith: 'value',
        reporter: reporter,
        analysisError: analysisError,
        others: others,
        priority: ObxLintPriority.avoid_value_r_getter,
        priorityAll: ObxLintPriority.avoid_value_r_getter_all,
      );
    });
  }
}

class _ObxNoGetterLintRule extends DartLintRule {
  const _ObxNoGetterLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'non_reactive_value_inside_obx',
    problemMessage: '`value` is accessed inside `Obx()` but `value` is non reactive, use `valueR` instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  List<Fix> getFixes() => [_ObxNoGetterLintFix()];

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addPrefixedIdentifier((node) {
      final report = _canReport(
        node: node,
        getterName: 'value',
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObx: (hasObxParent) => hasObxParent,
      );
      if (report) reporter.reportErrorForNode(code, node);
    });
  }
}

class _ObxNoGetterLintFix extends DartFix {
  _ObxNoGetterLintFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      _fixObxLint(
        node: node,
        replaceWith: 'valueR',
        reporter: reporter,
        analysisError: analysisError,
        others: others,
        priority: ObxLintPriority.non_reactive_value_inside_obx,
        priorityAll: ObxLintPriority.non_reactive_value_inside_obx_all,
      );
    });
  }
}

bool _canReport({
  required PrefixedIdentifier node,
  required String getterName,
  required bool Function(bool hasRxMixin) goodRx,
  required bool Function(bool hasObxParent) goodObx,
}) {
  final getter = node.identifier.name;
  if (getter == getterName && node.identifier.inGetterContext()) {
    final parentType = node.prefix.staticType;
    final element = parentType?.element;
    final hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(element);
    if (!goodRx(hasRxUpdater)) return false;
    final withinObx = _isWithinWidget(node, 'Obx');
    if (!goodObx(withinObx)) return false;
    return true;
  }
  return false;
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

void _fixObxLint({
  required PrefixedIdentifier node,
  required String replaceWith,
  required ChangeReporter reporter,
  required AnalysisError analysisError,
  required List<AnalysisError> others,
  required ObxLintPriority priority,
  required ObxLintPriority priorityAll,
}) {
  final element = node.staticElement;
  if (element == null || !analysisError.sourceRange.intersects(node.sourceRange)) return;

  final changeBuilder = reporter.createChangeBuilder(message: 'Replace with `$replaceWith`', priority: priority.value);

  final nameLength = element.name?.length ?? 0;
  final newSourceRange = SourceRange(node.sourceRange.end - nameLength, nameLength);

  changeBuilder.addDartFileEdit((builder) {
    builder.addSimpleReplacement(newSourceRange, replaceWith);
  });

  if (others.isNotEmpty) {
    final changeBuilderAll = reporter.createChangeBuilder(message: 'Replace with `$replaceWith` everywhere in this file`', priority: priorityAll.value);
    changeBuilderAll.addDartFileEdit((builder) {
      builder.addSimpleReplacement(newSourceRange, replaceWith);
      final length = others.length;
      for (int i = 0; i < length; i++) {
        final other = others[i];
        builder.addSimpleReplacement(SourceRange(other.sourceRange.end - nameLength, nameLength), replaceWith);
      }
    });
  }
}
