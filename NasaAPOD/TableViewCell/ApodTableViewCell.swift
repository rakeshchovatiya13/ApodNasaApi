//
//  ApodTableViewCell.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import UIKit

class ApodTableViewCell: UITableViewCell
{
    lazy var vStackView: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var astronomyImageView: ScaledHeightImageView =
    {
        let imageView = ScaledHeightImageView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: contentView.frame.size.width,
                                                            height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var explanationLabel: UILabel =
    {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        /// Add vertical stackview in contentview of cell
        contentView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(astronomyImageView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(explanationLabel)
    }
    
    func setContent(from apodData: ApodInfoBean?)
    {
        astronomyImageView.setImage(urlString: apodData?.hdurl)
        dateLabel.text = apodData?.date
        titleLabel.text = apodData?.title
        explanationLabel.text = apodData?.explanation
    }
}
