//
//  LoadingView.swift
//  otto3
//
//  Cade Guerrero-Miranda
//  Cooper Engebretson

import UIKit
import QuartzCore

class LoadingView: UIView {
    
    // Image for animation
    private let tireImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tire"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Label for "Searching" text
    private let searchingLabel: LoadingViewLabel = {
        let label = LoadingViewLabel()
        label.text = "Searching"
        label.textColor = .black
        //label.font = UIFont(name: "LeagueSpartan-Bold", size: 24) // Adjust size as needed
        label.textAlignment = .center
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        
        /* see fonts
        for family in UIFont.familyNames {
            print("Font family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("Font: \(font)")
            }
        }
         */
        
        addSubview(tireImageView)
        addSubview(searchingLabel)
        
        tireImageView.translatesAutoresizingMaskIntoConstraints = false
        searchingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for tireImageView
        NSLayoutConstraint.activate([
            tireImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tireImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tireImageView.widthAnchor.constraint(equalToConstant: 100),
            tireImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for searchingLabel
        NSLayoutConstraint.activate([
            searchingLabel.topAnchor.constraint(equalTo: tireImageView.bottomAnchor, constant: 20), // Adjust spacing as needed
            searchingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8) // Adjust width as needed
        ])
        
        startAnimation()
    }
    
    // Animation for tire to rotate
    private func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        tireImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
