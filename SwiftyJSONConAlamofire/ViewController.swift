import UIKit
import SwiftyJSON
import Alamofire

struct Users {
    var nombre : String
    var email : String
    var calle : String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lista = [Users]()
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //datosLocal()
        tabla.delegate = self
        tabla.dataSource = self
        datosWeb()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CeldaTableViewCell
        let list = lista[indexPath.row]
        cell.nombreLabel.text = list.nombre
        cell.emailLabel.text = list.email
        cell.calleLabel.text = list.calle
        return cell
    }
    
    func datosWeb(){
        
        DispatchQueue.main.async {
            Alamofire.request("https://jsonplaceholder.typicode.com/users").responseJSON(completionHandler: { (resultado) in
                switch resultado.result{
                case .success(let value):
                    let json = JSON(value)
                    //print(json)
                    /*
                     let nombre = json[0]["name"]
                     let email = json[0]["email"]
                     let calle = json[0]["address"]["street"]
                     let lat = json[0]["address"]["geo"]["lat"]
                     print(nombre, email, calle, lat)
                     for item in json.array! {
                     let nombre = item["name"]
                     let email = item["email"]
                     print(nombre, email)
                     }
                     */
                    for item in json.array! {
                        let nombre = item["name"].stringValue
                        let email = item["email"].stringValue
                        let calle = item["address"]["street"].stringValue
                        let usuarios = Users(nombre: nombre, email: email, calle: calle)
                        self.lista.append(usuarios)
                    }
                    self.tabla.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        
    }
    
    func datosLocal(){
        
        if let file = Bundle.main.path(forResource: "api", ofType: "json"){
            let datos = try? Data(contentsOf: URL(fileURLWithPath: file))
            let json = try? JSON(data: datos!)
            //print(json!)
            /*
             let nombre = json![0]["name"]
             let email = json![0]["email"]
             let calle = json![0]["address"]["street"]
             let lat = json![0]["address"]["geo"]["lat"]
             print(nombre, email, calle, lat)
             */
            for item in (json?.array)! {
                let nombre = item["name"]
                let email = item["email"]
                print(nombre, email)
            }
        }else{
            print("fallo")
        }
        
    }
    
}
