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
}

final class CryptoInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var baseLabel: UILabel!
    @IBOutlet private weak var saleLabel: UILabel!
    @IBOutlet private weak var buyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    private func configureView() {
        
    }
    
    func configureView(with viewModel: CryptoInfoViewModel) {
        iconImageView.kf.setImage(with: viewModel.iconURL)
        nameLabel.text = viewModel.name
        baseLabel.text = viewModel.base
        saleLabel.text = "Sell: \(viewModel.salePrice ?? "--")$"
        buyLabel.text = "Buy: \(viewModel.buyPrice ?? "--")$"
    }
}
