//
//  ApodTableViewCell.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import UIKit

protocol ApodTableViewCellDelegate: class
{
    func reloadRow(at indexpath: IndexPath?)
}

class ApodTableViewCell: UITableViewCell
{
    var indexpath: IndexPath?
    weak var delegate: ApodTableViewCellDelegate?
    
    lazy var vStackView: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var apodImageView: ScaledHeightImageView =
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var explanationLabel: UILabel =
    {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Add vertical stackview in contentview of cell
        contentView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(apodImageView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(explanationLabel)
        
        // Set selection style .none to disable selection of cell
        selectionStyle = .none
        
        // set colors
        setLabelColors()
    }
    
    /// Set colors for all added labels
    func setLabelColors()
    {
        titleLabel.textColor = UIColor.titleColor
        dateLabel.textColor = UIColor.titleColor
        explanationLabel.textColor = UIColor.subTitleColor
    }
    
    /**
     ConfigureCell to set content in cell
     - Parameters:
        - apodData: `ApodInfoBean`
     */
    func configureCell(from apodData: ApodInfoBean?)
    {
        apodImageView.setImage(urlString: getImageUrl(from: apodData),
                               placeholderImage: UIImage(named: "placeholder"))
        dateLabel.text = apodData?.date?.mdyformattedDate
        titleLabel.text = apodData?.title
        explanationLabel.text = apodData?.explanation
    }
    
    func getImageUrl(from apodData: ApodInfoBean?) -> String?
    {
        switch apodData?.media_type
        {
        case .image:
            return apodData?.url
        case .video:
            return apodData?.thumbnail_url
        default:
            return nil
        }
    }
}
