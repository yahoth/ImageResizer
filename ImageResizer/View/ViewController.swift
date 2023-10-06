//
//  ViewController.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 2023/10/03.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let vm: ViewModel = ViewModel()

    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
//
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        bind()
        setNavigationBar()
        setConstraint()
    }

    func setConstraint() {
        imageView.center = view.center
        imageView.image = UIImage(named: "addImage")

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    func setNavigationBar() {
        let modes = [
            UIAction(title: "select image") { _ in
                self.vm.imagePicker.presentPhotoPicker(from: self)
            },
            UIAction(title: "take a picture") { _ in
                print("b")
            }
        ]
        let image = UIImage(systemName: "photo.badge.plus")
        let menu = UIMenu(options: .displayInline, children: modes)
        let button = UIBarButtonItem(image: image, menu: menu)
//        let present = UIBarButtonItem(title: "present", style: .plain, target: self, action: #selector(presentTempVC))
        self.navigationItem.rightBarButtonItems = [button]
    }

//    @objc func presentTempVC() {
//        let vc = TempVC()
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true)
//    }

    func bind() {
        vm.imagePicker.modifiedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.imageView.image = image
            }.store(in: &subscriptions)
    }

}

