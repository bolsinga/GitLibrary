//
//  Implementation.swift
//  GitLibrary
//
//  Created by Greg Bolsinga on 3/11/25.
//

import Foundation

public enum Implementation {
  case outOfProcess(directory: URL, suppressStandardErr: Bool = false)
}

extension Implementation {
  public func create() -> Git {
    switch self {
    case .outOfProcess(let directory, let suppressStandardErr):
      GitProcess(directory: directory, suppressStandardErr: suppressStandardErr)
    }
  }
}
