/// @filedesc Codable JSON value enum covering all JSON primitive and structural types.

import Foundation

/// A type-safe representation of any JSON value.
///
/// Decodes JSON in strict order: null → Bool → Double → String → Array → Object.
/// This ordering ensures `true`/`false` is never misinterpreted as `1.0`/`0.0`.
public enum JSONValue: Codable, Equatable, Hashable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case null
    case array([JSONValue])
    case object([String: JSONValue])

    // MARK: - Decoding

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
            return
        }

        // Bool must come before Double — otherwise JSON `true` decodes as 1.0
        if let b = try? container.decode(Bool.self) {
            self = .bool(b)
            return
        }

        if let n = try? container.decode(Double.self) {
            self = .number(n)
            return
        }

        if let s = try? container.decode(String.self) {
            self = .string(s)
            return
        }

        if let a = try? container.decode([JSONValue].self) {
            self = .array(a)
            return
        }

        if let o = try? container.decode([String: JSONValue].self) {
            self = .object(o)
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "JSONValue: unsupported JSON token"
        )
    }

    // MARK: - Encoding

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let s):  try container.encode(s)
        case .number(let n):  try container.encode(n)
        case .bool(let b):    try container.encode(b)
        case .null:           try container.encodeNil()
        case .array(let a):   try container.encode(a)
        case .object(let o):  try container.encode(o)
        }
    }

    // MARK: - Convenience accessors

    /// The contained `String`, or `nil` if this is not a `.string`.
    public var stringValue: String? {
        if case .string(let s) = self { return s }
        return nil
    }

    /// The contained `Double`, or `nil` if this is not a `.number`.
    public var numberValue: Double? {
        if case .number(let n) = self { return n }
        return nil
    }

    /// The contained `Bool`, or `nil` if this is not a `.bool`.
    public var boolValue: Bool? {
        if case .bool(let b) = self { return b }
        return nil
    }

    /// The contained array, or `nil` if this is not an `.array`.
    public var arrayValue: [JSONValue]? {
        if case .array(let a) = self { return a }
        return nil
    }

    /// The contained dictionary, or `nil` if this is not an `.object`.
    public var objectValue: [String: JSONValue]? {
        if case .object(let o) = self { return o }
        return nil
    }

    /// Whether this value is `.null`.
    public var isNull: Bool {
        if case .null = self { return true }
        return false
    }
}
