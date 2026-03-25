import XCTest
@testable import FormspecSwift

final class JSONValueTests: XCTestCase {

    // MARK: - Decoding

    func testDecodeString() throws {
        let json = #""hello""#.data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .string("hello"))
    }

    func testDecodeNumber() throws {
        let json = "42.5".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .number(42.5))
    }

    func testDecodeInteger() throws {
        let json = "7".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .number(7.0))
    }

    func testDecodeBoolTrue() throws {
        let json = "true".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .bool(true))
    }

    func testDecodeBoolFalse() throws {
        let json = "false".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .bool(false))
    }

    func testDecodeNull() throws {
        let json = "null".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .null)
    }

    func testDecodeArray() throws {
        let json = #"[1, "two", true, null]"#.data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .array([.number(1), .string("two"), .bool(true), .null]))
    }

    func testDecodeObject() throws {
        let json = #"{"key": "value", "count": 3}"#.data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        XCTAssertEqual(value, .object(["key": .string("value"), "count": .number(3)]))
    }

    func testDecodeNestedStructure() throws {
        let json = #"{"user": {"name": "Alice", "scores": [10, 20, 30]}, "active": true}"#.data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        let expected = JSONValue.object([
            "user": .object([
                "name": .string("Alice"),
                "scores": .array([.number(10), .number(20), .number(30)])
            ]),
            "active": .bool(true)
        ])
        XCTAssertEqual(value, expected)
    }

    // MARK: - Bool vs Number disambiguation

    func testBoolIsNotDecodedAsNumber() throws {
        let json = "true".data(using: .utf8)!
        let value = try JSONDecoder().decode(JSONValue.self, from: json)
        // Must be .bool(true), NOT .number(1.0)
        if case .bool(let b) = value {
            XCTAssertTrue(b)
        } else {
            XCTFail("Expected .bool(true), got \(value)")
        }
    }

    // MARK: - Encoding round-trip

    func testEncodeDecodeString() throws {
        let original = JSONValue.string("hello world")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testEncodeDecodeNumber() throws {
        let original = JSONValue.number(3.14)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testEncodeDecodeBool() throws {
        let original = JSONValue.bool(false)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testEncodeDecodeNull() throws {
        let original = JSONValue.null
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testEncodeDecodeNestedObject() throws {
        let original = JSONValue.object([
            "name": .string("test"),
            "values": .array([.number(1), .bool(true), .null])
        ])
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    // MARK: - Convenience accessors

    func testStringValue() throws {
        XCTAssertEqual(JSONValue.string("hi").stringValue, "hi")
        XCTAssertNil(JSONValue.number(1).stringValue)
        XCTAssertNil(JSONValue.bool(true).stringValue)
        XCTAssertNil(JSONValue.null.stringValue)
    }

    func testNumberValue() throws {
        XCTAssertEqual(JSONValue.number(42.0).numberValue, 42.0)
        XCTAssertNil(JSONValue.string("42").numberValue)
        XCTAssertNil(JSONValue.bool(true).numberValue)
        XCTAssertNil(JSONValue.null.numberValue)
    }

    func testBoolValue() throws {
        XCTAssertEqual(JSONValue.bool(true).boolValue, true)
        XCTAssertEqual(JSONValue.bool(false).boolValue, false)
        XCTAssertNil(JSONValue.string("true").boolValue)
        XCTAssertNil(JSONValue.number(1).boolValue)
        XCTAssertNil(JSONValue.null.boolValue)
    }

    func testArrayValue() throws {
        let arr: [JSONValue] = [.number(1), .string("a")]
        XCTAssertEqual(JSONValue.array(arr).arrayValue, arr)
        XCTAssertNil(JSONValue.string("[]").arrayValue)
        XCTAssertNil(JSONValue.null.arrayValue)
    }

    func testObjectValue() throws {
        let obj: [String: JSONValue] = ["k": .string("v")]
        XCTAssertEqual(JSONValue.object(obj).objectValue, obj)
        XCTAssertNil(JSONValue.string("{}").objectValue)
        XCTAssertNil(JSONValue.null.objectValue)
    }

    func testIsNull() throws {
        XCTAssertTrue(JSONValue.null.isNull)
        XCTAssertFalse(JSONValue.string("null").isNull)
        XCTAssertFalse(JSONValue.number(0).isNull)
        XCTAssertFalse(JSONValue.bool(false).isNull)
    }
}
