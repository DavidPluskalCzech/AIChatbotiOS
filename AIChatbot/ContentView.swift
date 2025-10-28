import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// ✅ Sem vlož svůj endpoint, apiKey a deploymentName
let azureEndpoint = Secrets.azureEndpoint
let azureApiKey = Secrets.azureApiKey
let deploymentName = Secrets.deploymentName

struct ContentView: View {
    @State private var messages: [Message] = [
        Message(text: "Ahoj, jsem tvůj AI Chatbot 👋", isUser: false)
    ]
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if message.isUser { Spacer() }
                        Text(message.text)
                            .padding()
                            .background(message.isUser ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                            .foregroundColor(message.isUser ? .white : .black)
                            .cornerRadius(12)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7,
                                   alignment: message.isUser ? .trailing : .leading)
                        if !message.isUser { Spacer() }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            
            HStack {
                TextField("Napiš zprávu...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                
                Button("Odeslat") {
                    sendMessage()
                }
                .padding(.horizontal)
                .disabled(inputText.isEmpty)
            }
            .padding()
        }
    }
    
    func sendMessage() {
        let userMessage = Message(text: inputText, isUser: true)
        messages.append(userMessage)
        
        Task {
            let aiText = await callAzureAI()
            let aiResponse = Message(text: aiText, isUser: false)
            messages.append(aiResponse)
        }
        
        inputText = ""
    }
    
    func callAzureAI() async -> String {
        guard let url = URL(string: "\(azureEndpoint)/openai/deployments/\(deploymentName)/chat/completions?api-version=2025-01-01-preview") else {
            return "Chyba URL"
        }
        
        // Vytvoříme historii zpráv pro AI
        var chatMessages: [[String: String]] = [
            ["role": "system", "content": "Jsi přátelský AI chatbot a odpovídej česky nebo odpovídej anglicky."]
        ]
        
        for message in messages {
            let role = message.isUser ? "user" : "assistant"
            chatMessages.append(["role": role, "content": message.text])
        }
        
        let json: [String: Any] = [
            "messages": chatMessages,
            "max_tokens": 150
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(azureApiKey, forHTTPHeaderField: "api-key")
        request.httpBody = jsonData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let response = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = response["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let text = message["content"] as? String {
                return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return "Neplatná odpověď od Azure"
        } catch {
            return "Chyba: \(error.localizedDescription)"
        }
    }
}

// Náhled UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
