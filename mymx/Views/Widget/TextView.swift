import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.returnKeyType = .default
        textView.text = placeholder
        textView.textColor = .placeholderText
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = .placeholderText
        } else {
            uiView.text = text
            uiView.textColor = .label
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Handle the return key to insert a new line
            if text == "\n" {
                textView.text.append("\n")
                return false
            }
            return true
        }
    }
}
