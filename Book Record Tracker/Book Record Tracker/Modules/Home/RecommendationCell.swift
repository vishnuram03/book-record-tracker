//
//  RecommendationCell.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 10/06/26.
import UIKit

class RecommendationCell: UICollectionViewCell {
    static let identifier: String = "RecommendationCell"
    
    private var imageTask : Task<Void, Never>?
    
    // UI Element
    
    private let coverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10 , weight: .medium)
        label.textColor = UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor =  . systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 108),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        coverImageView.image = nil
    }
    
    func configure(with book : BookModel){
        titleLabel.text = book.bookName
        authorLabel.text = book.author
        
        if let path = book.coverImagePath{
            imageTask = Task {
                let image = await ImageLoader.shared.loadImage(from: path)
                guard !Task.isCancelled else { return }
                self.coverImageView.image = image
            }
        }
        else{
            coverImageView.image = UIImage(systemName: "book.closed.fill")
            coverImageView.tintColor = UIColor.systemBlue.withAlphaComponent(0.75)
            coverImageView.backgroundColor = placeholderColor(for: book.bookName)
        }
    }
    
    private func placeholderColor(for title: String) -> UIColor {
        let colors: [UIColor] = [

            // Sky Blue
            UIColor(
                red: 204/255,
                green: 228/255,
                blue: 255/255,
                alpha: 1
            ),

            // Mint
            UIColor(
                red: 200/255,
                green: 240/255,
                blue: 225/255,
                alpha: 1
            ),

            // Warm Cream
            UIColor(
                red: 255/255,
                green: 225/255,
                blue: 190/255,
                alpha: 1
            ),

            // Peach
            UIColor(
                red: 255/255,
                green: 215/255,
                blue: 200/255,
                alpha: 1
            ),

            // Soft Lime
            UIColor(
                red: 220/255,
                green: 240/255,
                blue: 190/255,
                alpha: 1
            )
        ]

        let index = (title.first?.asciiValue ?? 0) % UInt8(colors.count)
        return colors[Int(index)]
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
