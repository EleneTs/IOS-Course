//
//  UIImageView.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 4.02.22.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func download(from iconUrl: String) {
        let url = URL(string: "https://openweathermap.org/img/wn/" + iconUrl + ".png")
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority) { _,_,_ in
        } completed : { image, data, error, cacheType, finished, url in
            if finished{
                if image != nil {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
