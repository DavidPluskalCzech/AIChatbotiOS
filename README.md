# AIChatbotiOS
Simple and friendly AI chatbot app for iOS, written in Swift. It uses Azure OpenAI GPT-4o to respond to user messages in real time.

---

## Features
- Clean **SwiftUI chat UI** with message bubbles (like iMessage)
- Real-time responses via **Azure OpenAI GPT-4o**
- Secure key management using `.env` (never committed!)
- Fully functional with zero external dependencies
- Ready to run in Xcode

---

## Important
> **This app will NOT work without an Azure OpenAI subscription.**  
> You **must** have:
> - An active **Azure OpenAI resource**
> - A deployed **GPT-4o** (or compatible) model
> - Valid **endpoint**, **API key**, and **deployment name**

The `.env` file (containing your secrets) is **intentionally ignored** via `.gitignore` and **not included** in this repository.

---

## How to Run

### 1. Clone the repository
```bash
git clone https://github.com/DavidPluskalCzech/AIChatbotiOS.git
cd AIChatbotiOS



1. **Copy the config template**
   
   ```bash
   cp .env.example .env
   ```
2. **Fill in your Azure credentials in `.env`**
   
   ```env
   AZURE_ENDPOINT=https://your-resource.openai.azure.com
   AZURE_API_KEY=sk-........................................
   AZURE_DEPLOYMENT_NAME=your-gpt4o-deployment-name
   ```

> Get these from **Azure Portal → OpenAI → Deployments**
3. **Open in Xcode and run (⌘R)**

-----

## Security Note

- `.env` is **excluded from Git** (via `.gitignore`)
- **Never commit or share** your `.env` file
- Use `.env.example` only as a template

-----

## Tech Stack

- **SwiftUI**
- `async/await` + `URLSession`
- Azure OpenAI API (`chat/completions`)
- `.env` for local configuration

-----

## Author

**David Pluskal**  
[GitHub](https://github.com/DavidPluskalCzech)


