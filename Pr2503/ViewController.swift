import UIKit

class ViewController: UIViewController {
    
    let lenPassword = 3
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activiti: UIActivityIndicatorView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBAction func cancelBut(_ sender: Any) {
        label.text = ""
        textField.text = ""
        activiti.stopAnimating()
        passwordLabel.text = ""
    }
    
    @IBAction func eye(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
    }

    @IBAction func searchBut(_ sender: Any) {
        activiti.startAnimating()
        label.text = "Wait"
        bruteForce(passwordToUnlock: textField.text ?? "", completion: { [weak self] password in
            self?.label.text = "Password found"
            self?.activiti.stopAnimating()
            self?.textField.isSecureTextEntry = false
        })
    }
    
    @IBAction func onBut(_ sender: Any) {
        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let randomPassword = String((0..<lenPassword).map{ _ in passwordCharacters[Int(arc4random_uniform(UInt32(passwordCharacters.count)))]})
        textField.text = randomPassword
        textField.isSecureTextEntry = true
        label.text = "Password generated"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activiti.hidesWhenStopped = true
    }
    
    func shouPassword(password: String) {
        passwordLabel.text = password
    }
    
    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void) {
        
        let queue = DispatchQueue(label: "OneQueue")
     
        queue.async {
           
            let allowedCharacters: [String] = String().printable.map { String($0) }
            var password: String = ""
            
            while password != passwordToUnlock {
                
                password = generateBruteForce(password, fromArray: allowedCharacters)
                
                DispatchQueue.main.async {
                    self.shouPassword(password: password)
                }
            }
            
            DispatchQueue.main.async {
                completion(password)
               
            }
        }
    }
}

