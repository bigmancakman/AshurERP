import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        // Medya oynatımında (video vb.) tam ekran veya inline ayarları
        webConfiguration.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uygulamanın açılış URL'i
        guard let myURL = URL(string: "https://erp.ashurcompany.com") else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // Yükleme sırasında hata oluşursa göster
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Bağlantı Hatası", message: "Sayfa yüklenemedi. Lütfen internet bağlantınızı kontrol edin.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // `target="_blank"` olan linkleri (yeni sekmede açılan) aynı webview içinde açmayı sağlar
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // --- JS Alert / Confirm / Prompt Dialoglarını Native iOS Dialoglarına Çevirme ---

    // JS Alert (alert)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // JS Confirm (confirm)
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // JS Prompt (prompt)
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
