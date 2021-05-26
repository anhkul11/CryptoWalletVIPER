//
//  CryptoInfoTableViewCell.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import UIKit
import Kingfisher

struct CryptoInfoViewModel {
    var iconURL: URL?
    var name: String?
    var base: String?
    var salePrice: String?
    var buyPrice: String?
    var isFavorite: Bool
}

final class CryptoInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var baseLabel: UILabel!
    @IBOutlet private weak var saleLabel: UILabel!
    @IBOutlet private weak var buyLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    
    private var didTap: ((String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    @IBAction private func favoriteButtonDidTapped(_ sender: Any) {
        didTap?(baseLabel.text ?? "")
    }
    
    private func configureView() {
        favoriteImageView.tintColor = .yellow
    }
    
    func configureView(with viewModel: CryptoInfoViewModel, favoriteAction: ((String) -> ())? = nil) {
        iconImageView.kf.setImage(with: viewModel.iconURL)
        nameLabel.text = viewModel.name
        baseLabel.text = viewModel.base
        saleLabel.text = "Sell: \(viewModel.salePrice ?? "--")$"
        buyLabel.text = "Buy: \(viewModel.buyPrice ?? "--")$"
        favoriteImageView.image = viewModel.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        didTap = favoriteAction
    }
}
