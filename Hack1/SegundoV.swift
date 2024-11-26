//
//  SegundoV.swift
//  Hack1
//
//  Created by CEDAM10 on 26/11/24.
//

import UIKit

class SegundoV: UIViewController {

    @IBOutlet weak var menu: UIImageView!
    @IBOutlet weak var Logo: UIImageView!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Configurar las imágenes
        menu.image = UIImage(named: "Menu") // Cambia "Menu" por el nombre de tu imagen
        Logo.image = UIImage(named: "Logo") // Cambia "Hestia" por el nombre de tu imagen
                
        menu.contentMode = .scaleAspectFit
        Logo.contentMode = .scaleAspectFill
        
        // Agregar el cuadro de texto
        setupTextField()
    }

    func setupTextField() {
        // Crear el UITextField
        textField = UITextField(frame: CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 40))
        textField.placeholder = "¿A dónde vamos a ir?"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        
        // Añadir el cuadro de texto a la vista
        self.view.addSubview(textField)
    }
}
