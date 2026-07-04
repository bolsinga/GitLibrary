//
//  SubProcess.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 7/4/26.
//

import Foundation
import Subprocess
import System

extension TerminationStatus {
  fileprivate var code: Code {
    switch self {
    case .exited(let code):
      code
    case .signaled(let code):
      code
    }
  }
}
struct SubProcess: Git {
  internal struct Implementation: GitProcessImplementation {
    private static let git: Executable = .path("/usr/bin/git")

    private let workingDirectory: FilePath

    init(directory: URL, suppressStandardErr: Bool = false) {
      guard let directoryPath = FilePath(directory) else {
        preconditionFailure("directory cannot be made into FilePath")
      }
      self.workingDirectory = directoryPath
    }

    @discardableResult
    func gitData(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws
      -> Data
    {
      let result = try await run(
        Self.git,
        arguments: Arguments(arguments),
        workingDirectory: workingDirectory,
        output: .data(limit: .max))

      let status = result.terminationStatus

      guard status.isSuccess else { throw errorBuilder(status.code) }

      return result.standardOutput
    }

    @discardableResult
    func git(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws -> [String] {
      let result = try await run(
        Self.git,
        arguments: Arguments(arguments),
        workingDirectory: workingDirectory,
        output: .string(limit: .max))

      let status = result.terminationStatus

      guard status.isSuccess else { throw errorBuilder(status.code) }

      return result.standardOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
    }
  }

  let implementation: Implementation

  init(directory: URL, suppressStandardErr: Bool = false) {
    self.implementation = Implementation(
      directory: directory, suppressStandardErr: suppressStandardErr)
  }
}
