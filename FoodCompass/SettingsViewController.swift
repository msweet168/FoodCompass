//
//  SettingsViewController.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/3/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var unitsPickerView: UIPickerView!
    @IBOutlet weak var rangeStepper: UIStepper!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var showClosedToggle: UISwitch!
    
    // MARK: Constants
    public static let storyboardID = "settingVC"

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.title = StringManager.Settings.settings
        
        unitsLabel.text = StringManager.Settings.units
        radiusLabel.text = StringManager.Settings.radius
        infoLabel.text = StringManager.Settings.copyright
    }
    
    func updateSettingsPage() {
        let radius = SettingsManager.convertedRadius
        rangeStepper.value = Double(SettingsManager.radius)
        unitsPickerView.selectRow(SettingsManager.units == .imperial ? 0 : 1, inComponent: 0, animated: false)
        distanceLabel.text = "\(radius) \(SettingsManager.units == .imperial ? StringManager.Settings.miles : StringManager.Settings.kilometers)"
        showClosedToggle.setOn(SettingsManager.showClosed, animated: false)
    }

    @IBAction func stepperChangedValue(sender: UIStepper) {
        SettingsManager.radius = Int(sender.value)
        updateSettingsPage()
    }

    @IBAction func showClosedSwitchToggled(sender: UISwitch) {
        SettingsManager.showClosed = sender.isOn
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerViewSetup() {
        unitsPickerView.delegate = self
        unitsPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return UnitType.allCases.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard component == 0 else { fatalError("ERROR: Too many components in picker view.") }
        
        switch row {
        case 0: return StringManager.Settings.imperial
        case 1: return StringManager.Settings.metric
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0: SettingsManager.units = .imperial
        case 1: SettingsManager.units = .metric
        default: SettingsManager.units = .imperial
        }
        updateSettingsPage()
    }
}
