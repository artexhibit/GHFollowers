import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextFiled = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get followers")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUsernameTextFiled()
        configureCallToActionButtion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureUsernameTextFiled() {
        view.addSubview(usernameTextFiled)
        
        NSLayoutConstraint.activate([
            usernameTextFiled.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButtion() {
        view.addSubview(callToActionButton)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
