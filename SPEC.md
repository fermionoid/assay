# assay

A local-first, file-based protocol for personal context engineering.

assay is a tool for deciding what is worth keeping in your own life-context. It is not a tool for remembering everything. The shape to copy is git, not a notetaking app.

## Thesis: curation over capture

Capture is cheap. Keeping is expensive. The cost is the point.

The primary verb is **decide**, not **remember**. Anything can record what you type. The hard part, the only part with leverage, is judging what deserves to stay. A small judged context beats a large automatic one, because the value of a context is not how much it holds but how reliably you can act on what it holds.

assay treats every kept item as a claim about your future. You do not get to keep something for free. You keep it by stating what you expect it to do for you and when you will check whether it did. Most things will not survive that test, and that is the design working, not the design failing.

## Principles

- **Every keep is a bet.** It carries a falsifiable expectation and a date to check it. If you cannot say what you expect a kept item to change, you do not keep it.
- **Your future self is the evaluator.** Hindsight is cheaper than foresight. You will not know if a keep was good when you make it. You will know later, and the protocol is built to ask you later.
- **Local by construction.** Context is plain files on your machine. It never leaves. No sync, no server, no account.
- **Model-agnostic.** The substrate is text. Any model reads it, no model owns it. You can switch tools, switch models, or stop using software entirely, and your context is still yours and still legible.
- **Evolve only after you can evaluate.** No learning loop runs on a signal that does not exist yet. You earn automation by first generating the data that would tell you whether the automation is any good.
- **The tool manufactures judgment through friction.** It does not require you to already have taste. The act of writing a bet is the act of forming a judgment. Friction is the feature.
- **Optimize the self-model, not retrieval latency.** The goal is that you understand your own keeping decisions better over time. Fast lookup is a non-goal. If you wanted fast lookup you would use search.

## What assay is not

- Not auto-memory. It will never silently remember things for you.
- Not a faster-retrieval second brain. Retrieval speed is not the problem it solves.
- Not a hosted service. There is nothing to sign up for.
- Not agent memory infrastructure. It is a discipline for a person, which an agent may read.

The friction is load-bearing. A version of assay that removes the friction is a different, worse tool wearing this one's name.

## Architecture: five layers

Each layer is built only after the one below it has earned its keep. Building higher before lower is how you end up automating a process you have never verified.

- **Layer 0, Philosophy.** This SPEC and the README. The argument for why the friction exists.
- **Layer 1, Substrate.** The file convention. `[v0: BUILD]`
- **Layer 2, Ritual.** The verbs `capture`, `organize`, `review`, `nudge`. `[spec only, run by hand]`
- **Layer 3, Interfaces.** A CLI, then an MCP server. `[deferred, not hard-gated]`
- **Layer 4, Evolution.** A learned pre-filter trained on verified reviews. `[HARD-GATED]`

Layer 3 is deferred but not forbidden. Build it when typing the rituals by hand gets annoying enough that a thin wrapper pays for itself. A CLI that just automates the file edits is fine. It changes nothing about the protocol.

### The one hard gate

Layer 4 is the only hard gate. Do not build a learning or evolution loop until both of these are true:

1. Layer 2 has been run by hand for six to eight weeks.
2. The accumulated review signal beats both random selection and cold gut on held-out items.

The second condition is the real one. If your reviews cannot tell a good keep from a coin flip, there is no signal to learn from, and a model trained on that noise will launder it into false confidence. You need a measurable signal before you are allowed to optimize against it.

When Layer 4 is eventually built, it must improve the user's judgment, never replace it. It is decision support: it can surface, rank, and remind, but the human still writes the bet and still owns the keep. A Layer 4 that auto-keeps deletes the friction that is the entire point of the tool. At that moment assay would become the auto-memory it was built to reject.

## Layer 1: the context convention

The convention is the shape of a user's private context directory. The default location is `~/.assay/`. This directory is the user's data. It is never this repository. This repo ships the spec, the convention, templates, a helper script, and a generic empty example. Real context lives outside, on the user's machine, and never enters version control unless the user chooses to version their own private directory separately.

```
<context-dir>/
  config.yaml            # branch list, review cadence, model settings
  branches/<branch>/
    inbox.md             # raw captures, append-only, no judgment
    context.md           # curated, organized context for this branch
  log/
    bets.jsonl           # each keep's bet + due date + outcome
    reviews.jsonl        # future-self review scores
```

A **branch** is a context boundary, the same way a git branch is a line of work. It groups captures and keeps that belong to one area of your life or work. Branches are cheap to make and cheap to abandon. Start with one or two. Do not pre-plan a taxonomy.

`inbox.md` is append-only and unjudged. Anything goes in. It is the holding pen, not the keep.

`context.md` is curated. Only items that survived a bet live here. This is what you would hand a model as your context for the branch.

`log/` is the memory of your judgment. `bets.jsonl` records what you expected. `reviews.jsonl` records what your future self found. These two files are the data that, much later, Layer 4 might learn from. They are worthless if filled lazily, so the formats are kept small enough to fill honestly.

## Record formats

### Capture, a line in `inbox.md`

```
- [ISO8601] raw text
```

That is the whole format. No tags, no judgment, no structure. Capturing is free and must stay free, or the inbox stops being used and people start self-censoring at the point of capture, which is exactly the wrong place to apply friction.

### Keep, a block in `context.md`

A keep is promoted from the inbox only by stating a bet. The required fields:

- `title`: short name for the kept item.
- `branch`: which branch it belongs to.
- `why`: one line, why it is worth keeping.
- `bet`: a falsifiable expectation. What you expect this keep to do or predict.
- `check_by`: the date you will evaluate the bet.
- `source`: where it came from (a link, a conversation, a thought).
- `kept_at`: the date you kept it.

Keeping requires a bet. Tossing is free. This asymmetry is the friction gate, and it is deliberate: it should be easier to throw something away than to keep it, because keeping is the expensive act.

A keep block carries a stable `id` so its bet and reviews can reference it. The `id` is shared between the keep block, its row in `bets.jsonl`, and its rows in `reviews.jsonl`. A workable id scheme is `<branch>-<YYYYMMDD>-<short-slug>`, for example `work-20260601-vendor-lockin`. It only has to be unique and stable, not pretty. Pick a scheme and stick to it.

### Bet, a line in `bets.jsonl`

```json
{
  "id": "string, stable, shared with the keep and its reviews",
  "keep": "title or short ref of the kept item",
  "branch": "branch name",
  "claim": "the falsifiable expectation, restated from the keep's bet",
  "created": "ISO8601 date",
  "check_by": "ISO8601 date",
  "status": "open | hit | miss | void",
  "resolved_on": "ISO8601 date or null",
  "outcome": "short text or null",
  "note": "short text or null"
}
```

`status` starts `open`. At review it becomes `hit` (the expectation held), `miss` (it did not), or `void` (the bet stopped being meaningful, for example the branch was abandoned or the question dissolved). `void` is not a failure, it is honest bookkeeping, and conflating it with `miss` would poison the signal.

### Review, a line in `reviews.jsonl`

```json
{
  "id": "string, shared with the keep and its bet",
  "keep": "title or short ref of the kept item",
  "reviewed_on": "ISO8601 date",
  "still_worth": "yes | no",
  "right_branch": "yes | no | the branch it should move to",
  "bet_outcome": "hit | miss | void | too_early",
  "decision_it_shaped": "a real decision this keep informed, or null",
  "note": "short text or null"
}
```

`decision_it_shaped` is the load-bearing field. It is the answer to the only question that matters: did keeping this actually change anything you did? If `decision_it_shaped` stays `null` across most reviews for months, the self-model claim is unproven. The tool is generating reviews but not generating decisions, which means the context is decorative. Flag this. It is the signal that the whole practice has drifted into journaling, and the fix is to keep less and bet harder, not to keep more.

`bet_outcome` may be `too_early` when `check_by` has arrived but the bet genuinely cannot be judged yet. Use it sparingly. A bet that is perpetually `too_early` was not falsifiable, which means it was not a real bet.

## Layer 2: the verbs

These are specified here and run by hand in v0. v0 ships no organize, review, or nudge logic. The point of running them by hand first is to find out what the rituals actually feel like before encoding them, because a verb automated before it is understood is a verb automated wrong.

### capture

Append a line to the active branch's `inbox.md`. Free, no judgment, no decision. The only verb with a helper script in v0.

### organize

Process the inbox. For each item, decide: toss or keep. Tossing is free and is the expected default. Keeping requires writing a bet, which creates a keep block in `context.md` and a row in `bets.jsonl`. This is where the friction lives. If organizing is painless, you are keeping too much.

### review

Resurface keeps whose `check_by` is due, plus a small random sample of older keeps. For each, write a row in `reviews.jsonl`: is it still worth keeping, is it on the right branch, did the bet hit, and crucially, what real decision did it shape. Reviewing is where foresight gets graded by hindsight. It is the source of all signal.

### nudge

Surface aging inbox items, overdue bets, and stale branches. Keep it dumb. It is a scheduled list, not a recommender. The moment nudge starts ranking by predicted importance, it has quietly become Layer 4 without earning the gate.

## A note on cadence

`config.yaml` carries a review cadence, defaulting to weekly. The cadence is a floor for attention, not a deadline for every bet. Most bets will have `check_by` dates further out than one week. The weekly ritual is when you run `review` and `nudge`, not when every bet comes due. Pick a cadence you will actually keep, then keep it, because an irregular review schedule produces an irregular signal, and irregular signal is the thing Layer 4 cannot learn from.
