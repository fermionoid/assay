# Worked examples

Filled, synthetic, obviously-fake examples of the assay convention. None of this
is real personal data. It exists only to show the record formats in use. Copy the
shapes, not the content.

The thread below follows two keeps on a `work` branch through their full life:
capture, keep with a bet, and review. One bet hits, one misses.

---

## 1. Capture (lines in `branches/work/inbox.md`)

Raw, unjudged, append-only. This is the holding pen, not the keep.

```
- [2026-01-12T09:41:00+0000] vendor SE hinted their public API "freezes" after Q3, no detail
- [2026-01-12T09:42:30+0000] our onboarding drop-off is worst on step 3 (the address form)
- [2026-01-14T16:05:12+0000] random: maybe we should write our own pdf renderer
```

The third line is the kind of thing that will probably get tossed at organize.
That is fine. Capturing it cost nothing.

---

## 2. Keep, with a bet (blocks in `branches/work/context.md`)

Only items that survived a bet live here. Two are promoted from the inbox above.

```markdown
## Vendor API freeze risk

- id: work-20260114-vendor-freeze
- branch: work
- why: if their API freezes mid-quarter it blocks our Q3 integration work
- bet: by 2026-04-01 the vendor will announce a breaking freeze that forces us to pin a version or migrate
- check_by: 2026-04-01
- source: call with vendor SE, 2026-01-12
- kept_at: 2026-01-14

SE was vague but specific enough to act on. Worth pinning the dependency now
rather than discovering the freeze in a sprint.
```

```markdown
## Onboarding step 3 is the drop-off

- id: work-20260114-onboarding-step3
- branch: work
- why: step 3 (address form) is where we lose the most users; fixing it should move activation
- bet: simplifying the step 3 address form will raise activation by at least 3 points within 6 weeks of shipping
- check_by: 2026-03-15
- source: analytics review, 2026-01-12
- kept_at: 2026-01-14
```

Each keep gets a matching open bet appended to the log.

---

## 3. Bets (lines in `log/bets.jsonl`)

One JSON object per line. Written `open` at keep-time, resolved at review.

At keep-time, both are open:

```json
{"id":"work-20260114-vendor-freeze","keep":"Vendor API freeze risk","branch":"work","claim":"by 2026-04-01 the vendor announces a breaking freeze forcing us to pin or migrate","created":"2026-01-14","check_by":"2026-04-01","status":"open","resolved_on":null,"outcome":null,"note":null}
{"id":"work-20260114-onboarding-step3","keep":"Onboarding step 3 is the drop-off","branch":"work","claim":"simplifying the step 3 address form raises activation by >=3 points within 6 weeks","created":"2026-01-14","check_by":"2026-03-15","status":"open","resolved_on":null,"outcome":null,"note":null}
```

After their check dates, the same two rows are rewritten with outcomes. One hit,
one miss:

```json
{"id":"work-20260114-vendor-freeze","keep":"Vendor API freeze risk","branch":"work","claim":"by 2026-04-01 the vendor announces a breaking freeze forcing us to pin or migrate","created":"2026-01-14","check_by":"2026-04-01","status":"hit","resolved_on":"2026-03-28","outcome":"vendor posted a v1 freeze + v2 migration window; we had already pinned v1","note":"keeping this saved a scramble"}
{"id":"work-20260114-onboarding-step3","keep":"Onboarding step 3 is the drop-off","branch":"work","claim":"simplifying the step 3 address form raises activation by >=3 points within 6 weeks","created":"2026-01-14","check_by":"2026-03-15","status":"miss","resolved_on":"2026-03-15","outcome":"shipped the simpler form; activation moved +0.4 points, inside the noise","note":"drop-off was real but the form was not the cause"}
```

The miss is not a bad keep. It is a resolved one. We learned the form was not the
lever, which is exactly what a falsifiable bet is for.

---

## 4. Reviews (lines in `log/reviews.jsonl`)

One review row per keep examined. The honest part is `decision_it_shaped`.

```json
{"id":"work-20260114-vendor-freeze","keep":"Vendor API freeze risk","reviewed_on":"2026-03-28","still_worth":"yes","right_branch":"yes","bet_outcome":"hit","decision_it_shaped":"pinned the vendor SDK to v1 in the Q1 dependency update instead of floating","note":"clean hit; this is what a good keep looks like"}
{"id":"work-20260114-onboarding-step3","keep":"Onboarding step 3 is the drop-off","reviewed_on":"2026-03-15","still_worth":"no","right_branch":"yes","bet_outcome":"miss","decision_it_shaped":"deprioritized further form work and moved the investigation to step 2 latency","note":"the keep was wrong but it still shaped a real decision, so it earned its place"}
```

Note the second review: the keep's bet **missed**, yet `decision_it_shaped` is not
`null`. A wrong keep that still redirected real effort is a useful keep. The alarm
is not a `miss`. The alarm is a long run of `null` in `decision_it_shaped`, which
means the context is decorative and you should keep less and bet harder.

---

## What a healthy log looks like

- A mix of `hit`, `miss`, and `void` in `bets.jsonl`. All hits means your bets are
  too safe to be informative. No misses means you are not betting.
- `decision_it_shaped` populated on most reviews. This is the signal that the
  practice is doing its job.
- A `context.md` that stays small. Growth without pruning is the failure mode.
