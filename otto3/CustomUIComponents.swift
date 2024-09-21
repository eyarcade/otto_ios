//
//  CustomUIComponents.swift
//  otto3
//
//  Created by Cade on 9/4/24.
//

import UIKit

// Cusomt font for loadingView text
class LoadingViewLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Futura-MediumItalic", size: 24) // Set the specific font for the loading view
    }
}

// Cusomt font for galleryView text
class GalleryViewHeadingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Futura-Medium", size: 24) // Set the font for the gallery view
    }
}

class GalleryViewBodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Futura", size: 18) // Set the font for the gallery view
    }
}


class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.titleLabel?.font = UIFont(name: "Courier New", size: self.titleLabel?.font.pointSize ?? 17)
    }
}

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Courier New", size: self.font?.pointSize ?? 17)
    }
}

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Courier New", size: self.font?.pointSize ?? 17)
    }
}
