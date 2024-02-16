import UIKit
import SafariServices

extension UIViewController {
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
            let alertVC = GFAlertVC(title: "Something went wrong", message: "We were unable to complete your task at this time", buttonTitle: "OK")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
        }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
