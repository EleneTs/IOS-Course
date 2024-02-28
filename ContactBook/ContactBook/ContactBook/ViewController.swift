//
//  ViewController.swift
//  ContactBook
//
//  Created by Elene Tsiramua on 28.12.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var id: Int = 1

    @IBOutlet private var tableView: UITableView!

    private var favoriteContacts: [String: [Contact]] = [:]
    private var contacts : [String: [Contact]] = ["T": [Contact(name: "Elene", lastName: "Tsiramua", number: "999999999", uniqueId: 0)]]

    private var isFavoritesSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")

        title = "Contacts"

        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let favorites = UIBarButtonItem(image: UIImage.init(systemName: "star"), style: .plain, target: self, action: #selector(favoritesTapped))

        navigationItem.rightBarButtonItem = add
        navigationItem.leftBarButtonItem = favorites
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return isFavoritesSelected ? favoriteContacts.count : contacts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currContactsDictionary = isFavoritesSelected ? favoriteContacts : contacts
        let key = currContactsDictionary.keys.sorted { $0 < $1 }[section]
        return currContactsDictionary[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let currContactsDictionary = isFavoritesSelected ? favoriteContacts : contacts

        let key = currContactsDictionary.keys.sorted { $0 < $1 }[indexPath.section]
        let value = currContactsDictionary[key]?[indexPath.row]
        cell.name.text = value?.name
        cell.lastName.text = value?.lastName
        cell.favoriteButton.tag = value?.uniqueId ?? 0

        let image = value?.isFavorite ?? false ? "star.fill": "star"
        cell.favoriteButton.setImage(UIImage(systemName: image), for: .normal)
        cell.favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currContactsDictionary = isFavoritesSelected ? favoriteContacts : contacts

        let key = currContactsDictionary.keys.sorted { $0 < $1 }[section]

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.text = key
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.font = .boldSystemFont(ofSize: 20.0)
        label.textColor = .black

        headerView.backgroundColor = UIColor(red: CGFloat(211/255.0), green: CGFloat(211/255.0), blue: CGFloat(211/255.0), alpha: CGFloat(1.0) )

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard !isFavoritesSelected else {
            return
        }

        if editingStyle == .delete {
            let key = contacts.keys.sorted { $0 < $1 }[indexPath.section]
            guard let value = contacts[key]?[indexPath.row] else {
                return
            }

            if value.isFavorite {
                let list = favoriteContacts[key]?.filter { $0.uniqueId != value.uniqueId }
                favoriteContacts[key] = list?.isEmpty ?? true ? nil : list
            }

            if contacts[key]?.count == 1 {
                contacts[key] = nil
            } else {
                contacts[key]?.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }

    @objc private func addTapped(sender: UIButton){
        showAlertWithTextField()
    }

    @objc private func favoritesTapped(sender: UIButton){

        let image = isFavoritesSelected ? "star": "star.fill"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: image), style: .plain, target: self, action: #selector(favoritesTapped))

        isFavoritesSelected.toggle()
        tableView.reloadData()

    }

    @objc private func toggleFavorite(sender: UIButton){
        contacts.forEach { (key, value) in
            guard let value = (value.first { $0.uniqueId == sender.tag }) else { return }
            value.isFavorite.toggle()
            if value.isFavorite {
                if favoriteContacts[key] == nil {
                    favoriteContacts[key] = [value]
                } else {
                    favoriteContacts[key]?.append(value)
                }
            } else {
                let list = favoriteContacts[key]?.filter {$0.uniqueId != sender.tag}
                favoriteContacts[key] = list?.isEmpty ?? true ? nil : list
            }

        }
        tableView.reloadData()
    }

    private func showAlertWithTextField() {
        let alertController = UIAlertController(title: "New contact", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            var name: String?
            var lastName: String?
            var number: String?
            alertController.textFields?.forEach({ textField in
                switch textField.tag {
                case 0:
                    name = textField.text
                case 1:
                    lastName = textField.text
                case 2:
                    number = textField.text
                default:
                    break
                }
            })

            guard let name = name, let number = number else {
                return
            }
            var section: String

            if let lastName = lastName {
                section = String(lastName.prefix(1)).uppercased()
            } else {
                section = String(name.prefix(1)).uppercased()
            }

            let contact = Contact(name: name, lastName: lastName, number: number, uniqueId: self?.id)
            self?.id += 1

            if self?.contacts[section] == nil {
                self?.contacts[section] = [contact]
            } else {
                self?.contacts[section]?.append(contact)
            }

            self?.contacts[section]?.sort { contactOne, contactTwo in
                contactOne.lastName ?? contactOne.name < contactTwo.lastName ?? contactTwo.name
            }

            self?.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "First name"
            textField.tag = 0
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Last name"
            textField.tag = 1
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone number"
            textField.keyboardType = .phonePad
            textField.tag = 2
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

class Contact {
    var name: String
    var lastName: String?
    var number: String
    var uniqueId: Int?

    var isFavorite: Bool = false

    init(name: String, lastName: String? = nil, number: String, uniqueId: Int?) {
        self.name = name
        self.lastName = lastName
        self.number = number
        self.uniqueId = uniqueId
    }
}




