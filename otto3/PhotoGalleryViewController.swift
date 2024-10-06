//
//  PhotoGalleryViewController.swift
//  otto3
//
//  Cade Guerrero-Miranda
//  Cooper Engebretson

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
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
    var savedEntries: [(logo: UIImage, info: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupFooterMenu()
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
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            print("Collection view failed to initialize")
        }
    }

    func setupFooterMenu() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)

        let button1 = UIButton(type: .system)
        button1.setTitle("Filter", for: .normal)
        button1.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(button1)

        let button2 = UIButton(type: .system)
        button2.setTitle("Trash", for: .normal)
        button2.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(button2)

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            button1.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            button1.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            button2.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            button2.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedEntries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoGalleryCell
        cell.imageView.image = savedEntries[indexPath.item].logo
        cell.infoLabel.text = savedEntries[indexPath.item].info

        // Add a border to the most recent entry (index 0 in the savedEntries array)
        if indexPath.item == 0 {
            cell.contentView.layer.borderWidth = 5.0
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.cornerRadius = 20.0
            cell.contentView.layer.masksToBounds = true
        } else {
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.cornerRadius = 0.0
        }

        return cell
    }

    func addVehicleEntry(image: UIImage?, vehicleInfo: (make: String, model: String, year: String)) {
        let info = "\(vehicleInfo.make) \(vehicleInfo.model) \(vehicleInfo.year)"
        
        // Get logo based on the make using LogoMapping file
        let image = LogoMapping.getLogo(for: vehicleInfo.make) ?? UIImage(named: "default-logo")
        
        guard let unwrappedImage = image else {
            print("Failed to retrieve logo image for: \(vehicleInfo.make)")
            return
        }
        
        // Insert the new entry at the start of the array
        savedEntries.insert((logo: unwrappedImage, info: info), at: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            let topIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: topIndexPath, at: .top, animated: true)
        }
    }
}
