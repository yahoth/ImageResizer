//
//  ViewController.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 2023/10/03.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let imagePicker = ImagePicker()

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

        view.addSubview(imageView)
        bind()
        setNavigationBar()
        setConstraint()
    }

    func setConstraint() {
        imageView.center = view.center

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
                self.imagePicker.presentPhotoPicker(from: self)
            },
            UIAction(title: "take a picture") { _ in
                print("b")
            }
        ]
        let image = UIImage(systemName: "photo")
        let menu = UIMenu(options: .displayInline, children: modes)
        let button = UIBarButtonItem(image: image, menu: menu)
        self.navigationItem.rightBarButtonItem = button
    }

    func bind() {
        imagePicker.selectedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { image in
//                self.imageView.image = image
//                let vc = Temp2ViewController()
//                vc.selectedImage = image
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
            }.store(in: &subscriptions)
    }

}

