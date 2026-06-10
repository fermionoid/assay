# assay

A local-first, file-based protocol for personal context engineering.

assay is a tool for **deciding** what is worth keeping in your own life-context. It is not a tool for remembering everything. The shape to copy is git, not a notetaking app.

## Thesis: curation over capture

Capture is cheap. Keeping is expensive. The cost is the point.

The primary verb is **decide**, not **remember**. Anything can record what you type. The hard part, the only part with leverage, is judging what deserves to stay. A small judged context beats a large automatic one, because the value of a context is not how much it holds but how reliably you can act on what it holds.

assay treats every kept item as a **bet**: a claim about your future that carries a falsifiable expectation and a date to check it. You do not keep things for free. You keep them by stating what you expect them to do for you, and later your future self grades whether they did. Most things will not survive that test. That is the design working.

## Principles

- **Every keep is a bet.** It carries a falsifiable expectation and a date to check it.
- **Your future self is the evaluator.** Hindsight is cheaper than foresight.
- **Local by construction.** Plain files on your machine. They never leave.
- **Model-agnostic.** The substrate is text. Any model reads it, no model owns it.
- **Evolve only after you can evaluate.** No learning loop on a signal that does not exist.
- **Friction manufactures judgment.** You do not need to already have taste. Writing the bet is forming the judgment.
- **Optimize the self-model, not retrieval latency.** Fast lookup is a non-goal.

## What assay is not

- Not auto-memory. It will never silently remember things for you.
- Not a faster-retrieval second brain. Retrieval speed is not the problem it solves.
- Not a hosted service. There is nothing to sign up for.
- Not agent memory infrastructure. It is a discipline for a person, which an agent may read.

The friction is load-bearing. A version of assay that removes the friction is a different, worse tool wearing this one's name.

## The tool vs. your data

This is the most important thing to understand before you start.

**This repository is the tool.** It ships the spec, the file convention, templates, one helper script, and a generic empty example. It contains no personal data and never will.

**Your context is separate.** It lives in a private directory on your machine, `~/.assay/` by default, that this repo never touches and never sees. You operate on it with the convention and (in v0) by hand. If you ever version your own context, you do it in your own private repo, not this one.

```
this repo (public tool)          your machine (private data)
-----------------------          ---------------------------
SPEC.md                          ~/.assay/
README.md                          config.yaml
templates/                         branches/<branch>/inbox.md
bin/assay-capture                  branches/<branch>/context.md
example/.assay/  (empty demo)      log/bets.jsonl
                                   log/reviews.jsonl
```

## The convention

```
~/.assay/
  config.yaml            # branch list, review cadence, model settings
  branches/<branch>/
    inbox.md             # raw captures, append-only, no judgment
    context.md           # curated keeps, each one backed by a bet
  log/
    bets.jsonl           # every keep's bet, due date, and outcome
    reviews.jsonl        # your future self's review scores
```

A **branch** is a context boundary, like a git branch is a line of work. Keep a couple. Do not pre-plan a taxonomy.

Full record formats are in [SPEC.md](SPEC.md). Filled synthetic examples are in [docs/worked-examples.md](docs/worked-examples.md). Claim-writing patterns for the different kinds of judgment — events, slow trends, decisions, people, self, kept information — are in [docs/bet-patterns.md](docs/bet-patterns.md).

## Quickstart: dogfood it by hand

v0 ships no organize, review, or nudge logic. You run the rituals by hand. That is deliberate: you should feel the rituals before anyone encodes them.

**1. Make your own context directory from the empty example.**

```sh
cp -r example/.assay ~/.assay
```

**2. Rename the placeholder branches.** Edit `~/.assay/config.yaml` and rename `self` / `work` to real areas of your life or work, then rename the matching folders under `~/.assay/branches/`. Clear the placeholder text out of the `inbox.md` and `context.md` files.

**3. Capture, freely and without judgment.** This is the one verb with a helper.

```sh
export ASSAY_DIR=~/.assay
bin/assay-capture work "vendor hinted the API freezes in Q3"
```

Or just append a `- [timestamp] text` line to the branch's `inbox.md` by hand. Capture is free. Never self-censor here.

**4. Organize, by hand, with friction.** Periodically open a branch's `inbox.md` and for each item decide: toss or keep. Tossing is free and is the expected default. To **keep**, you must write a bet: copy [templates/keep.md](templates/keep.md) into the branch's `context.md`, fill every field including the falsifiable `bet` and a `check_by` date, and append the matching row from [templates/bet.json](templates/bet.json) (as a single line) to `log/bets.jsonl`. If organizing is painless, you are keeping too much.

**5. Review, on a cadence.** Weekly by default. Resurface keeps whose `check_by` is due, plus a small random sample of older ones. For each, append a review row to `log/reviews.jsonl`: is it still worth keeping, is it on the right branch, did the bet hit, and what real decision did it shape. If `decision_it_shaped` is `null` for months, your context has gone decorative. Keep less, bet harder.

**6. Nudge, dumbly.** During review, scan for aging inbox items, overdue bets, and stale branches. It is a checklist, not a recommender.

That is the whole loop. Run it by hand for six to eight weeks before you reach for any automation. See [SPEC.md](SPEC.md) for why the layers are gated that way.

## Status

v0. Layer 1 (the substrate) is built. Layer 2 (the rituals) is specified and run by hand. Layers 3 (interfaces) and 4 (evolution) are not built. Layer 4 is hard-gated and must never auto-keep. See [SPEC.md](SPEC.md#architecture-five-layers).

## License

MIT. See [LICENSE](LICENSE).
