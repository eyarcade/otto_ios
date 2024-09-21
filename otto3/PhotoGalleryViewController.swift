//
//  PhotoGalleryViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let infoLabel: GalleryViewBodyLabel = {
        let label = GalleryViewBodyLabel()
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
            // ImageView constraints - make width a percentage of contentView's width
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.20), // 20% of the content view's width
            
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
    var savedEntries: [(logo: UIImage, info: String)] = [] // Store logo with vehicle info

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeadingLabel()
        setupCollectionView()
    }
    
    func setupHeadingLabel() {
        let headingLabel = GalleryViewHeadingLabel()
        headingLabel.text = NSLocalizedString("Vehicles", comment: "Heading for the vehicles section")
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
        collectionView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
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
        return savedEntries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoGalleryCell
        cell.imageView.image = savedEntries[indexPath.item].logo
        cell.infoLabel.text = savedEntries[indexPath.item].info
        return cell
    }

    func addVehicleEntry(image: UIImage?, vehicleInfo: (make: String, model: String, year: String)) {
        let info = "\(vehicleInfo.make) \(vehicleInfo.model) \(vehicleInfo.year)"
        
        // Get logo based on the make using LogoMapping file
        let image = LogoMapping.getLogo(for: vehicleInfo.make) ?? UIImage(named: "default-logo")
        
        // Safely unwrap the logoImage
            guard let unwrappedImage = image else {
                print("Failed to retrieve logo image for: \(vehicleInfo.make)")
                return
            }
        
        // Safely unwrap image then insert new entry at the beginning of the array
        savedEntries.insert((logo: unwrappedImage, info: info), at: 0)
        // savedEntries.insert((logo: image!, info: info), at: 0)
        
        // Reload collection view
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            
            // Scroll to the top to show the most recent entry
            let topIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: topIndexPath, at: .top, animated: true)
        }
    }
}
