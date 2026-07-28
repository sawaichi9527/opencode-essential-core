# AGENTS.md

## OpenCode project purpose

Describe the project goal, expected users, and what OpenCode is helping to build or maintain.

## OpenCode working rules

- OpenCode must read this file and `handoff.md` before changing project files.
- Keep changes small, reviewable, and directly related to the requested task.
- Show the intended file changes before destructive or irreversible operations.
- Do not store passwords, API keys, tokens, private keys, or internal credentials.
- Ask before `git push`, deployment, deletion, hardware control, stress testing, or other high-impact operations.

## Code change baseline

- Understand the affected code path before editing; do not patch a symptom without checking the shared cause.
- State assumptions that materially affect the implementation or test result.
- Ask first when ambiguity affects requirements, safety, the test target, the DUT, or hardware behavior.
- Reuse existing project code before creating a new helper or abstraction.
- Prefer standard libraries, native platform features, and already-installed dependencies.
- Make the smallest change that satisfies the actual requirement.
- Do not refactor unrelated code, comments, naming, or formatting.
- Define and run an appropriate verification after changing code.
- Never remove required test coverage, logging, reporting, safety checks, or traceability merely to reduce code size.

## Validation

List the exact commands OpenCode should run to validate this project, for example:

```text
pytest
ruff check .
python scripts/smoke_test.py
```

## Project-specific notes

Add project constraints, naming rules, supported platforms, fixtures, timeout/retry rules, log/verdict rules, and known limitations here.
