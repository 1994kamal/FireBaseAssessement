//
//  HomeVC.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var postCV: UICollectionView!
    
    var postCollectionViewCell: PostCVCell?
    var postViewModel = PostViewModel()
    var documentData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCV.register(UINib(nibName: "PostCVCell", bundle: nil), forCellWithReuseIdentifier: "PostCVCell")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if let tabBarControllers = tabBarController?.viewControllers {
            // Assuming the view controller you want to refresh is at index 0 (the first tab)
            if let viewController = tabBarControllers[0] as? HomeVC {
                // Call a method in your view controller to refresh its content
                fetchdata()
            }
        }
        
    }
    
    func fetchdata() {
        self.postViewModel.fetchPosts { (posts, error) in
            if let error = error {
                // Handle error
                print("Error fetching posts: \(error.localizedDescription)")
            } else if let posts = posts {
                // Handle fetched posts
                print("Fetched \(posts.count) posts")
                self.documentData = posts
                self.postCV.reloadData()
                // Here you can use the fetched posts in your UI or perform any other operation
            }
        }
    }
}

extension HomeVC : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(documentData.count)
        return documentData.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = postCV.dequeueReusableCell(withReuseIdentifier: "PostCVCell", for: indexPath) as! PostCVCell
        let data = documentData[indexPath.item]
        cell.userNameLabel.text = data.username
        cell.descLabel.text = data.description
        print(data.imageURLs ?? [""])
        cell.setupCell(imageModel: data.imageURLs ?? [""])
        if let timestamp = data.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" 
            let dateString = dateFormatter.string(from: timestamp)
            cell.dateLabel.text = dateString
        } else {
            cell.dateLabel.text = "Date Not Available"
        }
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: postCV.frame.width, height: postCV.frame.height/2)
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
           return 10
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           
           return 10
       }
}
