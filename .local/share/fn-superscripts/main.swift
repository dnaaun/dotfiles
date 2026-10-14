import ApplicationServices
import Foundation

let superscripts = ["0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"]
if CommandLine.arguments.count == 2 && CommandLine.arguments[1] == "--check" {
    print("Accessibility trusted: \(AXIsProcessTrusted())")
    print("Mappings: ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁰")
    exit(0)
}
guard CommandLine.arguments.count == 2, let text = superscripts[CommandLine.arguments[1]] else {
    fputs("Usage: fn-superscript <0-9>\n", stderr)
    exit(2)
}
let units = Array(text.utf16)
guard let source = CGEventSource(stateID: .privateState),
      let down = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true),
      let up = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) else { exit(1) }
for event in [down, up] {
    event.flags = []
    units.withUnsafeBufferPointer { buffer in
        event.keyboardSetUnicodeString(stringLength: buffer.count, unicodeString: buffer.baseAddress!)
    }
    event.post(tap: .cghidEventTap)
}
// WindowServer checks a new process's permission to post events asynchronously, and drops the events if the process has already exited
usleep(100_000)
