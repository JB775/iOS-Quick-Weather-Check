//
//  ViewController.swift
//  Quick Weather
//
//  Created by jbergandino on 3/19/16.
//  Copyright © 2016 gotrackingtechnologies. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var forecastTitle: UILabel!
    @IBOutlet weak var forecastText: UITextView!
    @IBOutlet weak var insertCityTextView: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBAction func submitButton(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + insertCityTextView.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")  + "/forecasts/latest")
        
        if let url = attemptedUrl {
            
            //define a URL session
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    //set to string with the correct type of encoding
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    //print(webContent)
                    let websiteContentArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    //Make sure the following code doesn't run unless expected html content is found by doing the following if statement
                    if websiteContentArray!.count > 1 {
                        
                        
                        
                        //trim the part of the string after what you want
                        let weatherArray = websiteContentArray![1].componentsSeparatedByString("</span>")
                        
                        //make sure nothing went wrong with splitting array string
                        if weatherArray.count > 1 {
                            
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                            print(weatherSummary)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                //self.webView.loadHTMLString(String(webContent), baseURL: nil)
                                self.weatherLabel.text = weatherSummary
                            })
                            
                        }
                        
                    } else {
                        if wasSuccessful == false {
                            self.weatherLabel.text = "Couldn't find the weather for that city, please try again."
                            print("Oops")
                        }
                    }
                    
                }
            }
            
            task.resume()
        } else {
            self.weatherLabel.text = "Couldn't find the weather for that city, please try again."
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

