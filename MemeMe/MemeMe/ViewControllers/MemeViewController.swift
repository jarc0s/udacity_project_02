//
//  MemeViewController.swift
//  MemeMe
//
//  Created by juan on 9/3/19.
//  Copyright © 2019 jarcos. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButtom: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    var memeState: MemeState = .initial
    var isBottomTextEditing: Bool = false
    var memedImage: UIImage?
    
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
        updateUIState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //MARK: - IBActions
    @IBAction func pickAnImage(_ sender: Any) {
        setImagePickerController(source: .photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        setImagePickerController(source: .camera)
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
        // image to share
        memedImage = generateMemedImage()
        if let memedImage = memedImage {
            // set up activity view controller
            let imageToShare = [ memedImage ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    // Pop the view controller
                    self.navigationController?.popViewController(animated: true)
                }
            }
            // present the view controller
            self.present(activityViewController, animated: true) {
                self.save()
            }
        }
    }
    
    
    
    func setImagePickerController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func updateUIState(){
        switch memeState {
        case .initial:
            self.topTextField.text = "TOP"
            self.bottomTextField.text = "BOTTOM"
            self.topTextField.isEnabled = false
            self.bottomTextField.isEnabled = false
            self.shareButtom.isEnabled = false
            self.imagePicker.image = nil
            self.imagePicker.setNeedsDisplay()
        case .editing:
            self.topTextField.isEnabled = true
            self.bottomTextField.isEnabled = true
            self.shareButtom.isEnabled = true
        }
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if isBottomTextEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0.0
    }
    
    @objc func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        //Create the meme
        var meme = MemeModel()
        meme.topText = self.topTextField.text
        meme.bottomText = self.bottomTextField.text
        meme.originalImage = self.imagePicker.image
        meme.memedImage = memedImage
        
        print("Save topText: \(meme.topText ?? "") -- bottomText: \(meme.bottomText ?? "") -- ")
        
        //Storage meme
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationController?.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
}


extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePicker.image = image
            self.memeState = .editing
            updateUIState()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension MemeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        isBottomTextEditing = ( textField == bottomTextField ) ? true : false
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text ?? "").isEmpty {
            textField.text = ( textField == topTextField ) ? "TOP" : "BOTTOM"
        }
        return true
    }
    
}

enum MemeState {
    case initial
    case editing
}
