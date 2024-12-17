//
//  StringTest.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 12/16/24.
//

import Testing

@testable import GitLibrary

struct StringTest {
  @Test func firstLine() throws {
    #expect("one".firstLine == "one")
    #expect("one\n".firstLine == "one")
    #expect("one\ntwo".firstLine == "one")
    #expect(
      """
      one

      """.firstLine == "one")
    #expect(
      """
      one
      two

      """.firstLine == "one")
  }
}
