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
    
// MARK: Outlet Action
    @IBAction func myLayoutButtonTap(_ sender: UIButton){
        updateLayoutButton(sender: sender)
    }
    
    @IBAction func myPictureButtonTap(_ sender: UIButton){
        updatePictureButton(sender)
    }
    
// MARK: Core
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureButtonShaping()
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

