//
//  GitError.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 8/29/26.
//

import Foundation

enum GitError: Error {
  case status(Int32)
  case checkout(Int32)
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
