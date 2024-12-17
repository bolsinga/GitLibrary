//
//  String+Clean.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 12/16/24.
//

import Foundation

extension String {
  var firstLine: String {
    components(separatedBy: "\n")[0]
  }
}
