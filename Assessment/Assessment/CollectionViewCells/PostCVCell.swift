//
//  PostCVCell.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import UIKit

class PostCVCell: UICollectionViewCell {
    
    

    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var lastContentOffset: CGFloat = 0
    let autoScrollThreshold: CGFloat = 50
    var images = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageCV.register(UINib(nibName: "imageCVCell", bundle: nil), forCellWithReuseIdentifier: "imageCVCell")
        imageCV.dataSource = self
        imageCV.delegate = self
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
    }
    
    func setupCell(imageModel:[String]) {
        print(imageModel)
        self.images = imageModel
    }

    
    

}

extension PostCVCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = imageCV.dequeueReusableCell(withReuseIdentifier: "imageCVCell", for: indexPath) as! imageCVCell
        
       
        if let url = URL(string: self.images[indexPath.row]) {
                loadImage(from: url) { image in
                    DispatchQueue.main.async {
                        cell.postImageImageview?.image = image
                        cell.setNeedsLayout()
                    }
                }
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: imageCV.frame.width, height: imageCV.frame.height)

       
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
           return 10
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           
           return 10
       }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           lastContentOffset = scrollView.contentOffset.x
       }
       
       func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let currentContentOffset = scrollView.contentOffset.x
           let contentWidth = scrollView.contentSize.width
           let scrollViewWidth = scrollView.frame.width
           
           // Determine if scrolling direction is towards right
           if currentContentOffset > lastContentOffset && currentContentOffset + scrollViewWidth < contentWidth {
               if currentContentOffset - lastContentOffset >= autoScrollThreshold {
                   pageControl.currentPage += 1
                   lastContentOffset = currentContentOffset
               }
           }
           
           // Determine if scrolling direction is towards left
           if currentContentOffset < lastContentOffset && currentContentOffset > 0 {
               if lastContentOffset - currentContentOffset >= autoScrollThreshold {
                   pageControl.currentPage -= 1
                   lastContentOffset = currentContentOffset
               }
           }
       }
    
    
}
extension PostCVCell {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            completion(UIImage(data: data))
        }.resume()
    }
}
