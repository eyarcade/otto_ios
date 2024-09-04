//
//  PhotoGalleryViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

// Custom UICollectionViewCell to display car image and info
class PhotoGalleryCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(infoLabel)
        
        // Constraints for imageView and infoLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ImageView constraints
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            // Label constraints
            infoLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    var savedImages: [(image: UIImage, info: String)] = [] // Store image with vehicle info

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeadingLabel()
        setupCollectionView()
    }
    
    func setupHeadingLabel() {
        let headingLabel = UILabel()
        headingLabel.text = NSLocalizedString("Vehicles", comment: "Heading for the vehicles section")
        headingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headingLabel.textAlignment = .center
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headingLabel)
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 120)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = .white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            print("Collection view failed to initialize")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoGalleryCell
        cell.imageView.image = savedImages[indexPath.item].image
        cell.infoLabel.text = savedImages[indexPath.item].info
        return cell
    }

    func addVehicleEntry(image: UIImage?, vehicleInfo: (make: String, model: String, year: String)) {
        guard let image = image else { return }
        let info = "\(vehicleInfo.make) \(vehicleInfo.model) \(vehicleInfo.year)"
        savedImages.append((image, info))
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
}
