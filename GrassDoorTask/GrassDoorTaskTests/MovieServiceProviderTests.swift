//
//  MovieServiceProviderTests.swift
//  GrassDoorTaskTests
//
//  Created by Gowtham Namuri on 09/12/22.
//

import XCTest
@testable import GrassDoorTask

final class MovieServiceProviderTests: XCTestCase {
    
    private var serviceProvider: MovieServiceProvider!
    
    override func setUp() {
        super.setUp()
        serviceProvider = MovieServiceProvider()
    }
    
    override func tearDown() {
        serviceProvider = nil
        super.tearDown()
    }
}
