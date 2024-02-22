//
//  EFColorSelectionViewController.swift
//  EFColorPicker
//
//  Created by EyreFree on 2017/9/29.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public enum EFColorSelectionMode: Int {
    case all = 0
    case rgb = 1
    case hsb = 2
}

// The delegate of a EFColorSelectionViewController object must adopt the EFColorSelectionViewController protocol.
// Methods of the protocol allow the delegate to handle color value changes.
@objc public protocol EFColorSelectionViewControllerDelegate: NSObjectProtocol {

    // Tells the data source to return the color components.
    // @param colorViewCntroller The color view.
    // @param color The new color value.
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor)
}

public class EFColorSelectionViewController: UIViewController, UITextFieldDelegate {

    // The controller's delegate. Controller notifies a delegate on color change.
    public weak var delegate: EFColorSelectionViewControllerDelegate?
    
    // The current color value.
    public var color: UIColor {
        get {
            return colorSelectionView.color
        }
        set {
            colorSelectionView.color = newValue
        }
    }
    let colorSelectionView = EFColorSelectionView(frame: UIScreen.main.bounds)
    let segmentControl = UISegmentedControl(items: [NSLocalizedString("RGB", comment: ""), NSLocalizedString("HSB", comment: "")])
    
    lazy var hexLabel : UILabel = {
        let label = UILabel()
        label.text = "HexColor："
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    lazy var hexColorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = UIColor.white.colorCode
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(hexColorTextDidChange(textField:)), for: .editingChanged)
        textField.delegate = self

        let notification = NotificationCenter.default
        notification.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        notification.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
        
        return textField
    }()

    
    private var isKeyboardShown: Bool = false
    private var previousText = UIColor.white.colorCode
    
    private let colorCodeLength = 6
    private let colorCodeCharacterSet = CharacterSet(charactersIn: "0123456789abcdef")
    
    
    // MARK:- UITextField Action
    @objc func hexColorTextDidChange(textField: UITextField) {
        
        // Retrieve the inputted characters
        guard let newText = textField.text else {
            return
        }
        if !colorCodeCharacterSet.isSuperset(of: CharacterSet(charactersIn: newText.lowercased())) {
            textField.text = previousText
            return
        }
        if newText.count != colorCodeLength {
            return
        }
        self.color = UIColor(hex: newText, alpha: color.cgColor.alpha)
    }
    
    @objc func opacityTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        // Assuming opacity value ranges from 0.0 to 1.0
        guard let opacity = Float(text), opacity >= 0.0, opacity <= 1.0 else {
            // Handle invalid input
            return
        }
        // Update the opacity of the color
        let currentColor = color.withAlphaComponent(CGFloat(opacity))
        self.color = currentColor
    }
    
    
    // MARK:- Keyboard Notification
    @objc func keyboardWillShow(_ notification: Notification?) {
        isKeyboardShown = true
    }

    @objc func keyboardWillHide(_ notification: Notification?) {
        isKeyboardShown = false
    }

    // Whether colorTextField will hide, default is `true`
    public var isColorTextFieldHidden: Bool {
        get {
            return !colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled
        }
        set {
            if colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled == newValue {
                colorSelectionView.hsbColorView.brightnessView.colorTextFieldEnabled = !newValue
                for colorComponentView in colorSelectionView.rgbColorView.colorComponentViews {
                    colorComponentView.colorTextFieldEnabled = !newValue
                }
            }
        }
    }
    
    lazy var opacityLabel: UILabel = {
        let label = UILabel()
        label.text = "Opacity: "
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var opacityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1.0"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(opacityTextFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        
        return textField
    }()
    
    override public func loadView() {
        let parentView = UIView() // 创建一个父视图
        parentView.backgroundColor = .white // 可选：设置父视图的背景颜色

        // 设置colorSelectionView的frame，使其充满父视图
//        colorSelectionView.frame = parentView.bounds
        colorSelectionView.frame = CGRect(x: 0, y: parentView.bounds.origin.y + 100, width: parentView.bounds.width, height: parentView.bounds.height)
        colorSelectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        parentView.addSubview(segmentControl)
        
        parentView.addSubview(hexLabel)
        parentView.addSubview(hexColorTextField)
        
        parentView.addSubview(opacityLabel)
        parentView.addSubview(opacityTextField)
        // 将colorSelectionView添加为父视图的子视图
        parentView.addSubview(colorSelectionView)

        // 将父视图设置为控制器的根视图
        self.view = parentView
    }


    override public func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlDidChangeValue(_:)),
            for: .valueChanged
        )
        segmentControl.selectedSegmentIndex = 0

        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            hexLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            hexLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hexLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            hexColorTextField.centerYAnchor.constraint(equalTo: hexLabel.centerYAnchor, constant: 0),
            hexColorTextField.leadingAnchor.constraint(equalTo: hexLabel.trailingAnchor, constant: 5),
            hexColorTextField.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            opacityTextField.centerYAnchor.constraint(equalTo: opacityLabel.centerYAnchor, constant: 0),
            opacityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            opacityTextField.widthAnchor.constraint(equalToConstant: 80)
        ])
        
      
        NSLayoutConstraint.activate([
            opacityLabel.centerYAnchor.constraint(equalTo: hexLabel.centerYAnchor, constant: 0),
            opacityLabel.trailingAnchor.constraint(equalTo: opacityTextField.leadingAnchor, constant: -5),
            opacityLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
       
        
        //navigationItem.titleView = segmentControl

        colorSelectionView.setSelectedIndex(index: .RGB, animated: false)
        colorSelectionView.delegate = self
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    public func setMode(mode: EFColorSelectionMode) {
        switch mode {
        case .rgb:
            segmentControl.isHidden = true
            segmentControl.selectedSegmentIndex = 0
            colorSelectionView.setSelectedIndex(index: .RGB, animated: false)
        case .hsb:
            segmentControl.isHidden = true
            segmentControl.selectedSegmentIndex = 1
            colorSelectionView.setSelectedIndex(index: .HSB, animated: false)
        default:
            segmentControl.isHidden = false
        }
    }

    @IBAction func segmentControlDidChangeValue(_ segmentedControl: UISegmentedControl) {
        colorSelectionView.setSelectedIndex(
            index: EFSelectedColorView(rawValue: segmentedControl.selectedSegmentIndex) ?? .RGB,
            animated: true
        )
    }

    override public func viewWillLayoutSubviews() {
        colorSelectionView.setNeedsUpdateConstraints()
        colorSelectionView.updateConstraintsIfNeeded()
    }
}
extension EFColorSelectionViewController: EFColorViewDelegate {
    public func colorView(_ colorView: EFColorView, didChangeColor color: UIColor) {
        hexColorTextField.text = color.colorCode
        delegate?.colorViewController(self, didChangeColor: color)
    }
}
