//
//  ListarEntradasTableViewController.swift
//  ProjetoFinalTDM
//
//  Created by Hamon Giacomelli on 16/12/20.
//

import UIKit
import CoreData

class ListarEntradasTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var entradas: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarEntradas()
    }
    
    func recuperarEntradas() {
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Entradas")
        let ordernacao = NSSortDescriptor(key: "descricao", ascending: false)
        requisicao.sortDescriptors = [ordernacao]
        
        do {
            let entradasRecuperadas = try context.fetch(requisicao)
            entradas = entradasRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro {
            print("Erro ao recuperar anotações: \(erro.localizedDescription)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entradas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current

        let entrada = self.entradas[indexPath.row]
        let textoDescricao = entrada.value(forKey: "descricao")
        let decimalValor = entrada.value(forKey: "valor") as! Decimal
        let textoTipo = entrada.value(forKey: "tipo") as? String
        
        cell.textLabel?.text = textoDescricao as? String
        cell.detailTextLabel?.text = currencyFormatter.string(from: decimalValor as NSNumber)
        
        if(textoTipo == "Crédito") {
            cell.textLabel?.textColor = UIColor.green
        } else {
            cell.textLabel?.textColor = UIColor.red
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let entrada = entradas[indexPath.row]
        
        self.performSegue(withIdentifier: "verEntrada", sender: entrada)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entrada = self.entradas[indexPath.row]
            
            self.context.delete(entrada)
            
            self.entradas.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
            } catch let erro {
                print("Erro ao remover o item \(erro.localizedDescription)")
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verEntrada" {
            let viewDestino = segue.destination as! ViewController
            
            viewDestino.entrada = sender as? NSManagedObject
        } else if segue.identifier == "verResultado" {
            let viewDestino = segue.destination as! ResultadoViewController
            var sumCredito: Decimal = 0.0
            var sumDebito: Decimal = 0.0
            var sumTotal: Decimal = 0.0
            
            entradas.forEach { (entrada) in
                let valor = entrada.value(forKey: "valor") as! Decimal
                if (entrada.value(forKey: "tipo") as! String == "Crédito") {
                    sumCredito += valor
                    sumTotal += valor
                } else {
                    sumDebito += valor
                    sumTotal -= valor
                }
            }
            
            viewDestino.credito = sumCredito
            viewDestino.debito = sumDebito
            viewDestino.total = sumTotal
        }
    }
}
