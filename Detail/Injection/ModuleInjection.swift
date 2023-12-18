//
//  ModuleInjection.swift
//  Detail
//
//  Created by Uwais Alqadri on 25/11/23.
//

import Foundation
import Common

public class ModuleInjection: Injection {
    
    public init() {}
}

public protocol Injection: DetailInjection, CoreInjection {}

extension Bundle {
    static var current: Bundle {
        Bundle.init(for: ModuleInjection.self)
    }
}
