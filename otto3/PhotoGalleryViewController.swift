//
//  PhotoGalleryViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
        var savedImages: [(image: UIImage, info: String)] = [] // Store image with vehicle info

    func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 150, height: 150)
            layout.scrollDirection = .vertical
            
            collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView?.backgroundColor = .white
            
            if let collectionView = collectionView {
                self.view.addSubview(collectionView)
            } else {
                print("Collection view failed to initialize")
            }
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return savedImages.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let imageView = UIImageView(image: savedImages[indexPath.item].image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
            cell.contentView.addSubview(imageView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 100, width: 150, height: 50))
            label.text = savedImages[indexPath.item].info
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.numberOfLines = 0
            cell.contentView.addSubview(label)
            
            return cell
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load - About to setup collection view")
        setupCollectionView()
        
    }

    func addVehicleEntry(image: UIImage?, vehicleInfo: (make: String, model: String, year: String)) {
            guard let image = image else { return }
            let info = "\(vehicleInfo.make) \(vehicleInfo.model) \(vehicleInfo.year)"
            savedImages.append((image, info))
            DispatchQueue.main.async {
                if let collectionView = self.collectionView {
                    collectionView.reloadData()
                } else {
                    print("Collection view is nil when trying to reload data")
                }
            }
        }

}
