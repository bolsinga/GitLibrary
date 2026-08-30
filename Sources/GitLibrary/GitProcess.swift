//
//  GitProcess.swift
//
//
//  Created by Greg Bolsinga on 3/21/24.
//

import Foundation

struct GitProcess: Git {
  internal struct Implementation: GitProcessImplementation {
    private let path: String
    private let suppressStandardErr: Bool

    init(directory: URL, suppressStandardErr: Bool = false) {
      self.path = directory.path(percentEncoded: false)
      self.suppressStandardErr = suppressStandardErr
    }

    fileprivate var gitPathArguments: [String] {
      ["-C", path]
    }

    @discardableResult
    func gitData(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws -> Data {
      let gitArguments = gitPathArguments + arguments

      let result = try await launch(
        tool: URL(filePath: "/usr/bin/git"), arguments: gitArguments,
        suppressStandardErr: suppressStandardErr)
      guard result.0 == 0 else { throw errorBuilder(result.0) }
      return result.1
    }

    @discardableResult
    func git(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws -> [String] {
      let data = try await gitData(arguments, errorBuilder: errorBuilder)
      guard let standardOutput = String(data: data, encoding: .utf8) else { return [] }
      return standardOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
    }
  }

  let implementation: Implementation

  init(directory: URL, suppressStandardErr: Bool = false) {
    self.implementation = Implementation(
      directory: directory, suppressStandardErr: suppressStandardErr)
  }

  public func branchName() async throws -> String? {
    let data = try await implementation.gitData(["rev-parse", "--abbrev-ref", "HEAD"]) {
      GitError.describeTag($0)
    }
    guard let branch = String(data: data, encoding: .utf8) else { return nil }
    return branch.firstLine
  }

  public func mostRecentHash() async throws -> String? {
    let data = try await implementation.gitData(["show", "-s", "--format=%H"]) {
      GitError.mostRecentHash($0)
    }
    guard let commit = String(data: data, encoding: .utf8) else { return nil }
    return commit.firstLine
  }
}
