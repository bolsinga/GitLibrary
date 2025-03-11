//
//  Git.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 3/11/25.
//

import Foundation

public protocol Git {
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

public func createGit(_ implementation: Implementation) throws -> Git {
  try implementation.create()
}
