# task.md — Decision Protocol (DecisionMatrix) Implementation Plan

## Goal

Implement a production-grade **Decision Protocol** that converts ambiguity into:

1) a **persisted DecisionMatrix artifact** (auditable, anti-hindsight),
2) a **locked commitment** (first action < 5 minutes),
3) a **scheduled re-evaluation** (review date + exit criteria),
4) a **closed-loop outcome update** (correct vs not-correct handling).

This must outperform generic chat by enforcing **procedural integrity**, bias mitigation, and follow-through.

---

## Core Purpose (Why this exists)

General chat is an open-loop mirror that reinforces bias and buries decisions in ephemera. The Decision Protocol must:

- force framing → evaluation → commitment (separate judgment from choice),
- reduce satisficing drift via explicit adequacy criteria,
- mitigate confirmation bias via “outside view” and disconfirming checks,
- enforce follow-through via commitment devices and implementation intentions,
- ensure auditability via a persistent artifact (Decision Log / Matrix).

---

## Primary Outcome

At session end, the system MUST produce a valid `DecisionMatrix` JSON artifact that includes:

- reversibility audit (one-way vs two-way door),
- adequacy criteria (satisficing floor),
- forced option enumeration (>=3, including status quo),
- weighted criteria (sum to 100),
- option scores + rationale,
- explicit trade-off audit,
- recommendation,
- decision lock + first action (<5 min),
- review date + exit criteria,
- if-then implementation intentions,
- confidence (calibration) and assumptions.

Artifact must be saved to Isar and rendered as UI widgets.

---

## Success Definition (Correct vs Not Correct)

### Correct (Decision Outcome “Correct”)

On review date, if the decision produced the expected outcome:

- mark decision outcome = `SUCCESS`,
- extract learnings:
  - which criteria weights were predictive,
  - which risks did/didn’t materialize,
- optionally nudge user to increase reliance on similar criteria next time
  (lightweight “calibration” summary, not heavy model training).

### Not Correct (Decision Outcome “Not Correct”)

If the decision did NOT work as expected:

- mark decision outcome = `FAILURE` or `AMBIGUOUS`,
- run a short **post-mortem protocol**:
  - identify which assumptions failed,
  - identify whether failure came from:
    - wrong framing,
    - missing option,
    - wrong criterion weighting,
    - wrong scoring,
    - execution breakdown (no follow-through),
- produce an updated “Revision Plan”:
  - adjust criteria weights or add missing criteria,
  - propose next decision iteration (Type 2: iterate fast; Type 1: slow + premortem).

---

## Implementation Plan (LLM Agent + DecisionMatrix)

### Phase 0 — Fix Protocol Routing (must be done first)

- Ensure `protocolType == Decision` routes to Decision Protocol logic.
- Replace string matching with a single `ProtocolType.decision` enum used in:
  - session creation,
  - prompt routing,
  - artifact expected type.

Acceptance:

- Decision sessions never use base prompt fallback.

---

## Agent Architecture

### Two-Stage LLM Interaction (recommended)

1) **Intake Stage (structured questions)**: gather missing fields with minimal friction.
2) **Artifact Stage (JSON-only)**: generate the final DecisionMatrix artifact using strict schema.

Rationale:

- Reduces hallucination and improves schema adherence.
- Allows progressive disclosure (Hick’s Law).

---

## Decision Protocol State Machine (append-only events)

Implement event types (persist in session events list; enables audit trail):

- `decision_framed`
- `reversibility_audited`
- `adequacy_defined`
- `options_enumerated`
- `criteria_defined`
- `criteria_weighted`
- `scores_completed`
- `tradeoff_audited`
- `recommendation_generated`
- `choice_locked`
- `first_action_set`
- `review_scheduled`
- `implementation_intentions_set`
- `artifact_persisted`
- `review_outcome_recorded`

Acceptance:

- Each stage emits an event and can be resumed mid-session.

---

## UI/UX Flow (Progressive Disclosure)

### Step 1 — Frame + Reversibility Audit

UI prompts:

- "What decision are you making?"
- "Deadline?"
- "Is this reversible (two-way door) or irreversible (one-way door)?"

Rules:

- If reversible (Type 2): enforce faster convergence; prevent over-analysis.
- If irreversible (Type 1): require premortem + higher rigor.

### Step 2 — Adequacy Criteria (anti-satisficing drift)

Ask user to define:

- “Minimum acceptable outcome” / “must-have constraints”
- “Deal-breakers”

### Step 3 — Forced Option Enumeration

Require >= 3 options:

- include Status Quo / Delay
If user gives <3:
- agent must propose plausible alternatives (red-team).

### Step 4 — Criteria + Weights

Require 3–6 criteria, weights sum to 100.
Seed criteria using:

- user Core Values,
- North Star alignment,
- constraints (time/money/risk),
- opportunity cost salience.

### Step 5 — Scoring + Rationale

Score each option per criterion (0–10), with 1-line rationale.
Compute weighted totals.

### Step 6 — Trade-off Audit (Pareto / sacrifice visibility)

Explicitly write: “Choosing Option A sacrifices X.”
Must include at least 1 sacrifice per option.

### Step 7 — Decision Lock + Commitment Device

- lock chosen option (user confirms)
- require first action < 5 minutes
- generate If-Then rules (implementation intentions)

### Step 8 — Schedule Review + Exit Criteria

- review date
- exit criteria (“If metric below X by date Y, then stop/pivot”)

---

## Data Model / Schema Requirements

### DecisionMatrix JSON Schema (must be strict)

Create `DecisionMatrix` with required fields:

- `schema_version` (string)
- `decision_id` (uuid)
- `decision_title` (string)
- `decision_deadline` (ISO date)
- `problem_frame` (string)
- `reversibility`:
  - `type` ("two_way_door" | "one_way_door")
  - `reversal_cost` (string)
- `adequacy_criteria`:
  - `must_haves` (string[])
  - `deal_breakers` (string[])
- `opportunity_cost`:
  - `foregone_options` (string[])  // “If you do this, what 3 things are delayed?”
- `options` (2–4 items):
  - `id`, `name`, `description`
- `criteria` (3–6 items):
  - `id`, `name`, `weight` (int), `why_it_matters` (string)
  - weights must sum to 100
- `scores`:
  - array of { `option_id`, `criterion_id`, `score` (0–10), `rationale` }
- `totals`:
  - array of { `option_id`, `weighted_total` (float) }
- `tradeoff_audit`:
  - array of { `option_id`, `primary_sacrifice` (string) }
- `recommendation`:
  - `winning_option_id`
  - `reasoning_bullets` (string[], 3–6 items)
  - `confidence` (0.0–1.0)
  - `assumptions` (string[])
- `risks`:
  - array of { `risk`, `likelihood` ("low"|"med"|"high"), `impact` ("low"|"med"|"high"), `mitigation` }
- `commitment`:
  - `locked_choice_option_id`
  - `first_action` (string)  // MUST be doable <5 minutes
  - `first_action_due` (ISO datetime)
  - `implementation_intentions` (string[], 2–5)  // If-Then rules
- `review`:
  - `review_date` (ISO date)
  - `exit_criteria` (string[])
  - `check_in_question` (string)
- `memory_links`:
  - `core_values_used` (string[])
  - `north_star_metric_used` (string)

Validation constraints:

- options >= 3 preferred; minimum 2 allowed only if decision is trivial (but default require 3).
- criteria weights sum exactly 100.
- scores cover every (option, criterion) pair.
- first_action must be under 5 minutes (enforce by prompt + “timebox” field optional).
- recommendation.confidence:
  - Type 2 (two-way door) must be >= 0.70; if < 0.70 trigger “data gap” branch.

---

## LLM Prompting & Agent Logic

### System Prompt (Decision Protocol Master)

Must enforce:

- Not advice-giving; facilitate user agency (Motivational Interviewing style).
- No option discussion before reversibility + adequacy criteria are set.
- Progressive disclosure.
- JSON-only in artifact stage.

### Intake Stage Prompt (text)

Input:

- user message
- UserContext (core values + north star + constraints)
Output:
- `missing_fields` list
- next questions (max 3 at a time)
- do NOT generate final matrix yet

Stop condition:

- all required fields acquired OR agent chooses assumptions and lists them explicitly.

### Artifact Stage Prompt (JSON-only)

- `responseMimeType: application/json`
- Provide schema + strict instruction: “Return ONLY JSON that matches schema. No markdown.”

---

## Correctness Handling (Closed Loop)

### Review Workflow (on review_date)

UI asks:

- outcome: SUCCESS / FAILURE / AMBIGUOUS
- what happened (short)
- metrics vs expected (optional)

Then agent generates:

- `review_delta_summary`
- `calibration_update`:
  - “Your confidence was 0.8 but outcome failed—what assumption was wrong?”
- `next_step`:
  - if SUCCESS: scale/continue or raise difficulty
  - if FAILURE: rerun decision protocol with updated criteria/assumptions

Persist:

- decision outcome + review notes
- link to original decision_id

---

## “If Not Correct” Branch (Specific Rules)

If FAILURE and reversibility == two_way_door:

- enforce fast iteration:
  - revise weights
  - choose new option or modify current option
  - set new short review date

If FAILURE and reversibility == one_way_door:

- enforce rigor:
  - premortem/postmortem summary
  - identify process failure (framing/options/criteria/execution)
  - explicit anti-sunk-cost decision: continue vs exit using exit_criteria

---

## Data Gap / Uncertainty Handling

If confidence < threshold (default 0.70 for two-way door):

- agent must ask for missing facts OR propose 2–3 quick data collection actions:
  - “Talk to X”
  - “Look up Y”
  - “Run small experiment Z”
Then:
- set a short follow-up session trigger.

---

## Engineering Tasks Checklist (for coding agent)

### 1) ProtocolType + Routing

- [ ] Add `ProtocolType.decision`
- [ ] Replace string comparisons in prompt builder
- [ ] Ensure session stores enum value

### 2) Schema + Validation

- [ ] Implement `DecisionMatrix` Dart model + JSON parsing
- [ ] Add validation:
  - weights sum 100
  - coverage of scores
  - required fields present
- [ ] Add repair loop (max 2 retries)

### 3) Agent Orchestration

- [ ] Implement two-stage flow:
  - Intake questions
  - Artifact generation
- [ ] Persist stage events

### 4) UI Widgets

- [ ] DecisionMatrix view:
  - header: title, deadline, reversibility badge
  - criteria list + weights
  - totals summary + tradeoffs
  - lock decision button
  - first action quick CTA
  - review date display
- [ ] Decision History list (Decision Log)

### 5) Review Workflow

- [ ] Review screen on review_date:
  - outcome input
  - short notes
- [ ] Trigger agent “closed-loop update”
- [ ] Persist results and display calibration summary

### 6) Proactive Hooks (data-first)

- [ ] Store `first_action_due` + `review_date`
- [ ] Emit scheduled notification intents (even if notifications not implemented yet)

---

## Done Definition

This task is complete when:

- Creating a “Decision Protocol” session results in a valid DecisionMatrix artifact rendered in UI.
- Decision is locked with a first action and review date.
- On review date, user can record outcome and the system creates a closed-loop reflection + next step.
- All validations + repair loops work reliably (no broken JSON in production path).
