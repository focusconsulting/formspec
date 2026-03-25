/// @filedesc FormspecLayout — recursively renders a LayoutNode tree using the ComponentMap.

import SwiftUI

// MARK: - FormspecLayout

/// Recursively renders a `LayoutNode` tree.
///
/// - For `.field` nodes: delegates to `FormspecField`, which looks up and instantiates
///   the correct `FieldComponent`.
/// - For `.layout` nodes: recursively builds children, then looks up and instantiates
///   the correct `LayoutComponent`.
/// - For all other categories (`.display`, `.interactive`, `.special`): recursively
///   renders children in a vertical stack.
struct FormspecLayout: View {
    let node: LayoutNode
    let engine: FormspecEngine
    let components: ComponentMap

    var body: some View {
        resolvedView
    }

    private var resolvedView: AnyView {
        switch node.category {
        case .field:
            return AnyView(FormspecField(node: node, engine: engine, components: components))

        case .layout:
            return layoutView

        default:
            // display / interactive / special — just render children
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(node.children, id: \.id) { child in
                        FormspecLayout(node: child, engine: engine, components: components)
                    }
                }
            )
        }
    }

    // MARK: - Private: layout instantiation

    private var layoutView: AnyView {
        // Build rendered children first
        let renderedChildren: [AnyView] = node.children.map { child in
            AnyView(FormspecLayout(node: child, engine: engine, components: components))
        }

        // Look up layout component type; fall back to DefaultStack
        let componentType = components.layout[node.component] ?? DefaultStack.self
        return AnyView(componentType.init(node: node, children: renderedChildren))
    }
}
