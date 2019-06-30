//
//  DetailsViewController.swift
//  Countries
//
//  Created by Rajaram Mohanty on 29/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: BaseViewController {

    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var country_name: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var callingcode: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var sub_region: UILabel!
    @IBOutlet weak var time_zone: UILabel!
    @IBOutlet weak var currencies: UILabel!
    @IBOutlet weak var languages: UILabel!
    
    let countriesDet:CountriesModel?
    
    private var disposeBag = DisposeBag()
    
    init(countriesModel: CountriesModel) {
        self.countriesDet = countriesModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Country Details"
        // Do any additional setup after loading the view.
        self.setUpDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func snapshotImage(for layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @IBAction func saveData(_ sender: Any) {
        if let countriesDet = countriesDet {
            CoreDataRequest.coreDataRequestShareInstant.addData(countriesData: countriesDet, completion: { (success) -> Void in
                if success {
                    CFacade.ux.alert("saved")
                } else {
                }
            })
        }
    }
    
    func setUpDetails() {
        guard let countriesDet = countriesDet else { return }
        let svgURL = countriesDet.flagUrl // URL(string: "https://restcountries.eu/data/vir.svg")!
        if (svgURL.lastPathComponent != "dza.svg"){
            weak var weakSelf = self
            let task = URLSession.shared.dataTask(with: svgURL, completionHandler: { (data, response, error) in
                if let data = data {
                    print(svgURL)
                    CALayer(SVGData: data) { (svgLayer) in
                        DispatchQueue.main.async {
                            svgLayer.resizeToFit(self.flagImgView.bounds)
                            weakSelf?.flagImgView.layer.addSublayer(svgLayer)
                            
                            let image = self.snapshotImage(for: self.flagImgView.layer)
                            weakSelf?.flagImgView.image = image
                        }
                    }
                }
                
            })
            task.resume()
        }
        
        if  let country_nameStr = countriesDet.country {
            country_name.text = "Country Name:- \(String(describing: country_nameStr))"
        }
        
        if  let capitalStr = countriesDet.capital {
            capital.text = "Capital Name:- \(String(describing: capitalStr))"
        }
        
        if  let regionStr = countriesDet.region {
            region.text = "Region Name:- \(String(describing: regionStr))"
        }
        
        if  let sub_regionStr = countriesDet.sub_region {
            sub_region.text = "Sub region Name:- \(String(describing: sub_regionStr))"
        }
        
        if  let currency = countriesDet.currencies[0]?.c_name {
            currencies.text = "Country currency:- \(String(describing: currency))"
        }
        
        if  let calling_code = countriesDet.callingcode?[0] {
            callingcode.text = "Calling code:- \(String(describing: calling_code))"
        }
        
        if  let timezone = countriesDet.time_zone?[0] {
            time_zone.text = "time zone:- \(String(describing: timezone))"
        }
        
        if  let _languages = countriesDet.languages[0]?.name {
            languages.text = "Country languages:- \(String(describing: _languages))"
        }
    }

}
