//
//  CustomUIComponents.swift
//  otto3
//
//  Created by Cade on 9/4/24.
//

import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.font = UIFont(name: "Courier New", size: self.font.pointSize)
        //self.shadowColor = UIColor.green.withAlphaComponent(0.3)
        //self.shadowOffset = CGSize(width: 1, height: 1)
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
