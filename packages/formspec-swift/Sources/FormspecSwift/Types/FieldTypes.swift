/// @filedesc Field-level supporting types: ResolvedOption, DisabledDisplay, ValidationMode.

import Foundation

/// A resolved choice option with a typed value and display label.
public struct ResolvedOption: Codable, Equatable, Sendable {
    public let value: JSONValue
    public let label: String

    public init(value: JSONValue, label: String) {
        self.value = value
        self.label = label
    }
}

/// How a disabled field is shown to the user.
public enum DisabledDisplay: String, Codable, Sendable {
    /// Field is not rendered at all.
    case hidden
    /// Field is rendered but its value is obscured.
    case protected
}

/// When the engine emits validation results.
public enum ValidationMode: Sendable {
    /// Validate continuously as the user types.
    case continuous
    /// Validate only on form submission.
    case submit
}
