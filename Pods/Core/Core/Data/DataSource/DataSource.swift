//
//  DataSource.swift
//  Core
//
//  Created by Muhammad Fahmi on 12/12/23.
//

import Foundation
import Combine

public protocol DataSource {
  associatedtype Request
  associatedtype Response

  func execute(request: Request?) -> AnyPublisher<Response, Error>
}
