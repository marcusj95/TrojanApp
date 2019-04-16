//
//  ScannerViewController.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/8/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ScannerViewController: UIViewController, RedisCommsStoreDelegate {
    
    @IBOutlet weak var lineGraph: LineChartView!
    @IBOutlet weak var deviceNum: UILabel!
    @IBOutlet weak var portNum: UILabel!
    @IBOutlet weak var unixNum: UILabel!
    @IBOutlet weak var windowsNum: UILabel!
    @IBOutlet weak var coveringView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    var lineEntries: LineChartDataSet = LineChartDataSet(values: [], label: nil)
    var n = 4.0
    var portVal = 0
    var deviceVal = 0
    var unixVal = 0
    var windowsVal = 0
    var finished = false
    var done = false
    var scanData = ScanDataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RedisCommsStore.store?.delegate = self
        
        let color = UIColor(named: "Line Color")
        let colors = [color!]
        lineEntries.fillColor = color!
        lineEntries.circleColors = colors
        lineEntries.colors = colors
        
        let data = LineChartData(dataSet: lineEntries)
        
        lineGraph.data = data
        portNum.text = "0"
        deviceNum.text = "0"
        unixNum.text = "0"
        windowsNum.text = "0"
        activity.startAnimating()
        
        _ = RedisCommsStore.store?.publish(message: "hitme")
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        done = true
        RedisCommsStore.store?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        RedisCommsStore.store?.delegate = nil
    }
    
    func didReceiveRedisResponse(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: String]
            print(json.count)
            DispatchQueue.main.async {
                if !self.finished {
                    self.finished = true
                    self.activity.stopAnimating()
                    self.coveringView.removeFromSuperview()
                }
                if self.lineEntries.values.count >= 7 {
                    let _ = self.lineEntries.removeFirst()
                }
                self.lineEntries.values.append(ChartDataEntry(x: self.n, y: Double(json.count)))
                self.n += 1
                
                let color = UIColor(named: "Line Color")
                let colors = [color!]
                self.lineEntries.fillColor = color!
                self.lineEntries.circleColors = colors
                self.lineEntries.colors = colors
                
                let data = LineChartData(dataSet: self.lineEntries)
                
                self.lineGraph.data = data
                
                
                self.portVal = json.values.count
                self.portNum.text = String(self.portVal)
                
                self.deviceVal = json.count
                self.deviceNum.text = String(self.deviceVal)
                
                if json.count % 2 == 0 {
                    self.unixVal += 1
                    self.unixNum.text = String(self.unixVal)
                } else {
                    self.windowsVal += 1
                    self.windowsNum.text = String(self.windowsVal)
                }
            }
            if !done {
                _ = RedisCommsStore.store?.publish(message: "hitme")
            }
            
        } catch  {
            print("ooooof")
        }
    }
}
