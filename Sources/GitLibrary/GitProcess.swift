//
//  GitProcess.swift
//
//
//  Created by Greg Bolsinga on 3/21/24.
//

import Foundation

private enum GitError: Error {
  case status(Int32)
  case main(Int32)
  case add(Int32)
  case commit(Int32)
  case tag(Int32)
  case push(Int32)
  case pushTags(Int32)
  case gc(Int32)
  case diff(Int32)
  case tags(Int32)
  case show(Int32)
  case createBranch(Int32)
  case describeTag(Int32)
  case mostRecentHash(Int32)
}

struct GitProcess: Git {
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
  fileprivate func gitData(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws
    -> Data
  {
    let gitArguments = gitPathArguments + arguments

    let result = try await launch(
      tool: URL(filePath: "/usr/bin/git"), arguments: gitArguments,
      suppressStandardErr: suppressStandardErr)
    guard result.0 == 0 else { throw errorBuilder(result.0) }
    return result.1
  }

  @discardableResult
  fileprivate func git(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws
    -> [String]
  {
    let data = try await gitData(arguments, errorBuilder: errorBuilder)
    guard let standardOutput = String(data: data, encoding: .utf8) else { return [] }
    return standardOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
  }

  @discardableResult
  public func status() async throws -> [String] {
    try await git(["status", "--porcelain", "-uno"]) { GitError.status($0) }
  }

  public func checkout(commit: String) async throws {
    try await git(["checkout", commit]) { GitError.main($0) }
  }

  public func add(_ filename: String) async throws {
    try await git(["add", filename]) { GitError.add($0) }
  }

  public func commit(_ message: String) async throws {
    try await git(["commit", "-m", message]) { GitError.commit($0) }
  }

  public func tag(_ name: String) async throws {
    try await git(["tag", name]) { GitError.tag($0) }
  }

  public func push() async throws {
    try await git(["push"]) { GitError.push($0) }
  }

  public func pushTags() async throws {
    try await git(["push", "--tags"]) { GitError.pushTags($0) }
  }

  public func gc() async throws {
    try await git(["gc", "--prune=now"]) { GitError.gc($0) }
  }

  public func diff() async throws {
    try await git(["diff", "--staged", "--name-only", "--exit-code"]) { GitError.diff($0) }
  }

  public func tags() async throws -> [String] {
    try await git(["tag"]) { GitError.tags(($0)) }
  }

  public func show(commit: String, path: String) async throws -> Data {
    try await gitData(["show", "\(commit):\(path)"]) { GitError.show($0) }
  }

  public func createBranch(named name: String, initialCommit: String) async throws {
    try await git(["checkout", "-b", name, initialCommit]) { GitError.createBranch($0) }
  }

  public func describeTag() async throws -> String? {
    let data = try await gitData(["describe", "--tags", "--abbrev=0"]) { GitError.describeTag($0) }
    guard let tag = String(data: data, encoding: .utf8) else { return nil }
    return tag.firstLine
  }

  public func branchName() async throws -> String? {
    let data = try await gitData(["rev-parse", "--abbrev-ref", "HEAD"]) { GitError.describeTag($0) }
    guard let branch = String(data: data, encoding: .utf8) else { return nil }
    return branch.firstLine
  }

  public func mostRecentHash() async throws -> String? {
    let data = try await gitData(["show", "-s", "--format=%H"]) { GitError.mostRecentHash($0) }
    guard let commit = String(data: data, encoding: .utf8) else { return nil }
    return commit.firstLine
  }
}
