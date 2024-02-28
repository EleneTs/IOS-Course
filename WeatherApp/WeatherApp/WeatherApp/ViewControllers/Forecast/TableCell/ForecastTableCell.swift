//
//  ForecastTableCell.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import UIKit

class ForecastTableCell: UITableViewCell {

    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var timeLable: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var tempratureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ForecastTableCell: ForecastTableViewCellConfigurable {

    func configure(with content: ForecastTableViewCellContent) {
        timeLable.text = content.timeLabelText
        weatherDescription.text = content.weatherDescriptionText
        tempratureLabel.text = content.temperatureValue
        guard let icon = content.weatherIcon else {
            return
        }
        weatherIcon.download(from: icon)
    }


}
