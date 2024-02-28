//
//  ViewController.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 30.01.22.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!

    @IBOutlet var weatherDetails: [UILabel]!

    @IBOutlet private var blurredEffectView: UIVisualEffectView!
    @IBOutlet private var loader: UIActivityIndicatorView!

    let viewModel = CurrentWeatherViewControllerModel()

    var errorView: ErrorView?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        viewModel.delegate = self


        viewModel.fetchCurrentWeather(latitude: viewModel.locationManager.lastLocation?.latitude, longitude: viewModel.locationManager.lastLocation?.longitude)

        if !viewModel.locationManager.hasLocationPermission {
            errorOccurred(errorDescription: WeatherError.noAccess.errorDescription, retryAction: viewModel.retryAction)
        }

    }


    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))

        navigationItem.leftBarButtonItem = refreshButton

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareData))

        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.isEnabled = false

    }
    @objc private func shareData(sender: UIButton){
        let image = weatherIcon.image
        let ac = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
        present(ac, animated: true)
    }

    @objc private func refreshData(sender: UIButton){
        navigationItem.rightBarButtonItem?.isEnabled = false

        blurredEffectView.isHidden = false
        loader.startAnimating()
        viewModel.fetchCurrentWeather(latitude: viewModel.locationManager.lastLocation?.latitude, longitude: viewModel.locationManager.lastLocation?.longitude)

    }

    private func setData() {
        weatherIcon.download(from: viewModel.weatherContent?.weatherIcon ?? "")
        locationLabel.text = viewModel.weatherContent?.locationLabel
        weatherDescriptionLabel.text = viewModel.weatherContent?.weatherDescriptionLabel
        var index = 0
        viewModel.weatherContent?.weatherDetails.forEach({ (detail) in
            weatherDetails[index].text = detail
            index += 1
        })
    }


}

extension CurrentWeatherViewController : WeatherDataUpdatedDelegate {
    func weatherInfoViewModelUpdated() {
        DispatchQueue.main.async {
            self.blurredEffectView.isHidden = false
            self.loader.startAnimating()
            self.setData()
            self.errorView?.removeFromSuperview()
            self.blurredEffectView.isHidden = true
            self.loader.stopAnimating()
            self.navigationItem.rightBarButtonItem?.isEnabled = true

        }
    }


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



    
}

