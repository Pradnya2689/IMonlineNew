//
//  CountrySearchViewController.swift
//  IMOnline
//
//  Created by Administrator on 06/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Speech

class CountrySearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,SFSpeechRecognizerDelegate {
    @IBOutlet weak var countrySearchTableView: UITableView!
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var isCall : String = ""
    
    var countryNameAAray : NSMutableArray! = ["AUSTRALIA","CROATIA","ENGLAND","FRANCE","ICELAND","JORDAN"]
    var countryNameAAray1 : NSMutableArray! = ["AUSTRALIA","CROATIA","ENGLAND","FRANCE","ICELAND","JORDAN"]
    var flagArray = ["Australia","Croatia","England","France","Iceland","Jordan"]
    
    @IBAction func micBtnAction(_ sender: UIButton) {
        
//        if audioEngine.isRunning{
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            micButton.isEnabled = false
//            //micBtn.setTitle("Start Recording", for: .normal)
//        }else{
          //  startRecording()
            //micBtn.setTitle("Stop Recording", for: .normal)
        //}
    }
    
//    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: Selector(("textFieldDidChange11")), for: UIControlEvents.allEditingEvents)

        WebServiceManager.sharedInstance.fetchCountries(withCompletionBlock: {(_ _countries: [Any]) -> Void in
            print(_countries)
        }, failedBlock: {() -> Void in
        })

        
        
        // Do any additional setup after loading the view.
        
        micButton.isEnabled = false
        
      //  speechRecognizer?.delegate = self
        
//        SFSpeechRecognizer.requestAuthorization{ (authStatus) in
//            
//            var isButtonEnabled = false
//            
//            switch authStatus{
//                
//            case .authorized:
//                isButtonEnabled = true
//                
//            case .denied:
//                isButtonEnabled = false
//                print("User denied access to speech recognition")
//                
//            case .restricted:
//                isButtonEnabled = false
//                print("Speech recognition restricted on this device")
//                
//            case .notDetermined:
//                isButtonEnabled = false
//                print("Speech recognition not yet authorized")
//                
//            }
//            
//            OperationQueue.main.addOperation {
//                self.micButton.isEnabled = isButtonEnabled
//            }
//            
//        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    
   // MARK: - Microphone Function
    
//    func startRecording() {
//        
////        if recognitionTask != nil {
////            recognitionTask?.cancel()
////            recognitionTask = nil
////        }
//        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryRecord)
//            try audioSession.setMode(AVAudioSessionModeMeasurement)
//            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
//        } catch {
//            print("audioSession properties weren't set because of an error.")
//        }
//        
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        
//        guard let inputNode = audioEngine.inputNode else {
//            fatalError("Audio engine has no input node")
//        }
//        
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
//        }
//        
//        recognitionRequest.shouldReportPartialResults = true
//        
//        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
//            
//            var isFinal = false
//            
////            if result != nil {
////                
////                self.searchTextField.text = result?.bestTranscription.formattedString
////                isFinal = (result?.isFinal)!
////                
////                self.textFieldDidChangeSiri()
////                
////            }
////            
////            
////            if error != nil || isFinal {
////                self.audioEngine.stop()
////                inputNode.removeTap(onBus: 0)
////                
////                self.recognitionRequest = nil
////                self.recognitionTask = nil
////                
////                self.micButton.isEnabled = true
////            }
//            
//            
//            if result != nil {
//                
//                self.searchTextField.text = result?.bestTranscription.formattedString
//                
////                self.cancelRecording()
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
//                self.micButton.isEnabled = true
//                
//                self.textFieldDidChangeSiri()
//                                
//            }
//
//            
//            
//        })
//        
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
//            self.recognitionRequest?.append(buffer)
//        }
//        
//        audioEngine.prepare()
//        
//        do {
//            try audioEngine.start()
//        } catch {
//            print("audioEngine couldn't start because of an error.")
//        }
//        
//        searchTextField.text = "Say something, I'm listening!"
//        
//    }
    
    
//    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            micButton.isEnabled = true
//        } else {
//            micButton.isEnabled = false
//        }
//    }
    
    
    
    
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
