//
//  CustomUIComponents.swift
//  otto3
//
//  Cade Guerrero-Miranda
//  Cooper Engebretson

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
        self.font = UIFont(name: "Futura-MediumItalic", size: 24)
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
        self.font = UIFont(name: "Futura-Medium", size: 24)
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
        self.font = UIFont(name: "Futura", size: 18)
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
