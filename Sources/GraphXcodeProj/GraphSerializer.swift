import Foundation

protocol GraphSerializer {
  func dump(dependenciesOf: XcodeGraph, on: inout TextOutputStream)
}

class DotSerializer: GraphSerializer {
  func dump(dependenciesOf graph: XcodeGraph, on output: inout TextOutputStream) {
    func walk() {
      for node in graph.nodes {
        output.write(#""\#(node.id)" [label="\#(node.type)\n\#(node.name ?? "⍰")\n\#(node.id)"]"#)
        output.write("\n")
      }
      for edge in graph.edges {
        output.write(#""\#(edge.sourceId)" -> "\#(edge.destinationId)"\#n"#)
      }
    }

    output.write(
      """
      digraph DependenciesGraph {
      node [shape = box]
      rankdir = "LR"

      """
    )
    walk()
    output.write(
      """
      }
      """
    )
  }
}

// MARK: extension OutputStream

//extension OutputStream {
//  // https://forums.swift.org/t/extension-write-to-outputstream/42817/5
//  func write(data: Data) {
//    var remaining = data[...]
//    while !remaining.isEmpty {
//      let bytesWritten = remaining.withUnsafeBytes { buf in
//        // The force unwrap is safe because we know that `remaining` is
//        // not empty. The `assumingMemoryBound(to:)` is there just to
//        // make Swift’s type checker happy. This would be unnecessary if
//        // `write(_:maxLength:)` were (as it should be IMO) declared
//        // using `const void *` rather than `const uint8_t *`.
//        self.write(
//          buf.baseAddress!.assumingMemoryBound(to: UInt8.self),
//          maxLength: buf.count
//        )
//      }
//      guard bytesWritten >= 0 else {
//        // … if -1, throw `streamError` …
//        // … if 0, well, that’s a complex question …
//        fatalError()
//      }
//      remaining = remaining.dropFirst(bytesWritten)
//    }
//  }
//  
//  func write(text: String) {
//    guard let data = text.data(using: .utf8) else { fatalError() }
//    write(data: data)
//  }
//}
