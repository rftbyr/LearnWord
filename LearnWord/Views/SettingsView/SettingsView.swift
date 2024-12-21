import SwiftUI
import TipKit
import MessageUI
import StoreKit

// MARK: - Bundle Extension
extension Bundle {
    var appVersionLong: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingDeveloperView = false
    @State private var showMailComposer = false
    @State private var showReviewRequest = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Tips Section
                Section {
                    Button() {
                        try? Tips.resetDatastore()
                    } label: {
                        Label("Reset Tips", systemImage: "arrow.counterclockwise")
                    }
                }
                
                // MARK: - App Review Section
                Section("App Review") {
                    Button {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                        dismiss()
                    } label: {
                        Label("Rate the App", systemImage: "star")
                    }
                }
                
                // MARK: - App Info Section
                Section("App Information") {
                    LabeledContent {
                        Text(Bundle.main.appVersionLong)
                    } label: {
                        Label("Version", systemImage: "number")
                    }
                    
//                    LabeledContent {
//                        Text(Bundle.main.appBuild)
//                    } label: {
//                        Label("Build", systemImage: "building.2.fill")
//                    }
                }
                // MARK: - Contact Developer Section
                Section("Contact Developer") {
                    Button {
                        showMailComposer.toggle()
                    } label: {
                        Label("Email Developer", systemImage: "envelope")
                    }
                }
                
              
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showReviewRequest) {
                EmptyView()
            }
            .sheet(isPresented: $showMailComposer) {
                MailComposeView(result: $mailResult)
            }
        }
    }
}

// MARK: - Mail Compose View
struct MailComposeView: UIViewControllerRepresentable {
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(result: Binding<Result<MFMailComposeResult, Error>?>) {
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer { controller.dismiss(animated: true) }
            if let error = error {
                self.result = .failure(error)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["rftbyr@icloud.com"])
        vc.setSubject("Feedback for LearnWord App")
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    static func dismantleUIViewController(_ uiViewController: MFMailComposeViewController, coordinator: Coordinator) {
        uiViewController.dismiss(animated: true)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
