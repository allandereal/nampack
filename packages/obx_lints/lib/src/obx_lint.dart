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
    context.registry.addPropertyAccess((node) {
      _ObxUtilsMain.onPropertyAdd(
        node,
        reporter,
        code,
        getterNameRequired: 'valueR',
        catchGetter: true,
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObxOrGetter: (hasObxParentOrIsGetter) => !hasObxParentOrIsGetter,
      );
    });

    context.registry.addPrefixedIdentifier((node) {
      _ObxUtilsMain.onPrefixedAdd(
        node,
        reporter,
        code,
        getterNameRequired: 'valueR',
        catchGetter: true,
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObxOrGetter: (hasObxParentOrIsGetter) => !hasObxParentOrIsGetter,
      );
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
      _ObxUtils._fixObxLint(
        node: node,
        name: node.staticElement?.name,
        replaceWith: 'value',
        reporter: reporter,
        analysisError: analysisError,
        others: others,
        priority: ObxLintPriority.avoid_value_r_getter,
        priorityAll: ObxLintPriority.avoid_value_r_getter_all,
      );
    });
    context.registry.addPropertyAccess((node) {
      _ObxUtils._fixObxLint(
        node: node,
        name: node.propertyName.name,
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
    context.registry.addPropertyAccess((node) {
      _ObxUtilsMain.onPropertyAdd(
        node,
        reporter,
        code,
        getterNameRequired: 'value',
        catchGetter: false,
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObxOrGetter: (hasObxParentOrIsGetter) => hasObxParentOrIsGetter,
      );
    });

    context.registry.addPrefixedIdentifier(
      (node) {
        _ObxUtilsMain.onPrefixedAdd(
          node,
          reporter,
          code,
          getterNameRequired: 'value',
          catchGetter: false,
          goodRx: (hasRxMixin) => hasRxMixin,
          goodObxOrGetter: (hasObxParentOrIsGetter) => hasObxParentOrIsGetter,
        );
      },
    );
  }
}

Element? _propertyToPrefixed(Expression target) {
  try {
    if (target is PropertyAccess) {
      final unp = target.unParenthesized;
      if (unp is PrefixedIdentifier) {
        return unp.staticElement;
      } else if (unp is PropertyAccess) {
        return unp.staticType?.element;
      }
    } else if (target is PrefixedIdentifier) {
      return target.staticElement;
    }
  } catch (_) {}

  return null;
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
      _ObxUtils._fixObxLint(
        node: node,
        name: node.staticElement?.name,
        replaceWith: 'valueR',
        reporter: reporter,
        analysisError: analysisError,
        others: others,
        priority: ObxLintPriority.non_reactive_value_inside_obx,
        priorityAll: ObxLintPriority.non_reactive_value_inside_obx_all,
      );
    });
    context.registry.addPropertyAccess((node) {
      _ObxUtils._fixObxLint(
        node: node,
        name: node.propertyName.name,
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

class _ObxUtilsMain {
  static void onPropertyAdd(
    PropertyAccess node,
    ErrorReporter reporter,
    LintCode code, {
    required String getterNameRequired,
    required bool catchGetter,
    required bool Function(bool hasRxMixin) goodRx,
    required bool Function(bool hasObxParentOrIsGetter) goodObxOrGetter,
  }) {
    bool report = false;
    final realTarget = node.realTarget;

    if (realTarget is PropertyAccess) {
      report = _ObxUtils._canReportProperty(
        node: realTarget,
        getterNameRequired: getterNameRequired,
        catchGetter: catchGetter,
        goodRx: (hasRxMixin) => hasRxMixin,
        goodObxOrGetter: (hasObxParentOrIsGetter) => !hasObxParentOrIsGetter,
      );
    }
    if (report == false) {
      Element? rxElement = _propertyToPrefixed(realTarget);
      if (rxElement is PropertyAccessorElement) {
        rxElement = rxElement.returnType.element;
      }
      if (rxElement != null) {
        report = _ObxUtils._canReport(
          node: node,
          inGetterContext: true, // TODO
          element: rxElement,
          nodeGetter: node.propertyName.name,
          getterNameRequired: getterNameRequired,
          catchGetter: catchGetter,
          goodRx: goodRx,
          goodObxOrGetter: goodObxOrGetter,
        );
      }
    }

    if (report) reporter.reportErrorForNode(code, node.propertyName);
  }

  static void onPrefixedAdd(
    PrefixedIdentifier node,
    ErrorReporter reporter,
    LintCode code, {
    required String getterNameRequired,
    required bool catchGetter,
    required bool Function(bool hasRxMixin) goodRx,
    required bool Function(bool hasObxParentOrIsGetter) goodObxOrGetter,
  }) {
    final report = _ObxUtils._canReportPrefixed(
      node: node,
      nodeGetter: node.identifier.name,
      getterNameRequired: getterNameRequired,
      catchGetter: catchGetter,
      goodRx: goodRx,
      goodObxOrGetter: goodObxOrGetter,
    );
    if (report) reporter.reportErrorForNode(code, node.identifier);
  }
}

class _ObxUtils {
  static bool _canReportPrefixed({
    required PrefixedIdentifier node,
    required String nodeGetter,
    required String getterNameRequired,
    required bool catchGetter,
    required bool Function(bool hasRxMixin) goodRx,
    required bool Function(bool hasObxParentOrIsGetter) goodObxOrGetter,
  }) {
    if (nodeGetter == getterNameRequired && node.identifier.inGetterContext()) {
      bool hasRxUpdater;
      hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(node.staticType?.element);
      if (!hasRxUpdater) hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(node.prefix.staticType?.element);
      if (!goodRx(hasRxUpdater)) return false;
      final withinObxOrGetter = _isWithinWidgetOrGetter(node, 'Obx', catchGetter: catchGetter);
      if (!goodObxOrGetter(withinObxOrGetter)) return false;
      return true;
    }
    return false;
  }

  static bool _canReport({
    required AstNode node,
    required bool inGetterContext,
    required Element element,
    required String nodeGetter,
    required String getterNameRequired,
    required bool catchGetter,
    required bool Function(bool hasRxMixin) goodRx,
    required bool Function(bool hasObxParentOrIsGetter) goodObxOrGetter,
  }) {
    if (nodeGetter == getterNameRequired && inGetterContext) {
      final hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(element);
      if (!goodRx(hasRxUpdater)) return false;
      final withinObxOrGetter = _isWithinWidgetOrGetter(node, 'Obx', catchGetter: catchGetter);
      if (!goodObxOrGetter(withinObxOrGetter)) return false;
      return true;
    }
    return false;
  }

  static bool _canReportProperty({
    required PropertyAccess node,
    required String getterNameRequired,
    required bool catchGetter,
    required bool Function(bool hasRxMixin) goodRx,
    required bool Function(bool hasObxParentOrIsGetter) goodObxOrGetter,
  }) {
    InterfaceType? parentType;
    PrefixedIdentifier? identifier;
    String? getter;

    final rxMember = node.realTarget;

    if (rxMember is! PrefixedIdentifier) return false;

    try {
      final unParenthesized = rxMember.unParenthesized;
      parentType = unParenthesized.staticType as InterfaceType;
      identifier = unParenthesized.parent as PrefixedIdentifier;
      getter = node.propertyName.token.lexeme;
    } catch (_) {}

    if (identifier == null) return false;

    if (getter == getterNameRequired && identifier.identifier.inGetterContext()) {
      final element = parentType?.element;
      final hasRxUpdater = _RxCustomLinter.hasRxUpdaterMixin(element);
      if (!goodRx(hasRxUpdater)) return false;
      final withinObxOrGetter = _isWithinWidgetOrGetter(node, 'Obx', catchGetter: catchGetter);
      if (!goodObxOrGetter(withinObxOrGetter)) return false;
      return true;
    }
    return false;
  }

  static bool _isWithinWidgetOrGetter(AstNode node, String widgetName, {bool catchGetter = true}) {
    bool alreadyHadFunction = false;
    var parent = node.parent;
    while (parent != null) {
      if (catchGetter && parent.checkGetter()) return false;

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

  static void _fixObxLint({
    required Expression node,
    required String? name,
    required String replaceWith,
    required ChangeReporter reporter,
    required AnalysisError analysisError,
    required List<AnalysisError> others,
    required ObxLintPriority priority,
    required ObxLintPriority priorityAll,
  }) {
    if (name == null || !analysisError.sourceRange.intersects(node.sourceRange)) return;

    final changeBuilder = reporter.createChangeBuilder(message: 'Replace with `$replaceWith`', priority: priority.value);

    final nameLength = name.length;
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
}

extension _GetterDetector on AstNode {
  bool checkGetter() {
    final node = this;
    if (node is MethodDeclaration && node.isGetter) return true;
    if (node is FunctionDeclaration && node.isGetter) return true;
    return false;
  }
}
