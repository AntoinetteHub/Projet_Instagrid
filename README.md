# Projet_Instagrid
***
## Objectif
Application de montage Photo ( choix de 3 ou 4 photos) avec possibilité d’enregistrer ou partager le montage.
***
## Apprentissage
* Créer une vue qui s’adapte au choix de l’utilisateur (plusieurs combinaisons possible d’assemblages photo)
* Récupérer une photo dans les images enregistrées sur le téléphone de l’utilisateur
* Reconnaitre la gestuelle de l’utilisateur pour l’associer à une action 
* Partager une image avec d’autre application ( mail,…)

**Etape 1:**
Vue centrale adaptable selon la combinaison choisie par l’utilisateur.

<img src="https://user-images.githubusercontent.com/120408773/208641550-6ee6f124-a094-4a2a-8d2b-0563a51544d0.png" width="19%" height="19%" />  <img src="https://user-images.githubusercontent.com/120408773/208641587-c3525ed0-5fe3-4e99-b289-faba04901056.png" width="20%" height="20%" />  <img src="https://user-images.githubusercontent.com/120408773/208641603-93e16d51-d6f9-4064-89eb-79a3ec3c5731.png" width="19.5%" height="19.5%" />

**Etape 2:**
Récupérer une photo depuis les images du téléphone de l’utilisateur pour remplir le montage photo.

<img src="https://user-images.githubusercontent.com/120408773/208641613-5d6c21f1-d157-44e1-a417-3b58bed062a2.png" width="20%" height="20%" />

**Etape 3:**
Reconnaitre une gestuelle pour partager la combinaison photo

**Etape 4:**
Partager la combinaison de photos faites. (Pour cela il faut que la vue partager soit de type UIImage…)

<img src="https://user-images.githubusercontent.com/120408773/208641630-e143ffbb-1434-4ef6-8d1d-5751bd9aa496.png" width="20%" height="20%" />

**Etape 5:**
Créer des contraintes associées au mode portrait et d'autres au mode paysage pour permettre l'utilisation de l'application dans les deux directions

<img src="https://github.com/AntoinetteHub/Projet_Instagrid/blob/main/Screenshots/6.png" width="20%" height="20%" />. <img src="https://github.com/AntoinetteHub/Projet_Instagrid/blob/main/Screenshots/7.png" width="40%" height="40%" />

***
## Notions Clés
**Mettre en forme un bouton:**
```
button.layer.borderWidth = 1
button.layer.borderColor = UIColor.white.cgColor
```
**Ouvrir la librairie utilisateur:**
```
import UIKit

class ViewController: UIViewController {
  private func action {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    present(imagePickerController, animated: true)
  }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 	  guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		actionWithIlage(image: image)
		picker.dismiss(animated: true, completion: nil)
  }
}
```
**Reconnaissance gestuelle:**
```
// MARK: View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
    swipeGesture.direction = .up
    swipeGesture.numberOfTouchesRequired = 1
    myUIView.addGestureRecognizer(swipeGesture)
    myUIView.isUserInteractionEnabled = true
  }

 // MARK: - Methodes
 ///perform swipe gesture
   @objc func respondToSwipeGesture (_ gesture:UISwipeGestureRecognizer) {     
     let transform : CGAffineTransform
     transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
     UIView.animate(withDuration: 0.3) {
        self.myUIView.transform = transform 
        } completion: { _ in
        self.myUIView.transform = .identity
        }
     }
```
**Partage d’une image:**
```
// MARK: - Methodes
// partage d'une image avec d'autres applications
    private func shareImage() {
        let image = myImageToShare
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true)
    }
    
// renvoie une image à partir d’autre chose (ici exemple avec une stackView)
    private func imageWithMyOtherKindOfView (stackView: UIStackView) -> UIImage {
        let image = UIGraphicsImageRenderer ( size: stackView.bounds.size )
        return image.image { _ in stackView.drawHierarchy(in: stackView.bounds, afterScreenUpdates: true) }
    }
```
**Variantion des contraintes mode portrait/paysage:**

<img src="https://github.com/AntoinetteHub/Projet_Instagrid/blob/main/Screenshots/8.png" width="20%" height="20%" />  <img src="https://github.com/AntoinetteHub/Projet_Instagrid/blob/main/Screenshots/9.png" width="20%" height="20%" />
