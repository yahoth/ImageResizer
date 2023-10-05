//
//  TempViewController.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 10/5/23.
//

///image의 비율값을 구한다.
///그 비율대로 스크롤뷰를 만든다
///이미지를 넣는다

/// 현재 상황
/// 3:4비율 ✅
/// 가로가 더 길때: 위로 드래그가 안되고, 확대했을때 아래쪽에 붙음 -> 처음에 빈 부분만큼 위가 유지됨.
/// 세로가 더 길때:  처음 화면 불러올 때 맨위에서 시작하지만, 그 후론 ㄱㅊ
///
/// 공통문제: 확대 전에는 드래그가 안된다.
///
/// 문제: 오토레이아웃인듯.
import UIKit

class Temp2ViewController: UIViewController {

    let scrollView = UIScrollView()
    let imageView = UIImageView()
    @Published var selectedImage: UIImage!

    let hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()

    let xButton = UIButton()
    let confirmButton = UIButton()
    var cropLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
//        scrollView.bouncesZoom = false
//        scrollView.alwaysBounceVertical = false
//        scrollView.alwaysBounceHorizontal = false

        scrollView.backgroundColor = .red
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isUserInteractionEnabled = true
        let image = selectedImage
        imageView.image = image
        imageView.center = scrollView.center
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - 40) * 4 / 3),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])

        let imageWidth = image?.size.width ?? 0
        let imageHeight = image?.size.height ?? 0
        let aspectRatio = imageWidth / imageHeight

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
//            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1 / aspectRatio)
        ])

        let maxDimension = max(imageView.bounds.width, imageView.bounds.height)
//        scrollView.contentSize = CGSize(width: maxDimension, height: maxDimension)
        scrollView.contentSize = imageView.bounds.size

//        print("wid: \(imageView.bounds.size.width)")
        scrollView.delegate = self

        view.addSubview(hStack)

        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        confirmButton.setImage(UIImage(systemName: "checkmark"), for: .normal)

        xButton.addTarget(self, action: #selector(dismissImageResizer), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)

        [xButton, confirmButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .label
            button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
            hStack.addArrangedSubview(button)
        }

        cropLabel.text = "Crop"
        cropLabel.textColor = .label

        hStack.insertArrangedSubview(cropLabel, at: 1)

        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            hStack.heightAnchor.constraint(equalToConstant: 100)
        ])


    }

    @objc func dismissImageResizer() {
        self.dismiss(animated: true, completion: nil)
        print("dismiss")
    }

    @objc func confirm() {
        print("confirm")
    }
}

extension Temp2ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
