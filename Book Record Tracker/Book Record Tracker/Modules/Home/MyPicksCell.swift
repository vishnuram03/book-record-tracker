//
//  MyPick.swift
//  Book Record Tracker
//
//  Created by Vishnu Ram M on 10/06/26.
//
import UIKit
class MyPicksCell: UICollectionViewCell {
    static let identifier: String = "MyPicksCell"
    
    private var imageTask : Task<Void, Never>?
    // Ui element
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
//    private let authorLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = .systemGray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font  = UIFont.systemFont(ofSize: 9, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 6),
                     titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                     titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

                     statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                     statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                     statusLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // configure the cell
    
    func configure(with userBook : UserBookModel, from book: BookModel){
        titleLabel.text = book.bookName
        
        configureStatus(status : BookStatus(rawValue: userBook.status) ?? .yetToRead)
        configureCover(path : book.coverImagePath, title: book.bookName)
    }
    
    private func configureStatus(status: BookStatus){
        
        switch status {
        case .addedToRead:
            statusLabel.text = status.rawValue
            statusLabel.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 254/255, alpha: 1)
            statusLabel.textColor = UIColor(red: 83/255, green: 74/255, blue: 183/255, alpha: 1)
            
        case .yetToRead:
            statusLabel.text = status.rawValue
            statusLabel.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 254/255, alpha: 1)
            statusLabel.textColor = UIColor(red: 83/255, green: 74/255, blue: 183/255, alpha: 1)
            
        case .currentlyReading:
            statusLabel.text = status.rawValue
            statusLabel.backgroundColor = UIColor(red: 225/255, green: 245/255, blue: 238/255, alpha: 1)
            statusLabel.textColor = UIColor(red: 15/255, green: 110/255, blue: 86/255, alpha: 1)
            
        case .completed:
            statusLabel.text = status.rawValue
            statusLabel.backgroundColor = UIColor(red: 234/255, green: 243/255, blue: 222/255, alpha: 1)
            statusLabel.textColor = UIColor(red: 59/255, green: 109/255, blue: 17/255, alpha: 1)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        coverImageView.image = nil
        
    }
    
    private func configureCover(path: String?, title: String){
        
        if let path = path {
            imageTask = Task {
                let image = await ImageLoader.shared.loadImage(from: path)
                guard !Task.isCancelled else { return }
                self.coverImageView.image = image
            }
        } else {
                   coverImageView.image = UIImage(systemName: "book.closed.fill")
                   coverImageView.tintColor = UIColor.systemBlue.withAlphaComponent(0.75)
                   coverImageView.backgroundColor = placeholderColor(for: title)
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
}
