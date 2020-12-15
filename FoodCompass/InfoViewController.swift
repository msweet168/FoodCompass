//
//  InfoViewController.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/3/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appInfoLabel: UILabel!
    
    public static let storyboardID = "InfoVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = localize(str: "Information")
        self.descriptionLabel.text = localize(str: "Info_Paragraph_Key")
        self.appInfoLabel.text = localize(str: "Copyright_key")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .themeRed
        self.navigationController?.navigationBar.isHidden = false
    }
}
