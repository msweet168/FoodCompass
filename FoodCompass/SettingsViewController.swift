//
//  SettingsViewController.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/3/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var unitsPickerView: UIPickerView!
    @IBOutlet weak var rangeStepper: UIStepper!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    
    // MARK: Constants
    public static let storyboardID = "settingVC"

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localization()
        viewSetup()
        pickerViewSetup()
        updateSettingsPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func viewSetup() {
        self.navigationController?.navigationBar.tintColor = .themeRed
        self.title = "Settings"
    }
    
    func localization() {
        unitsLabel.text = localize(str: "Units")
        radiusLabel.text = localize(str: "Radius")
    }
    
    func pickerViewSetup() {
        unitsPickerView.delegate = self
        unitsPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return localize(str: "Imperial")
            } else if row == 1 {
                return localize(str: "Metric")
            } else {
                fatalError("ERROR: Too many rows in picker view.")
            }
        } else {
            fatalError("ERROR: Too many components in picker view.")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            SettingsManager.uints = .imperial
        } else if row == 1 {
            SettingsManager.uints = .metric
        }
        updateSettingsPage()
    }
    
    func updateSettingsPage() {
        let radius = SettingsManager.convertedRadius
        if SettingsManager.uints == .imperial {
            unitsPickerView.selectRow(0, inComponent: 0, animated: false)
            distanceLabel.text = "\(radius) \(localize(str: "Miles"))"
        } else {
            unitsPickerView.selectRow(1, inComponent: 0, animated: false)
            distanceLabel.text = "\(radius) \(localize(str: "Kilometers"))"
        }
        rangeStepper.value = Double(SettingsManager.radius)
    }

    @IBAction func stepperChangedValue(sender: UIStepper) {
        SettingsManager.radius = Int(sender.value)
        updateSettingsPage()
    }
}
