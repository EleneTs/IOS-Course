//
//  ForecastHeader.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import UIKit

protocol ForecastHeader {

    var title: String { get set }

}

protocol ForecastHeaderConfigurable {

    func configure(with content: ForecastHeader)

}

class ForecastTableViewSectionHeaderView: UITableViewHeaderFooterView {

    var titleLabel = UILabel(frame: .zero)
    var backView = UIView(frame: .zero)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }


    private func setupViews() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1).cgColor

        addSubview(backView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .darkGray

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30.0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

}

extension ForecastTableViewSectionHeaderView: ForecastHeaderConfigurable {

    func configure(with content: ForecastHeader) {

        titleLabel.text = content.title.uppercased()

    }

}
