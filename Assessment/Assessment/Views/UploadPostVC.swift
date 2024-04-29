//
//  UploadPostVC.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import UIKit
import PhotosUI
import Firebase

class UploadPostVC: BaseVC,UIImagePickerControllerDelegate, UINavigationControllerDelegate,PHPickerViewControllerDelegate {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imagesCollectionview: UICollectionView!
    
    var db: Firestore!
    var customCollectionRef: CollectionReference!
    
    let imagePicker = UIImagePickerController()
    var selectedImages = [UIImage]()
    var selectedImagesUrls = [String]()
    var getNumber = Int()
    var postVM = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionview.register(UINib(nibName: "imageCVCell", bundle: nil), forCellWithReuseIdentifier: "imageCVCell")
            
        db = Firestore.firestore()
                
                // Initialize Firestore collection reference
                customCollectionRef = db.collection("posts")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPhotos()
    }
    func fetchPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // Set to 0 to allow unlimited selection
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        // Handle error
                    } else if let image = image as? UIImage {
                        // Convert UIImage to Data
                        self?.selectedImages.append(image)
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            // Create a temporary file URL to save the image data
                            let temporaryDirectory = FileManager.default.temporaryDirectory
                            let temporaryFileURL = temporaryDirectory.appendingPathComponent("temp_image.jpg")
                            
                            // Write image data to the temporary file URL
                            do {
                                try imageData.write(to: temporaryFileURL)
                                
                                // Now you have the URL of the image
                                print("URL of the image: \(temporaryFileURL)")
                                
                                DispatchQueue.main.async { [weak self] in
                                    let urlString = temporaryFileURL.absoluteString
                                    self?.selectedImagesUrls.append(urlString)
                                    self?.imagesCollectionview.reloadData()
                                }
                            } catch {
                                print("Error writing image data to file: \(error.localizedDescription)")
                                // Handle error
                            }
                        }
                    }
                }
            }
        }
    }

    
    func pickerDidCancel(_ picker: PHPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonClicked(_ sender: Any) {
        print(self.selectedImagesUrls)
            getNumber = UserDefaults.standard.integer(forKey: "NumberKey")
            getNumber += 1
            UserDefaults.standard.set(getNumber, forKey: "NumberKey")
            let documentData: [String: Any] = [
            "username": "kamal_saini",
            "description": "There are many variations of passages of Lorem Ipsum available.",
            "imageURLs": self.selectedImagesUrls,
            "creationDate": Timestamp(date: Date()),
            "userID": "\(self.getNumber)"
        ]
        
        self.postVM.addPost(post: documentData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                self.alert(message: "Document added successfully!")
                print("Document added successfully!")
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    
}

extension UploadPostVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.selectedImages.count)
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionview.dequeueReusableCell(withReuseIdentifier: "imageCVCell", for: indexPath) as! imageCVCell
        cell.postImageImageview.image = selectedImages[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = selectedImages[indexPath.item]
        if !selectedImages.contains(asset) {
            selectedImages.append(asset)
        } else {
            if let index = selectedImages.firstIndex(of: asset) {
                selectedImages.remove(at: index)
            }
        }
        imagesCollectionview.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imagesCollectionview.frame.width/3.3, height: imagesCollectionview.frame.height/4.2)
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
           return 10
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           
           return 10
       }
    
    
    
}
