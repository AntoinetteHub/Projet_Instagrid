//
//  ViewController.swift
//  Projet_Instagrid
//
//  Created by Antoinette Diana on 20/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: Outlet
    @IBOutlet var myPictureButton : [UIButton]!
    @IBOutlet var myLayoutButton : [UIButton]!
    @IBOutlet var myButtonStackView: UIStackView!
    
    @IBOutlet var myUIView: UIView!
    
    // MARK: Outlet Action
    @IBAction func myLayoutButtonTap(_ sender: UIButton){
        updateLayoutButton(sender: sender)
    }
    
    @IBAction func myPictureButtonTap(_ sender: UIButton){
        updatePictureButton(sender)
    }
    
// MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureButtonShaping()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeGesture.direction = .up
        swipeGesture.numberOfTouchesRequired = 1
        myButtonStackView.addGestureRecognizer(swipeGesture)
        myButtonStackView.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSwipeGestureDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

// MARK: Methods
//    change the shaping of the picture button
    private func pictureButtonShaping() {
        for button in myPictureButton {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
//    change aspect of the layout button to show wich one is selected and update the layout of the picture button accordingly
    private func updateLayoutButton(sender:UIButton) {
        for button in myLayoutButton {
            button.setImage(nil, for: .normal)
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
        }
        sender.setImage(UIImage(named: "Selected"), for: .normal)
        changePictureButtonLayout(sender)
    }
    
//    Update the layout of the picture button
    private func changePictureButtonLayout(_ button : UIButton) {
        switch button {
        case myLayoutButton[0]:
            myPictureButton[1].isHidden = true
            myPictureButton[3].isHidden = false
        case myLayoutButton[1]:
            myPictureButton[1].isHidden = false
            myPictureButton[3].isHidden = true
        case myLayoutButton[2]:
            myPictureButton[1].isHidden = false
            myPictureButton[3].isHidden = false
        default: break
        }
    }
    
//    open the picture library when the picture button is selected
    private func updatePictureButton(_ sender:UIButton) {
        sender.isSelected = true
        let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                present(imagePickerController, animated: true)
    }
    
//    Respond to the swipe gesture
    @objc func respondToSwipeGesture (_ gesture:UISwipeGestureRecognizer) {
        var transform : CGAffineTransform
        transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
        if let recognizer = myButtonStackView.gestureRecognizers?[0] as? UISwipeGestureRecognizer {
            switch recognizer.direction {
            case .left :
                transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            default:
                transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.myButtonStackView.transform = transform
        } completion: { _ in
            self.shareImage()
        }
    }
    
//    partage d'une image avec d'autres applications
    private func shareImage() {
        let image = imageWithStackView(stackView: myButtonStackView)
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.3) {
                self.myButtonStackView.transform = .identity
            }
        }
    }
    
//    renvoie une image ?? partir d'une stack view
    private func imageWithStackView (stackView: UIStackView) -> UIImage {
        let image = UIGraphicsImageRenderer ( size: stackView.bounds.size )
        return image.image { _ in stackView.drawHierarchy(in: stackView.bounds, afterScreenUpdates: true) }
    }
    
//    change le sens de la gestuelle swipgesture suivant la notification envoye sur l'orientation du telephone
    @objc private func changeSwipeGestureDirection() {
        if let recognizer = myButtonStackView.gestureRecognizers?[0] as? UISwipeGestureRecognizer {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                recognizer.direction = .left
            } else {
                recognizer.direction = .up
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        for photo in myPictureButton {
            if photo.isSelected {
                photo.setImage(image, for: .normal)
                photo.imageView?.contentMode = .scaleAspectFill
                photo.isSelected = false
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

