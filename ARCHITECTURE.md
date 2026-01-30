# Protocol Architecture & Data Flow

This document outlines how the **Protocol** application functions, focusing on session management and the "Interface-as-Agent" architecture.

## 1. Core Concept

Protocol is an **offline-first** application. All data (sessions, chat history, user context) is stored locally on the device using **Isar Database**. The AI (Gemini) is stateless; we inject the full necessary context into every request.

## 2. Data Flow: Sessions

### 2.1. fetching Sessions (Dashboard)

When the app opens or the Dashboard loads:

1. **UI:** `DashboardPage` watches the `sessionControllerProvider`.
2. **Controller:** `SessionController` calls `LocalStorageRepository.getAllSessions()`.
3. **Database:** Isar queries the `Session` collection, sorting by `timestamp` (descending).
4. **Display:** The UI renders the list of sessions.

### 2.2. Creating a Session (Starting a Protocol)

When a user taps a card (e.g., "Decision Matrix"):

1. **UI:** `DashboardPage` calls `sessionController.createSession('Decision Matrix')`.
2. **Controller:**
    * Creates a new `Session` object in memory.
    * Sets `timestamp` to `DateTime.now()`.
    * Sets `protocolType` to "Decision Matrix".
    * Initializes an empty `history` list.
3. **Persistence:** The new session is saved to Isar via `LocalStorageRepository`.
4. **Navigation:** The UI receives the new `sessionId` and navigates to the `SessionPage`.

## 3. The "Agent" (Gemini Integration)

In Protocol, the "Agent" is not a separate server or a stateful bot. It is a **System Prompt** dynamically assembled on the device for every message.

### 3.1. The Interaction Loop

1. **User Input:** User types a message in `SessionPage`.
2. **State Update:** `SessionController.sendMessage()` is called.
    * The user's message is appended to the local session `history` and saved to DB.
3. **Context Assembly (The "Brain"):**
    * The app retrieves the **User Context** (Core Values, North Star Metric) from `SettingsController`.
    * The app retrieves the **Session History** from the current session.
    * The app identifies the **Protocol Type** (e.g., "Action Plan").
4. **Prompt Engineering:**
    `GeminiProtocolService` constructs a massive System Prompt:

    ```text
    You are "PROTOCOL"...
    USER CONTEXT: {Core Values: Integrity, Speed...}
    CURRENT PROTOCOL: Action Plan
    INSTRUCTION: Focus on high-leverage actions...
    ```

5. **Generation:** The prompt + history is sent to Google Gemini 3 Flash.
6. **Response Handling:**
    * Gemini returns a text response.
    * If the response contains JSON (e.g., an Action Plan), the `ArtifactBuilder` in the UI detects it.
    * The response is saved to the local database.

### 3.2. Artifacts (UI-as-Agent)

The Agent can control the UI by outputting strictly formatted JSON.

* **Detection:** `_ChatMessageWidget` checks if a message contains a JSON block.
* **Parsing:** If valid JSON is found, it swaps the standard Markdown view for a specialized Widget (e.g., `ActionPlanWidget`).

## 4. Directory Structure

* `lib/core/database`: Low-level Isar access (`LocalStorageRepository`).
* `lib/core/models`: Data definitions (`Session`, `UserContext`).
* `lib/features/session/providers`: Logic for managing sessions (`SessionController`) and talking to AI (`GeminiProtocolService`).
* `lib/features/session/views`: UI for the Dashboard and Chat (`SessionPage`).
