import UIKit

class GFAvatarImageView: UIImageView {
    
    let cashe = NetworkManager.shared.cashe
    let placeholderImage = UIImage(resource: .avatarPlaceholder)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func dowloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
