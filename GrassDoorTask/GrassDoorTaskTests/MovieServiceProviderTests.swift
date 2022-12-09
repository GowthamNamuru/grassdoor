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
    private var client: HTTPClientSpy!

    override func setUp() {
        super.setUp()
        client = HTTPClientSpy()
        serviceProvider = MovieServiceProvider(client: client)
    }

    override func tearDown() {
        serviceProvider = nil
        client = nil
        super.tearDown()
    }
    
    func test_load_deliversErrorOnClientError() {
        
        let sampleCodes = [199,201,300,400,500]
        sampleCodes.enumerated().forEach { index, code in

            expect(toCompleteWithResult: failure(.invalidData)) {
                let emptyJOSN = makeItemJSON(items: [])
                client.complete(withStatusCode: code, data: emptyJOSN, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        expect(toCompleteWithResult: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        
        expect(toCompleteWithResult: failure(.invalidData)) {
            let invalidJSON = Data.init("Invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        expect(toCompleteWithResult: .success([])) {
            let emptyJSONList = makeItemJSON(items: [])
            client.complete(withStatusCode: 200, data: emptyJSONList)
        }
    }
    
    func test_load_deliversFeedImagesOn200HTTPResponseWithJSONList() {
        let movie1 = makeMovie(id: 123, title: "title1", overview: "overview1", posterPath: nil, backdropPath: nil, releaseDate: "2022/11/01")
        let movie2 = makeMovie(id: 124, title: "title2", overview: "overview2", posterPath: nil, backdropPath: nil, releaseDate: "2022/11/02")
                
        expect(toCompleteWithResult: .success([movie1.model, movie2.model])) {
            let json = makeItemJSON(items: [movie1.json, movie2.json])
            client.complete(withStatusCode: 200, data: json)
        }
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTDeallocated() {
        let client = HTTPClientSpy()
        var sut: MovieServiceProvider? = MovieServiceProvider(client: client)
        
        var capturedResults = [MovieServiceProvider.Result]()
        sut?.fetchMovies(endPoint: .topRated, completionHandler: {
            capturedResults.append($0)
        })
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON(items: []))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func makeItemJSON(items: [[String: Any]]) -> Data {
        let json = [
            "results": items
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(toCompleteWithResult receivedResult: MovieServiceProvider.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load to complete")
        
        serviceProvider.fetchMovies(endPoint: .topRated) { expectedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as MovieServiceProvider.Error), .failure(expectedError as MovieServiceProvider.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("ExpectedResult \(expectedResult) receivedResult \(receivedResult)")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    private func failure(_ error: MovieServiceProvider.Error) -> MovieServiceProvider.Result {
        return .failure(error)
    }
    
    private func makeMovie(id: Int, title: String, overview: String, posterPath: String?, backdropPath: String?, releaseDate: String, runtime: Int? = 0, voteCount: Int = 0) -> (model: Movie, json: [String: Any]) {
        let movie = Movie(id: id, title: title, overview: overview, posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate, runTime: runtime, voteCount: voteCount)
        let json = [
            "id": id,
            "backdrop_path": backdropPath,
            "overview": overview,
            "poster_path": posterPath,
            "release_date": releaseDate,
            "title": title,
            "vote_count": voteCount
        ].compactMapValues({$0})
        return (movie, json)
    }
}

final class HTTPClientSpy: HTTPClient {
    
    var messages: [(HTTPURLResult) -> Void] = []
    
    func get(from url: URL, completion: @escaping (HTTPURLResult) -> Void) {
        messages.append((completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index](.failure(error))
    }
    
    func complete(withStatusCode: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: URL(string: "http://a-url.com")!,
            statusCode: withStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index](.success(data, response))
    }
}


extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.releaseDate == rhs.releaseDate && rhs.title == lhs.title
    }
}
