//
//  ResultadoViewController.swift
//  ProjetoFinalTDM
//
//  Created by Hamon Giacomelli on 18/12/20.
//

import UIKit

class ResultadoViewController: UIViewController {

    @IBOutlet weak var txtCredito: UILabel!
    @IBOutlet weak var txtDebito: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    var credito: Decimal = 0.0
    var debito: Decimal = 0.0
    var total: Decimal = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        let stringCredito = currencyFormatter.string(from: credito as NSNumber)
        let stringDebito = currencyFormatter.string(from: debito as NSNumber)
        let stringTotal = currencyFormatter.string(from: total as NSNumber)
        
        txtCredito.text = "Crédito: \(stringCredito!)"
        txtDebito.text = "Débito: \(stringDebito!)"
        txtTotal.text = "Total: \(stringTotal!)"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
