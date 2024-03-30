import Foundation
import XcodeProj
import PathKit
import ArgumentParser

@main
struct XcodeprojToGraph: ParsableCommand {
  static var configuration: CommandConfiguration = CommandConfiguration(
    commandName: "xcodeproj-to-graph",
    usage:
      """
      Generates plaintext output you can use as input into graphing tools like graphviz.
      Example usage:
          xcodeproj-to-graph MySpecialProject.xcodeproj | dot -T png | open -a Preview -f
      """
  )

  @Argument(help: ArgumentHelp(stringLiteral: "path to an xcodeproj directory"), completion: .directory)
  var inputProjectPath: String

  mutating func run() throws {
    let path = Path(inputProjectPath)
    var xcodeproj: XcodeProj? = nil
    do {
      xcodeproj = try XcodeProj(path: path)
    } catch {
      print(error)
    }
    guard let xcodeproj = xcodeproj else {
      throw XCodeProjError.notFound(path: path)
    }

    let xcodeGraph = XcodeGraph(xcodeproj: xcodeproj)
    DotSerializer().dump(dependenciesOf: xcodeGraph, on: &standardOut)
  }
}

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    let data = Data(string.utf8)
    self.write(data)
  }
}
var standardOut: TextOutputStream = FileHandle.standardOutput
