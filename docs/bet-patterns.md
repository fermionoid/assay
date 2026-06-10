# Bet patterns

A bet's *shape* (how the claim is spelled) and its *subject* (what the judgment
is about) are different things. People think in subjects. This page is organized
by subject: seven kinds of judgment, each with a claim template and its typical
death mode. The shapes — binary event, quantity threshold, time bracket,
conditional, comparative — are spellings that live inside the first kind and get
borrowed by the rest.

None of this changes the record format. Every pattern fits the existing
`claim` / `check_by` / `source` / `note` fields. The kinds are writing
conventions, not schema.

## The universal filter

Before any pattern: the clairvoyance test. Could a stranger who can see the
future — but not inside your head — grade this claim from its text alone? If
they would need to ask one clarifying question ("growth by how much?", "whose
data?"), rewrite it.

Every claim locks three things at write time:

1. the event or metric, with its exact measurement basis
2. the deadline
3. the source of truth you will open at review — end the claim with a
   "judged by ..." clause. Most bad bets die here: the world answered, but you
   and your future self never agreed on where to look up the answer.

## 事 — external events (what the world will do)

The base kind. Five spellings:

- **Binary**: "By {date}, {precisely defined event} happens, judged by
  {source}." Negative bets ("won't happen") need short windows — their hits are
  weak evidence; say so in `note`.
- **Threshold**: "By {date}, {metric, full basis} is {≥/≤} {value}, vs baseline
  {value} on {date}, per {source}; if the data is unavailable then, void."
  Freeze the baseline number into the claim text. Set `check_by` to the data's
  *publication* date, not the period end. State whether you mean "on the check
  date" or "touched at any point in the window" — they are different bets.
- **Bracket**: "{event} not before {D1}, and before {D2}." Cap D2 at 18 months
  out; anything longer belongs in 势. Early resolution counts only if the
  detection source was named at write time.
- **Conditional**: "If {X} happens by {D}, then {Y} within {T} of X; if X never
  fires, void — never miss." One re-arm only: when X fires, push `check_by` to
  X+T once and log "triggered on {date}" in `note`. If what you actually
  believe is that X will happen, bet X directly — don't hide a position behind
  an if.
- **Comparative**: "{A} beats {B} on {one metric, same source, same window} by
  {date}; gap inside {tie band} → void." Write-time gate: name the exact free
  or already-owned source you will open. If you can't, don't use this spelling.

Death mode: mushy verbs. "Matures", "takes off", "becomes mainstream" never
resolve.

## 势 — slow trends (a thesis and its ladder)

For 5–10-year trajectory judgments. The one hard rule: **the thesis never gets
a bet row.** A check_by years out is a dead ticket rotting in your review
ritual. The thesis lives as a keep (its body holds the draft ladder and retreat
pre-commitments; its `check_by` mirrors the nearest rung). You bet only the
nearest rung: 3–12 months out, `check_by` anchored to the domain's reporting
calendar — earnings, the big annual conferences — never a round year. Link rungs
to the thesis with `source: keep:<thesis-id>`.

Rung flavors:

- **Milestone**: the next observable step on the thesis's critical path. Define
  the evidence class at write time: named-customer production use >
  third-party-reported shipment > vendor keynote > roadmap.
- **Leading indicator**: capital, design wins, standards adoption, hiring. The
  claim must include its inference chain — if this appears, it validates which
  link of the thesis; if it's absent, what that means. One indicator class
  alone never upgrades the thesis.
- **Sentinel** (at most one per ladder): "By {date}, {single named falsifier}
  does not happen; if it does → {pre-written retreat action}." Sentinels hit
  80–90% of the time by design — write "weak confirm — sentinel" in `note` so
  they never inflate your sense of calibration. Their misses carry the
  information.

The re-up ritual: the review that resolves rung N is where rung N+1 gets
written — recalibrated with what resolution taught you, through full keep
friction. No auto-renewal. Not wanting to write the next rung is itself the
signal that the thesis is dead. Two consecutive rung misses force the thesis
keep into review for still_worth / void.

Death mode: a check_by in 2031; a ladder quietly rewritten after a miss.

## 择 — decisions (I chose A over B)

Bet on the reason, not the outcome. "I chose A over B because mechanism R; R
predicts observable sign X by {date}, judged from {record}. X absent → miss,
even if the project succeeds." Record the raw outcome (good/bad) in `note` — it
never overrides the grade. The quadrant this kind exists for: wrong reason,
good outcome. Nothing else in life punishes it.

Pre-register the disconfirmer. `check_by` is the earliest cheap observable
proxy (3–9 months), never "when I'll know for sure". Alternatives and rationale
go in the keep body, not in new fields.

Death mode: resulting — letting a good outcome rescue a bad reason. Also:
reasons reconstructed at review. The inbox timestamp is the notary; capture the
reason when you decide.

## 行 — direction (is X worth my next N months)

Distinct from "X will win" — that is a 事 or 势 bet. Pair the two, so a miss is
diagnosable as wrong-field vs wrong-fit. The stake is the months themselves.
Two legs, both mechanical: (1) the named artifact exists where a stranger could
see it; (2) in the *final* month of the window — not the enthusiastic first —
you still put in ≥{H} voluntary hours, per calendar/git. Cap N at 9 months.
Inbound opportunities go in `note`, ungraded.

Death mode: grading "I learned a lot anyway" — unless pre-registered, that
sentence is the goalpost moving.

## 人 — people (is this person or collaboration worth investing in)

One named dimension — execution, follow-through, growth — never the whole
person. Resolution is one pre-named external deliverable (the submitted draft
exists at a path, the shipped repo, the title change). The question "would I
start the next project with them?" is answered honestly in `note` but not
graded — "I'm still investing" alone is sunk cost wearing a hit. Pre-declare
the void class (visa, reorg, illness) at write time, or review-time-you will
soft-void out of social embarrassment. Keep these on a branch that never gets
pasted into a shared model context.

Death mode: halo — likability quietly substituting for the named dimension.

## 己 — self-model (my own behavioral patterns)

Pure counting against records that exist as side effects of living: git,
calendar, bank statements, inbox timestamps. "When {trigger S}, I do
{observable B}: in the next {window}, S fires ≥{n} times and ≥{k} of them show
B, per {record}. S fires fewer than n times → void." Require n ≥ 3 — one
occurrence is an anecdote. Resolving from memory is forbidden: memory is the
organ under audit. Declare at write time whether this is a description bet (you
won't change) or an intervention bet (writing it changes you) — otherwise the
review is unjudgeable.

Also covers: health n=1 experiments (declared baseline window + exported device
data), capability-by-date ("by {date} I can do X, judged by a recording/log"),
and behavior frequency (4–8 week windows, chained short bets).

Death mode: adjectives. "I procrastinate" counts nothing; only counted
instances are claims.

## 料 — kept information (will this change a decision)

The default bet for every reference keep — the keep-gate made explicit. "I keep
X because I expect decision D within {window}; at review I can name what X
changed — switched the choice, killed an option, or saved ≥{pre-quantified
cost} → hit. D came and X sat unused → miss, delete the keep. D never came →
void, also delete." No rollover: wanting to extend it is the hoarding reflex
wearing a bet costume. Two consecutive "not yet but soon" reviews = miss.

Health check: most 料 bets *should* miss or void. If most hit, your bar for
"changed" is too soft — here the alarm is a high hit rate.

## Two borrowed patterns

- **Affective forecasting**: "3 months after {the move / the offer / the
  purchase}, judged only by pre-registered behavioral proxies — still using it
  ≥N×/week, no exit plan started — never by recalled mood." Recalled mood
  always acquits.
- **Big passes**: the negative space — declined offers, dropped projects. "12
  months after declining Y, the pre-named regret evidence ({their milestone Z}
  while {my track misses W}) does not appear." Routine tosses stay free; only
  the big passes earn a bet.

## Discipline

- Zero schema changes. Everything above lives inside the existing fields as
  writing conventions. No `type` field — blanks get filled lazily; claims
  don't.
- Confidence: optionally write `p≈0.7` in `note`. Promote it to a field only
  when ~50 resolved bets make calibration computable.
- Adopt kinds lazily. Start with the ones you have live instances of; let the
  rest in when a real instance shows up at organize time. After the 6–8 week
  shakedown, delete any kind with zero resolved instances from this page —
  patterns pass the same gate as keeps.
- The review question never changes across kinds: what real decision did this
  shape?
