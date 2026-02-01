# Project Protocol: Action Plan & Status

## 1. Project Overview
**Name:** Protocol (Working Title)
**Concept:** A minimalist, offline-first AI executive coach for systems thinkers.
**Differentiation:** "Interface-as-Agent." The AI renders UI artifacts (widgets) via strictly typed JSON streams.
**Target Audience:** "Summit" refugees, creators, builders.
**Design Language:** Swiss Style (International Typographic Style). Minimal, monochrome, sharp edges.

## 2. Tech Stack & Architecture
* **Framework:** Flutter (Stable Channel)
* **State Management:** Riverpod 2.0 (Code Generation + Hooks)
* **Local DB:** Isar (Offline-first, strictly typed persistence)
* **AI Engine:** **Gemini 3 Flash** (via `google_generative_ai` SDK)
    * *Architecture:* **Context-Window-First**. No RAG. We inject full session history + User Context into the 1M+ token window.
* **Backend:** Supabase (Optional/Auth only).
* **Architecture:** Feature-first, Repository Pattern.

---

## 3. Execution Roadmap

### Phase 1: Foundation (The Skeleton)
- [x] **Project Setup:** Initialize Flutter, configure `analysis_options.yaml` (strict), setup Riverpod.
- [x] **Dependencies:** Add `google_generative_ai`, `isar`, `isar_flutter_libs`, `google_fonts`, `flutter_markdown`.
- [x] **Database Schema (Isar):**
    - [x] Create `UserContext` schema (Core Values, North Star Metric).
    - [x] Create `Session` schema (Timestamp, ProtocolType, Full History).
    - [x] Implement `LocalStorageRepository`.
- [x] **State Management Layer:**
    - [x] Create `SessionController` (Riverpod Notifier).
    - [x] Create `SettingsController`.

### Phase 2: The Interface (Swiss Design)
- [x] **Theme Setup:** Define `ThemeData` (Off-white `#F5F5F7` bg, Black text, Sharp corners `BorderRadius.zero`).
- [x] **Dashboard (Home):**
    - [x] Implement Grid Layout for Protocols.
    - [x] Create `ProtocolCard` widget.
- [x] **Session View (The "Stream"):**
    - [x] Build `SessionPage` scaffold.
    - [x] Create `StreamedMessage` widget (Text rendering).
    - [x] **CRITICAL:** Implement `ArtifactBuilder`. This listens to the stream for Gemini's JSON objects and swaps the UI from "Text" to "Widget".

### Phase 3: The Intelligence (Gemini 3 Flash)
- [x] **Service Layer:** Implement `GeminiProtocolService`.
    - [x] **Fast Client:** `responseMimeType: 'text/plain'` (for Clarity Chat).
    - [x] **Reasoning Client:** `responseMimeType: 'application/json'` + `responseSchema` (for Decision Matrix/Plans).
- [x] **Context Injection:**
    - [x] Build the "Context Assembler" that pulls *all* previous `UserContext` and relevant `Session` history from Isar and formats it for the 1M token window.
- [x] **Prompt Engineering:**
    - [x] Define System Prompts with "Thinking" instructions (e.g., "Analyze second-order effects before outputting JSON").
- [x] **Artifact Logic:**
    - [x] Define the `Schema` for: `ActionPlan`, `DecisionMatrix`, `WeeklyReview`.
    - [x] Map Gemini's JSON output directly to Flutter Widgets.
- [x] **Decision Protocol Spec:** `decision_protocal.md`

### Phase 4: The Loop (Retention)
- [x] **Onboarding Flow:** 3-Question Intake Form -> Save to Isar.
- [ ] **Proactive Engine:**
    - [ ] Setup `flutter_local_notifications`.
    - [ ] Implement "Nudge Logic" (e.g., "It's 2 PM. Did you finish the Deep Work block?").
- [ ] **Polish:** Haptic feedback on token stream, loading skeletons.

### Phase 5: Cloud & Monetization (Supabase & RevenueCat)

*The "Solo Dev" extension.*

* [ ] **Supabase Setup (Auth & Remote Config):**
* [ ] **Google OAuth Integration:**
* [ ] Configure Google Cloud Console (Web Client ID, Android SHA-1, iOS Bundle ID).
* [ ] Enable Google Provider in Supabase Auth Dashboard.
* [ ] Implement `Supabase.auth.signInWithIdToken` in Flutter.

* [ ] **Cloud Schema (SQL Migration):**
* [ ] Create `profiles` table (handle new user triggers).
* [ ] Create `coaches` table (cols: `id`, `name`, `system_prompt`, `is_active`) for remote prompt updates.
* [ ] Create `sessions` table (cols: `id`, `user_id`, `summary`, `artifacts_json`).
* [ ] Create `messages` table (cols: `id`, `session_id`, `role`, `content`, `tokens_used`).

* [ ] **Sync Logic:** Create `SyncRepository` to push local Isar data to Supabase when online.

* [ ] **Monetization (RevenueCat):**
* [ ] Setup RevenueCat project & connect to App Store Connect.
* [ ] Create Entitlements: `free` (Clarity Coach), `pro` (Decision & Review Coaches).
* [ ] Implement Paywall UI (Minimalist, "Unlock your Operating System" copy).

### Phase 6: Launch (The Soul)

* [ ] **App Store Assets:**
* [ ] Design screenshots focusing on "Systems" and "Clarity" (Swiss Style, large typography).
* [ ] **ASO:**
* [ ] Keywords: "Decision," "Focus," "Weekly Review," "Executive Coach."
* [ ] **Landing Page:**
* [ ] Simple one-pager: "The OS for your Mind."

## 4. Current Context & Notes

* **Major Pivot:** We are **NOT** using RAG. Trusting Gemini's 1M context.
* **Env Variables:** `DATABASE_URL`, `SUPABASE_SECRET_KEY`, `SUPABASE_PUBLISHABLE_KEY` are set.
* **Sync Strategy:** App remains "Local First." Supabase is strictly for backup and cross-device sync. If Supabase is down, the app works 100%.
* **JSON Mode:** For the "Decision Matrix" and "Action Plan" protocols, strictly enforce `responseSchema` to prevent UI crashes.
* **Design Rule:** If in doubt, remove it. No avatars, no bubbles.
