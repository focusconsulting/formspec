/// @filedesc LayoutNode and related types representing a rendered form tree node.

import Foundation

/// A node in the resolved layout tree produced by the formspec engine.
public struct LayoutNode: Codable, Sendable {
    public let id: String
    public let component: String
    public let category: NodeCategory
    public let props: [String: JSONValue]
    public let style: [String: JSONValue]?
    public let cssClasses: [String]
    public let accessibility: AccessibilityInfo?
    public let children: [LayoutNode]
    public let bindPath: String?
    public let fieldItem: FieldItemInfo?
    public let presentation: Presentation?
    public let labelPosition: LabelPosition?
    public let when: String?
    public let whenPrefix: String?
    public let fallback: String?
    public let repeatGroup: String?
    public let repeatPath: String?
    public let isRepeatTemplate: Bool?
}

/// Minimal field metadata carried on a layout node for the field it represents.
public struct FieldItemInfo: Codable, Sendable {
    public let key: String
    public let label: String
    public let hint: String?
    public let dataType: String?
}

/// Resolved presentation directives for a layout node (widget, styling overrides).
public struct Presentation: Codable, Sendable {
    public let widget: String?
    public let widgetConfig: [String: JSONValue]?
    public let labelPosition: LabelPosition?
    public let style: [String: JSONValue]?
    public let accessibility: AccessibilityInfo?
    public let cssClass: String?
}

/// ARIA / accessibility metadata attached to a node.
public struct AccessibilityInfo: Codable, Sendable {
    public let role: String?
    public let description: String?
    public let liveRegion: String?
}

/// Broad classification of what a layout node represents.
public enum NodeCategory: String, Codable, Sendable {
    case layout
    case field
    case display
    case interactive
    case special
}

/// Where a field's label is placed relative to its input.
public enum LabelPosition: String, Codable, Sendable {
    case top
    case start
    case hidden
}
