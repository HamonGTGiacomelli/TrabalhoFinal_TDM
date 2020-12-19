//
//  ViewController.swift
//  ProjetoFinalTDM
//
//  Created by Hamon Giacomelli on 16/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var segmentTipo: UISegmentedControl!
    var context: NSManagedObjectContext!
    var entrada: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtDescricao.becomeFirstResponder()
        
        if entrada != nil {
            let txtDescricaoRecuperada = entrada.value(forKey: "descricao") as? String
            let txtValorRecuperado = entrada.value(forKey: "valor") as! Decimal
            let txtTipo = entrada.value(forKey: "tipo") as? String
            if (txtDescricaoRecuperada != "") {
                txtDescricao.text = txtDescricaoRecuperada
                txtValor.text = NSDecimalNumber(decimal: txtValorRecuperado).stringValue
                if (txtTipo == "Débito") {
                    segmentTipo.selectedSegmentIndex = 0
                } else {
                    segmentTipo.selectedSegmentIndex = 1
                }
            }
        } else {
            txtDescricao.text = ""
            txtValor.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    @IBAction func salvar(_ sender: Any) {
        var salvo = false
        if (entrada == nil) {
            salvo = self.salvarEntrada()
        } else {
            salvo = self.aturalizarEntrada()
        }
        
        if (salvo) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func salvarEntrada() -> Bool {
        let novaEntrada = NSEntityDescription.insertNewObject(forEntityName: "Entradas", into: context)
        
        let descricao = txtDescricao.text
        let valor = txtValor.text
        let tipo = segmentTipo.titleForSegment(at: segmentTipo.selectedSegmentIndex)
        
        if (descricao == "" || valor == "" ) {
            exibirErroValidacao()
            return false
        }
        
        if (tipo == "Débito") {
            novaEntrada.setValue("Débito", forKey: "tipo")
        } else {
            novaEntrada.setValue("Crédito", forKey: "tipo")
        }
        novaEntrada.setValue(Decimal(string: valor!), forKey: "valor")
        novaEntrada.setValue(descricao, forKey: "descricao")
        
        do {
            try context.save()
            print("Entrada salva com sucesso!")
        } catch let erro {
            print("Erro ao salvar Entrada: \(erro.localizedDescription)")
            return false
        }
        return true
    }
    
    func aturalizarEntrada() -> Bool {
        let descricao = txtDescricao.text
        let valor = txtValor.text
        let tipo = segmentTipo.titleForSegment(at: segmentTipo.selectedSegmentIndex)
        
        if (descricao == "" || valor == "" ) {
            exibirErroValidacao()
            return false
        }
        
        if (tipo == "Débito") {
            entrada.setValue("Débito", forKey: "tipo")
        } else {
            entrada.setValue("Crédito", forKey: "tipo")
        }
        entrada.setValue(Decimal(string: valor!), forKey: "valor")
        entrada.setValue(descricao, forKey: "descricao")
        
        do {
            try context.save()
            print("Entrada salva com sucesso!")
        } catch let erro {
            print("Erro ao salvar Entrada: \(erro.localizedDescription)")
            return false
        }
        return true
    }
    
    func exibirErroValidacao() {
        let alert = UIAlertController(title: "Erro", message: "Por favor, preencha todos os campos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

