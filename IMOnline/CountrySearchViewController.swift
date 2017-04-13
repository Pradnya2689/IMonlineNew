//
//  CountrySearchViewController.swift
//  IMOnline
//
//  Created by Administrator on 06/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Speech

@available(iOS 10.0, *)
class siriRecogn: NSObject , SFSpeechRecognizerDelegate{
    
    static let sharedInstance = siriRecogn()
    
     let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
     var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
     var recognitionTask: SFSpeechRecognitionTask?
     let audioEngine = AVAudioEngine()
    
}


class CountrySearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,SFSpeechRecognizerDelegate {
    @IBOutlet weak var countrySearchTableView: UITableView!
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var isCall : String = ""
    
    var countryNameAAray : NSMutableArray! = ["AUSTRALIA","CROATIA","ENGLAND","FRANCE","ICELAND","JORDAN"]
    var countryNameAAray1 : NSMutableArray! = ["AUSTRALIA","CROATIA","ENGLAND","FRANCE","ICELAND","JORDAN"]
    var flagArray = ["Australia","Croatia","England","France","Iceland","Jordan"]
    


    @IBAction func micBtnAction(_ sender: UIButton) {

        if #available(iOS 10.0, *){
            
             startRecording()
        }
    }
    
    var isEnab : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: Selector(("textFieldDidChange11")), for: UIControlEvents.allEditingEvents)

        // Do any additional setup after loading the view.
        
        
        if #available(iOS 10.0, *) {
            
            siriRecogn.sharedInstance.speechRecognizer?.delegate = self
            
            
            SFSpeechRecognizer.requestAuthorization{ (authStatus) in
                
                self.isEnab = false
                
                switch authStatus{
                    
                case .authorized:
                    self.isEnab = true
                    
                case .denied:
                    self.isEnab = false
                    print("User denied access to speech recognition")
                    
                    
                case .restricted:
                    self.isEnab = false
                    print("Speech recognition restricted on this device")
                    
                    
                case .notDetermined:
                    self.isEnab = false
                    print("Speech recognition not yet authorized")
         
                }
                
                OperationQueue.main.addOperation {
                    self.micButton.isEnabled = self.isEnab
                }
            }
        }else {
            // Fallback on earlier versions
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    
   // MARK: - Microphone Function
    
    func startRecording() {
        if #available(iOS 10.0, *){
            
            if siriRecogn.sharedInstance.recognitionTask != nil {
                siriRecogn.sharedInstance.recognitionTask?.cancel()
                siriRecogn.sharedInstance.recognitionTask = nil
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryRecord)
                try audioSession.setMode(AVAudioSessionModeMeasurement)
                try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            
            siriRecogn.sharedInstance.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let inputNode = siriRecogn.sharedInstance.audioEngine.inputNode else {
                fatalError("Audio engine has no input node")
            }
            
            guard  let recognitionRequest = siriRecogn.sharedInstance.recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }
            
            siriRecogn.sharedInstance.recognitionRequest?.shouldReportPartialResults = true
            
            siriRecogn.sharedInstance.recognitionTask = siriRecogn.sharedInstance.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                if result != nil {
                    
                    self.searchTextField.text  = result?.bestTranscription.formattedString
                    
                    siriRecogn.sharedInstance.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    siriRecogn.sharedInstance.recognitionRequest = nil
                    siriRecogn.sharedInstance.recognitionTask = nil
                    self.micButton.isEnabled = true
                    
                    
                    self.textFieldDidChangeSiri()
                }
                
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                siriRecogn.sharedInstance.recognitionRequest?.append(buffer)
            }
            
            siriRecogn.sharedInstance.audioEngine.prepare()
            
            do {
                try siriRecogn.sharedInstance.audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            searchTextField.text = "Say something, I'm listening!"
            
        }else{
            
        }
    }
    
    
    @available(iOS 10.0, *)
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            micButton.isEnabled = true
        } else {
            micButton.isEnabled = false
        }
    }
    
    
    
    
    // MARK: - Tableview Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryNameAAray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrySearchCellId", for: indexPath) as! CountrySearchTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.flagImgView.image = UIImage(named: flagArray[indexPath.row])
        cell.countryNameLB.text = countryNameAAray[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(countryNameAAray[indexPath.row])
        if(isCall == "SplashView"){
            
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! ViewController
            self.navigationController?.pushViewController(nextView, animated: true)
            
        }else{
            
             self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    func textFieldDidChange11() {
        if((searchTextField.text?.characters.count)! > 0){
            let searchpredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchTextField.text!)
            //filterArray = NSArray()
            countryNameAAray.filter(using: searchpredicate)
            
            
            self.countrySearchTableView.reloadData()
        }else{
            countryNameAAray.removeAllObjects()
            countryNameAAray = self.countryNameAAray1.mutableCopy() as! NSMutableArray
            self.countrySearchTableView.reloadData()
        }
        
        //return true
    }
    
    func textFieldDidChangeSiri() {
        
        if((searchTextField.text?.characters.count)! > 0){
            var searchString = searchTextField.text?.uppercased()
            let searchpredicate = NSPredicate(format: "SELF == %@", searchString!) //ANY keywords.name LIKE[c]
            //filterArray = NSArray()
            countryNameAAray.filter(using: searchpredicate)
            print(countryNameAAray)
            print(countryNameAAray.count)
            if(countryNameAAray.count == 1){
                
                if(isCall == "SplashView"){
                
                let nextView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! ViewController
                self.navigationController?.pushViewController(nextView, animated: true)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                 countryNameAAray = self.countryNameAAray1.mutableCopy() as! NSMutableArray
                let searchpredicate = NSPredicate(format: "SELF CONTAINS %@", searchString!) //ANY keywords.name LIKE[c]
                //filterArray = NSArray()
                countryNameAAray.filter(using: searchpredicate)
                
            self.countrySearchTableView.reloadData()
            }
        }else{
            countryNameAAray.removeAllObjects()
            countryNameAAray = self.countryNameAAray1.mutableCopy() as! NSMutableArray
            self.countrySearchTableView.reloadData()
        }
        
        //return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
