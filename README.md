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

**Etape 2:**
Récupérer une photo depuis les images du téléphone de l’utilisateur pour remplir le montage photo.

**Etape 3:**
Reconnaitre une gestuelle pour partager la combinaison photo

**Etape 4:**
Partager la combinaison de photos faites. (Pour cela il faut que la vue partager soit de type UIImage…)
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
