//
//  TableCellView.swift
//  Countries
//
//  Created by Rajaram Mohanty on 29/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import UIKit
import SwiftSVG
import PocketSVG

class TableCellView: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var countryLab: UILabel!
    @IBOutlet weak var svgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var countriesModel: CountriesModel? {
        didSet {
            guard let countriesModel = countriesModel else { return }
            self.countryLab?.text = countriesModel.country
            let svgURL = /*countriesModel.flagUrl*/ URL(string: "https://restcountries.eu/data/vir.svg")!
//            print(svgURL.lastPathComponent)
            if (svgURL.lastPathComponent != "dza.svg"){
                let task = URLSession.shared.dataTask(with: svgURL, completionHandler: { (data, response, error) in
                    if let data = data {
                        print(svgURL)
                        CALayer(SVGData: data) { (svgLayer) in
                            DispatchQueue.main.async {
                                svgLayer.resizeToFit(self.svgView.bounds)
                                self.svgView.layer.addSublayer(svgLayer)
                            }
                        }
                    }
                    
                })
                task.resume()
            }
            
            
        }
    }
}
