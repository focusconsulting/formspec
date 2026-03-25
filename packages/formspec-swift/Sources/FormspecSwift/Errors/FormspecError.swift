/// @filedesc FormspecError — all errors thrown by the FormspecSwift public API.

import Foundation

/// Errors that can be thrown by the FormspecSwift library.
public enum FormspecError: Error, Sendable {
    /// The WASM bundle could not be loaded or initialized.
    case wasmLoadFailed(underlying: String)
    /// The formspec engine failed to start up.
    case engineLoadFailed(message: String)
    /// The provided form definition is structurally invalid.
    case definitionInvalid(message: String)
    /// The bridge to the embedded WebView is not connected.
    case bridgeDisconnected
    /// A bridge operation did not receive a response within the allowed time.
    case bridgeTimeout
    /// The requested locale is not available in the bundle.
    case localeNotAvailable(languageCode: String)
}
