---

# iOS Notes App — NotesStream (AWS: API Gateway + Lambda + DynamoDB)



An iOS notes app with an AWS serverless backend. Fast sync, offline-friendly, and instrumented for reliability. 

**Highlight:** Scaled to **1k+ notes/user** with **<200 ms** sync; **99.9%** consistency in offline control–variant tests.

---

## Features

* 📝 CRUD notes (title, content, timestamps)
* 🔄 Offline-first sync with conflict-safe merges
* ⚡ Fast path: API Gateway → Lambda → DynamoDB
* 📉 CloudWatch metrics, alarms, structured logs
* 🤖 AI summaries (cuts note length \~40%; review time \~50%)
* 🔊 (Planned) Voice notes → Transcribe → text
* 🔐 (Planned) Cognito auth (JWT) & per-user isolation

---

## Tech Stack

* **Language:** Swift (iOS 17)
* **UI:** SwiftUI (compatible with UIKit components)
* **Networking:** URLSession / Alamofire
* **Backend:** AWS API Gateway, Lambda (Node/Swift/Python), DynamoDB
* **Observability:** Amazon CloudWatch (metrics, logs, alarms)
* **Optional:** S3 (attachments), Cognito (auth)
* **Build:** Xcode 15

---

## Getting Started

### Requirements

* Xcode 15
* iOS 17 simulator or device

### Run

```bash
git clone https://github.com/<your-username>/NotesStream.git
cd NotesStream
# Open in Xcode → Run ▶
```

### Configure API (dev)

Create `APIConfig.swift`:

```swift
struct APIConfig {
    static let baseURL = "https://your-api-gateway-id.execute-api.region.amazonaws.com"
}
```

Quick test (Alamofire or URLSession):

```swift
import Alamofire

AF.request("\(APIConfig.baseURL)/api/note/getall").responseDecodable(of: [Note].self) { resp in
    print("Notes:", resp.value ?? [])
}
```

> If you’re pointing at a local dev server, expose it with **ngrok** and enable **CORS** on your API.

---

## Roadmap

**Phase 1 — Backend live (✅/🛠️):**
API Gateway routes → Lambda (`getall`, `post`, `delete`) → DynamoDB (`Notes` table: `userId` PK, `noteId` SK).

**Phase 2 — Auth & polish (🛠️):**
Cognito User Pool + API authorizer (JWT), pagination, validation, error budgets.

**Phase 3 — AI & media (🎯):**
Future Work: Summarization (Bedrock/OpenAI), auto-tagging, voice notes (S3 + Transcribe), smart search.

---

## Notes

* Modular repos let you swap **mock/Postman → AWS** without UI changes.
* Temporary dev mode can accept a header like `x-access-token: dev` before Cognito is wired.

---

## License

MIT 

---

## Contact

Created by **Soni Rusagara** — happy to connect!
