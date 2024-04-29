//
//  PostViewModel.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import Foundation
import Firebase

class PostViewModel {
    
    private let db = Firestore.firestore()
    
    // Function to add a new post to Firestore
    func addPost(post: [String:Any], completion: @escaping (Error?) -> Void) {
        let postData = post
        
        db.collection("posts").addDocument(data: postData) { error in
            completion(error)
        }
    }
    
    // Function to fetch all posts from Firestore
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("posts")
        
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
               
                completion(nil, error)
            } else {
                var posts: [Post] = []
                for document in snapshot!.documents {
                    if let post = Post(documentData: document.data()) {
                        print(post.username)
                        posts.append(post)
                        print(posts.count)
                    } else {
                        // Handle error if unable to create Post object
                        print("Error creating Post object from document data: \(document.data())")
                    }
                }
              
                completion(posts, nil)
            }
        }
    }
    
    

}
