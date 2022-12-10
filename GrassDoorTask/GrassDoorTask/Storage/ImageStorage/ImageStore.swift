//
//  ImageStore.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import UIKit.UIImage

public protocol ImageStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (UIImage?) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func insert(_ imageName: String, _ image: UIImage?, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func retrieve(_ imageName: String) -> UIImage?
}
