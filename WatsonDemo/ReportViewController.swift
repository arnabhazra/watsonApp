//
//  ReportViewController.swift
//  WatsonDemo
//
//  Created by Arnab Hazra on 6/7/16.
//  Copyright © 2016 Arnab. All rights reserved.
//

import UIKit
import PersonalityInsightsV2

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var passedData : AnyObject;
    var recordedAudioData: String!
    var toneNameArray = [String]()
    var toneScoreArray = [Double]()
    //Outlet
    
    
    @IBOutlet weak var tableViewForReport: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewForReport.estimatedRowHeight = 80.0
        self.tableViewForReport.rowHeight = UITableViewAutomaticDimension
        callToneAnalyzer()
        callPersonalityAnalysis()
      //  makeTableViewScrollable()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView
   
    func tableView(tableViewForReport: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toneNameArray.count
    
    }
    
    func tableView(tableViewForReport: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewForReport.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.labelTypeOne.text = toneNameArray[indexPath.row].stringByAppendingString(" : \(toneScoreArray[indexPath.row] * 100)%")
        
        return cell
        
    }
    
    // MARK: - ToneAnalyzer Call
    
    func callToneAnalyzer()-> Void{
      let endpoint = "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19&text="
        
        
        let sampleText = self.recordedAudioData //"I am really excited to be working with Watson!" // text for analyzing
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
        
        var task = session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                  //  print(json) -- raw JSON for services
                    if let jsonDict = json as? NSDictionary{
                        for(key,value) in jsonDict {
                            
                            
                            if let jsonDictInner = value as? NSDictionary{
                                
                                for toneCategory in jsonDictInner["tone_categories"] as! [Dictionary<String,AnyObject>]{
                                    
                                    
                                    print(toneCategory["category_name"]!)
                                    // print(toneCategory.values.count)
                                    // print(toneCategory["tones"]!)
                                    
                                    for toneName in toneCategory["tones"] as! [Dictionary<String,AnyObject>]{
                                        
                                        
                                         print(toneName["tone_name"]!)
                                         print(toneName["score"]!)
                                        
                                        // populating array
                                        self.toneNameArray.append(toneName["tone_name"] as! String)
                                        self.toneScoreArray.append(toneName["score"] as! Double)
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        taskIsRunning = false // for disabling thread
                        
                    }
                    
                } catch{
                    print("Problem serialising JSON object")
                    
                }
            }
        }
        if(taskIsRunning){
        task.resume()
        }
        while (taskIsRunning) {
            sleep(1)
        }
        
        //print("success")
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func  makeTableViewScrollable() -> Void {
        let indexPath = NSIndexPath(forRow: toneNameArray.count, inSection: 0)
        self.tableViewForReport.scrollToRowAtIndexPath(indexPath,
                                              atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    
    func callPersonalityAnalysis() -> Void {
        let personalityInsights = PersonalityInsights(username:"9f9c31a3-799e-421b-a51a-461abf39a118", password: "KcBHHLZ2KxCh")
        let failure = { (error: NSError) in print(error) }
        personalityInsights.getProfile(text: self.recordedAudioData, acceptLanguage: nil, contentLanguage: nil, includeRaw: true, failure: failure)  {
            
            results in 
                
            if  !(results.tree.children?.isEmpty)!{
              print(results.tree.children?.count)
                
                for result in results.tree.children! {
                    
                   // print("\(result.name) : \(result.percentage)")
                    
                    for innerResult in result.children! {
                        
                       // print("\(innerResult.category!) : \(innerResult.name) : \(innerResult.percentage!)")
                        for innerMostResult in innerResult.children!{
                            var percentage = innerMostResult.percentage! * 100
                            
                            
                            print("\(innerMostResult.category!) : \(innerMostResult.name) : \(percentage)")
                           // innerMostResult.children!.
                        }
                    }
                }
                
            }

            
            
            
        }
       
    }
    
}
