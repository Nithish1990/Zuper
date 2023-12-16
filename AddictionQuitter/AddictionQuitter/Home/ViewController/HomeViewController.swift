//
//  HomeViewController.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 26/11/23.
//

import UIKit
import SwiftUI

class HomeViewController: AQBaseViewController {

    private let swiftUIView = AQProgessView(progress: ProgressData())
    
    private lazy var homeCollectionView = UICollectionView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar(title: "Home")
        swiftUIView.increaseProgressBy1Second(start:true)
        addProgressView()
        
    }

    private func addProgressView() {
        let hostingController = UIHostingController(rootView: self.swiftUIView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
