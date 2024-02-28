//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 30.01.22.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private var blurredEffectView: UIVisualEffectView!
    @IBOutlet private var loader: UIActivityIndicatorView!

    let viewModel = ForecastViewControllerModel()

    var errorView: ErrorView?


    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()

        viewModel.delegate = self

        setupTableView()


        viewModel.fetchWeatherForecast(latitude: viewModel.locationManager.lastLocation?.latitude, longitude: viewModel.locationManager.lastLocation?.longitude)

        if !viewModel.locationManager.hasLocationPermission {
            errorOccurred(errorDescription: WeatherError.noAccess.errorDescription, retryAction: viewModel.retryAction)
        }

    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ForecastTableCell", bundle: nil), forCellReuseIdentifier: "ForecastTableCell")
        tableView.register(ForecastTableViewSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ForecastTableViewSectionHeaderView.self))
    }

    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))

        navigationItem.leftBarButtonItem = refreshButton

    }
    @objc private func refreshData(sender: UIButton){
        blurredEffectView.isHidden = false
        loader.startAnimating()
        viewModel.fetchWeatherForecast(latitude: viewModel.locationManager.lastLocation?.latitude, longitude: viewModel.locationManager.lastLocation?.longitude)
    }

}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headerItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableCell", for: indexPath) as? ForecastTableCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.weatherItems[indexPath.section][indexPath.row])

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = ForecastTableViewSectionHeaderView(reuseIdentifier: String(describing: ForecastTableViewSectionHeaderView.self))

        sectionHeaderView.configure(with: viewModel.headerItems[section])
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45.0
    }

}

extension ForecastViewController: WeatherDataUpdatedDelegate {

    func errorOccurred(errorDescription: String, retryAction: (() -> ())?) {
        DispatchQueue.main.async {

            guard let view = Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)?.first as? ErrorView else {
                return
            }

            view.retryAction = retryAction

            self.errorView = view

            self.errorView?.translatesAutoresizingMaskIntoConstraints = false

            guard let errorView = self.errorView else {
                return
            }

            self.view.addSubview(errorView)

            NSLayoutConstraint.activate([
                errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])

            errorView.errorLabel.text = errorDescription

        }
    }

    func weatherInfoViewModelUpdated() {
        DispatchQueue.main.async {
            self.blurredEffectView.isHidden = false
            self.loader.startAnimating()
            self.tableView.reloadData()
            self.errorView?.removeFromSuperview()
            self.blurredEffectView.isHidden = true
            self.loader.stopAnimating()
        }
    }

}

