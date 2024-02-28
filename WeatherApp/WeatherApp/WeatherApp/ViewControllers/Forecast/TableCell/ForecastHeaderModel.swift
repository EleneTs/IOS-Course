//
//  ForecastHeaderModel.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import Foundation

struct ForecastHeaderViewModel: ForecastHeader {

    var title: String

    init(item: List) {

        title = Date.from(string: item.dt_txt)?.weekday ?? ""

    }
}

extension ForecastHeaderViewModel: Equatable {

    static func == (lhs: ForecastHeaderViewModel, rhs: ForecastHeaderViewModel) -> Bool {
        return lhs.title == rhs.title
    }

}
