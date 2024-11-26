//
//  ViewController.swift
//  Hack1
//
//  Created by CEDAM10 on 26/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Principal: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
     
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Princ") // La misma imagen de fondo
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0) // Coloca la imagen de fondo al fondo de la vista
    }
}
