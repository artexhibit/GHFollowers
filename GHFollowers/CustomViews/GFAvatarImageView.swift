import UIKit

class GFAvatarImageView: UIImageView {
    
    let cashe = NetworkManager.shared.cashe
    let placeholderImage = UIImage(named: "avatar-placeholder")

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
    
    func downloadImage(from urlString: String) {
        
        let casheKey = NSString(string: urlString)
        
        if let image = cashe.object(forKey: casheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, responce, error in
            guard let self = self else { return }
            
            if error != nil { return }
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cashe.setObject(image, forKey: casheKey)
            
            DispatchQueue.main.async { self.image = image }
        }
        task.resume()
    }
}
