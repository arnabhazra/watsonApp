//
//  RecordAudio.swift
//  WatsonDemo
//
//  Created by Arnab Hazra on 5/16/16.
//  Copyright © 2016 Arnab. All rights reserved.
//

import UIKit
import WatsonDeveloperCloud
import AVFoundation
import Starscream
import Alamofire
import Freddy
import RestKit
import SpeechToTextV1
import AlchemyVisionV1
import NaturalLanguageClassifierV1
import LanguageTranslationV2
import ObjectMapper
import AlamofireObjectMapper
import ToneAnalyzerV3
import Charts

class RecordAudio: UIViewController, AVAudioRecorderDelegate {
    
    //outlets
    
    //   @IBOutlet weak var inputText: UITextView!
    
    @IBOutlet var trait: UIView!
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    @IBOutlet weak var submit: UIButton!
    
    
    @IBOutlet weak var showProcessing: UILabel!
    
    var audioString : String = ""
    var task : NSURLSessionDataTask!
    var audioRecorder:AVAudioRecorder!
    
    
    // @IBOutlet weak var secondTrait: UILabel!
    //  @IBOutlet weak var personalityLable: UILabel!
    
    //@IBOutlet weak var demoTrait: UILabel!
    
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // submit.enabled = false
        //  welcomeLabel.text = "Sentio gives users unprecedented visibility and control over emotional health leading to a happier, healthier and more productive life.";
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // actions
    
    override func viewDidAppear(animated: Bool) {
       // self.task?.cancel()
        
    }
    
    @IBAction func startSpeaking(sender: AnyObject) {
        
        let tts = TextToSpeech(username: "a936e340-e91e-441b-96f4-e5565398364b", password: "zMhgKgpKNP6l")
        tts.synthesize("My name is Watson") {
            
            data, error in
            
            if let audio = data {
                
                do {
                    self.player = try AVAudioPlayer(data: audio)
                    self.player!.play()
                } catch {
                    print("Couldn't create player.")
                }
                
            } else {
                print(error)
            }
            
        }
        
    }
    
    
    @IBAction func personalityAnalysis(sender: AnyObject) {
        
        let personalitInsight = PersonalityInsights(username: "9a0305c1-96a2-4d2b-9778-282d68ffc061", password: "lyli7NDTm2Oi");
        personalitInsight.getProfile("dummy text", acceptLanguage: nil, contentLanguage: nil, includeRaw: nil, completionHandler: {data, error in
            
            if data != nil {
                
                //     var json : Array!
                /*    self.personalityLable.textColor = UIColor.redColor();
                 self.secondTrait.textColor = UIColor.redColor();
                 var trait = result.tree?.children![0].children![0].name;
                 var percentage = result.tree?.children![0].children![0].percentage;
                 self.personalityLable.text = trait!+":\(percentage!)"
                 var perc = result.tree?.children![1].children![0].percentage;
                 self.secondTrait.text = (result.tree?.children![1].children![0].name)!
                 + ":\(perc!)" */
                // print(json)
            }
                
            else{
                
                print(error)
            }
            
            
        })}
    
    @IBAction func learnMoreTouched(sender: AnyObject) {
        
        //print("LM")
    }
    
    
    @IBAction func startRecordingAudio(sender: AnyObject) {
        self.showProcessing.text = "Processing..."
        self.submit.enabled = false
      //  recordAudio()
       let audioPath = NSBundle.mainBundle().pathForResource("SGB", ofType: "wav")!
        print(audioPath)
        let fileURL = NSURL.fileURLWithPath(audioPath)
        let speechToText = SpeechToText(username: "4acb8d94-bd6a-4559-9193-6d4b354300be", password: "KV58PdLri0E1")
        var settings = TranscriptionSettings(contentType: .WAV)
        settings.inactivityTimeout = 60
        settings.continuous = true
        // settings.interimResults = true
        let failure = { (error: NSError) in print(error) }
        //   speechToText.
        
        speechToText.transcribe(fileURL,
                                settings: settings,
                                failure: failure){
                                    results in if !results.isEmpty{
                                        for result in results
                                        {
                                            let str = result.alternatives.last?.transcript
                                            // print(str!)
                                            self.audioString += str!
                                        }
                                       // print(self.audioString)
                                        self.submit.enabled = true
                                        self.submit.setTitle("Submit", forState: .Normal)
                                        self.showProcessing.text=""
                                    }
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func analyzeTone(sender: AnyObject) {
        
       /*let endpoint = "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19&text="
         let sampleText = "if I had never dropped out I would have never dropped in on that calligraphy class and personal computers might not have the wonderful typography that they do of course it was impossible to connect the dots looking forward when I was in college but it was very very clear looking backwards ten years later again you can't connect the dots looking forward you can only connect them looking backwards so you have to trust that the dots will connect in your future you have to trust in something your gut destiny life karma whatever because believing that the dots will connect down the road give you the confidence to follow your heart even when it leads you off the well worn path"//"I am really excited to be working with Watson!"
         let username = "c2d4e690-0387-4111-b360-1794538ce708";
         let password = "nolOT6wpZ44w"
         // let version = "2016-05-19"
         let authString = username + ":" + password
         let authData = authString.dataUsingEncoding(NSASCIIStringEncoding)
         let authValue = "Basic " + authData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
         
         let toneUrl = endpoint + sampleText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
         let url = NSURL(string: toneUrl)
         //  let url = NSMutableURLRequest(string : toneUrl)
         
         let config = NSURLSessionConfiguration.defaultSessionConfiguration()
         config.HTTPAdditionalHeaders = ["Authorization" : authValue]
         //  config.HTTPAdditionalHeaders = ["Content-Type" : "application/json"]
         let session = NSURLSession(configuration: config)
         var json : AnyObject = ""
         var taskIsRunning = true;
          self.task = session.dataTaskWithURL(url!) {
         (let data, let response, let error) in
         if let httpResponse = response as? NSHTTPURLResponse {
         do {
            taskIsRunning = false
          //  self.task.cancel()
            self.performTransition(data!)
         
         }
         catch {
         print("Problem serialising JSON object")
         }
         }
       //  taskIsRunning = false
        // self.performTransition(data!)
         }
        if(taskIsRunning)
        {
         self.task.resume()
        }
        
        while (taskIsRunning) {
        sleep(1)
        }*/
        
        self.performTransition()
        
        
    }
    
 
    func  performTransition() -> Void {
        performSegueWithIdentifier("showReportSegue", sender: self.audioString)
    }
    
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //self.task.cancel()
        if(segue.identifier == "showReportSegue")
        {
           
            let reportVC = segue.destinationViewController as! ReportViewController
            
            reportVC.recordedAudioData = sender as! String
            
            
            
        }
    }
    
    func recordAudio()
    {
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try!
            session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
   
    
}