import UIKit

class ViewController: UIViewController {
    
    let lenPassword = 3
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var activiti: UIActivityIndicatorView!
    
    @IBOutlet weak var generateButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelBut(_ sender: Any) {
        label.text = ""
        textField.text = ""
    }
    
    @IBAction func searchBut(_ sender: Any) {
        self.bruteForce(passwordToUnlock: textField.text ?? "")
        label.text = textField.text
        activiti.hidesWhenStopped = true
        activiti.stopAnimating()
        textField.isSecureTextEntry = false
    }
    
    @IBAction func onBut(_ sender: Any) {
        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let randomPassword = String((0..<lenPassword).map{ _ in passwordCharacters[Int(arc4random_uniform(UInt32(passwordCharacters.count)))]})
        textField.text = randomPassword
        textField.isSecureTextEntry = true
//        activiti.startAnimating()
        label.text = "Password generated"
        print(randomPassword)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activiti.hidesWhenStopped = true
        
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        while password != passwordToUnlock {
        
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            
            print(password)
            
        }
    
        print(password)
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
    : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string
    
    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    
    return str
}

