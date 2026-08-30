//
//  GitProcessImplementation.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 8/30/26.
//

import Foundation

public protocol GitProcessImplementation {
  @discardableResult
  func gitData(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws -> Data

  @discardableResult
  func git(_ arguments: [String], errorBuilder: (Int32) -> Error) async throws -> [String]
}
