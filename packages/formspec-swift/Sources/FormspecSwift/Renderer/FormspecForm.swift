/// @filedesc FormspecForm — top-level SwiftUI view that renders a complete form from a FormspecEngine.

import SwiftUI

// MARK: - FormspecForm

/// The top-level SwiftUI view for rendering a Formspec form.
///
/// Binds a `FormspecEngine` to the SwiftUI rendering layer. Renders the engine's
/// `rootLayoutNode` recursively using the provided `ComponentMap`.
///
/// **Usage:**
/// ```swift
/// let engine = try await FormspecEngine.create(bundle: myBundle)
/// var body: some View {
///     FormspecForm(engine: engine)
/// }
/// ```
///
/// To customise individual components:
/// ```swift
/// let map = ComponentMap.defaults
///     .replacing(field: "TextInput", with: MyTextInput.self)
/// FormspecForm(engine: engine, components: map)
/// ```
public struct FormspecForm: View {

    /// The form engine that holds all reactive state.
    let engine: FormspecEngine

    /// The component registry used to resolve field and layout components.
    var components: ComponentMap

    // MARK: - Init

    /// Create a `FormspecForm` with the given engine and component map.
    ///
    /// - Parameters:
    ///   - engine: A fully-initialized `FormspecEngine`.
    ///   - components: The component registry to use. Defaults to `ComponentMap.defaults`.
    public init(engine: FormspecEngine, components: ComponentMap = .defaults) {
        self.engine = engine
        self.components = components
    }

    // MARK: - Body

    public var body: some View {
        FormspecLayout(
            node: engine.rootLayoutNode,
            engine: engine,
            components: components
        )
    }
}
