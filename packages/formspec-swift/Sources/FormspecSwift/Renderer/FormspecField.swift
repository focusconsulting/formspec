/// @filedesc FormspecField — renders a single field node by looking up its component type in the ComponentMap.

import SwiftUI

// MARK: - FormspecField

/// Renders a single form field node.
///
/// Looks up the component type for `node.component` in `components.fields`,
/// creates an instance with the field's reactive `FieldState`, and wraps it in
/// an `AnyView`. Falls back to `DefaultTextInput` if the key is not registered.
///
/// The field is only shown when `state.visible` is `true`. Fields without a
/// `bindPath` or with no corresponding `FieldState` in the engine are omitted.
struct FormspecField: View {
    let node: LayoutNode
    let engine: FormspecEngine
    let components: ComponentMap

    var body: some View {
        guard let bindPath = node.bindPath,
              let state = engine.fieldState(for: bindPath)
        else {
            return AnyView(EmptyView())
        }

        guard state.visible else {
            return AnyView(EmptyView())
        }

        // Look up registered component type; fall back to DefaultTextInput
        let componentType = components.fields[node.component] ?? DefaultTextInput.self
        return AnyView(componentType.init(state: state, node: node))
    }
}
