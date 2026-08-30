//
//  Git.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 3/11/25.
//

import Foundation

public protocol Git: Sendable {
  associatedtype Implementation: GitProcessImplementation

  var implementation: Implementation { get }

  @discardableResult func status() async throws -> [String]

  func checkout(commit: String) async throws

  func add(_ filename: String) async throws

  func commit(_ message: String) async throws

  func tag(_ name: String) async throws

  func push() async throws

  func pushTags() async throws

  func gc() async throws

  func diff() async throws

  func tags() async throws -> [String]

  func show(commit: String, path: String) async throws -> Data

  func createBranch(named name: String, initialCommit: String) async throws

  func describeTag() async throws -> String?
}

extension Git {
  @discardableResult
  public func status() async throws -> [String] {
    try await implementation.git(["status", "--porcelain", "-uno"]) { GitError.status($0) }
  }

  public func checkout(commit: String) async throws {
    try await implementation.git(["checkout", commit]) { GitError.checkout($0) }
  }

  public func add(_ filename: String) async throws {
    try await implementation.git(["add", filename]) { GitError.add($0) }
  }

  public func commit(_ message: String) async throws {
    try await implementation.git(["commit", "-m", message]) { GitError.commit($0) }
  }

  public func tag(_ name: String) async throws {
    try await implementation.git(["tag", name]) { GitError.tag($0) }
  }

  public func push() async throws {
    try await implementation.git(["push"]) { GitError.push($0) }
  }

  public func pushTags() async throws {
    try await implementation.git(["push", "--tags"]) { GitError.pushTags($0) }
  }

  public func gc() async throws {
    try await implementation.git(["gc", "--prune=now"]) { GitError.gc($0) }
  }

  public func diff() async throws {
    try await implementation.git(["diff", "--staged", "--name-only", "--exit-code"]) {
      GitError.diff($0)
    }
  }

  public func tags() async throws -> [String] {
    try await implementation.git(["tag"]) { GitError.tags(($0)) }
  }

  public func show(commit: String, path: String) async throws -> Data {
    try await implementation.gitData(["show", "\(commit):\(path)"]) { GitError.show($0) }
  }

  public func createBranch(named name: String, initialCommit: String) async throws {
    try await implementation.git(["checkout", "-b", name, initialCommit]) {
      GitError.createBranch($0)
    }
  }

  public func describeTag() async throws -> String? {
    let data = try await implementation.gitData(["describe", "--tags", "--abbrev=0"]) {
      GitError.describeTag($0)
    }
    guard let tag = String(data: data, encoding: .utf8) else { return nil }
    return tag.firstLine
  }
}
