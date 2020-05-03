//
//  ViewController.swift
//  Encryption
//
//  Created by Kunal Kumar on 2020-05-02.
//  Copyright © 2020 KD inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var fifth: UILabel!
    
    @IBAction func didTapUpdate(_: UIButton) {
        self.performUpdates()
    }
    //Variables to store both the public and private keys.
    var publicKeySec, privateKeySec: SecKey?
    
    var encryptedString: String = ""
    var base64EncryptedData: Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performUpdates()
        // Do any additional setup after loading the view.
    }
    
    func performUpdates() {
         self.generateKeys()
         self.encryptMessage()
         self.decryptMessage()
    }

    func generateKeys() {
        /*
         kSecAttrCanDecrypt: A key whose value indicates that the cryptographic private key can be used for decryption.
         kSecAttrIsPermanent: A key whose value is a boolean. If true, it indicates that the cryptographic key should be stored in the default keychain at creation time.
         kSecAttrApplicationTag: A key whose value is an attribute with a unique NSData value so that you can find and retrieve the private key later on from the key chain. It’s constructed from a string and preferable to be in reverse DNS notation.
        */
        let privateKeyTag = "com.test.example".data(using: .utf8)!
        let privateKeyParams: [String: Any] = [
        kSecAttrCanDecrypt as String: true,
        kSecAttrIsPermanent as String: true,
        kSecAttrApplicationTag as String: privateKeyTag]
        
        /*
         
         kSecAttrKeyType: A key whose value indicates the type of cryptography algorithm used to produce the key pair (public and private keys). Set to elliptic curve algorithm (ECC).
         kSecAttrKeySizeInBits: A key whose value indicates the size of the generated key pair. Set to 256 bits.
         kSecPrivateKeyAttrs: A key whose value is set to the created sub-dictionary that does contain the specifications of the private key.
         
         */
        
        let attributes =
        [kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecPrivateKeyAttrs as String:
        privateKeyParams] as CFDictionary
        
        /*Second thing is to call the SecKeyGeneratePair API to generate the public and private keys using the created attributes dictionary.
        Generating both the public and private keys via the SecGeneratePair APIs.
         */
        SecKeyGeneratePair(attributes, &publicKeySec, &privateKeySec)
    }
    
    func encryptMessage() {
        
        /*
         The steps for generating an encrypted string are as follows:-
         Set/Get the message to be encrypted.
         Set the message to be of type Data.
         Utilize the SecKeyCreateEncryptedData security API to encrypt the message data. You pass public key and the encryption algorithm (SecKeyAlgorithm) for it to be utilized.
         */
        
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        self.first.text = "Message is : \(message)"
        guard let messageData = message.data(using: String.Encoding.utf8) else {
            print("Bad message to encrypt")
            return
        }
        
        guard let encryptData = SecKeyCreateEncryptedData(
            self.publicKeySec!,
            SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM,
            messageData as CFData,
            nil) else {
                print("Encryption Error")
                return
        }
        
        if let data = encryptData as? Data {
            self.encryptedString = (data as NSData).base64EncodedString()
            self.base64EncryptedData = Data(base64Encoded: self.encryptedString) ?? Data()
            print(self.encryptedString)
        }        
        self.second.text = "Encrypted Data is: \(self.encryptedString)"
        
    }
    
    func decryptMessage() {
        
        guard let messageData = Data(base64Encoded: self.encryptedString) else {
            print("Bad message to decrypt")
            return
        }
        
        guard let decryptData = SecKeyCreateDecryptedData(
            self.privateKeySec!,
            SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM,
            messageData as CFData,
            nil) else {
                print("Decryption Error")
                return
        }
        
        let decryptedData = decryptData as Data
        guard let decryptedString = String(data: decryptedData, encoding: String.Encoding.utf8) else {
            print("Error retrieving string")
            return
        }
        self.third.text = "Decrypted String: \(decryptedString)"
        self.fourth.text = "Private Key: \(String(describing: self.privateKeySec))"
        self.fifth.text = "Private Key: \(String(describing: self.publicKeySec))"
    }
    

}

