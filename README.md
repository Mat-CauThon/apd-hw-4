# Homework 4 — Catinder

Build a two-screen iOS cat discovery and favorites app. Read [TASKS_AND_GRADES.md](TASKS_AND_GRADES.md) for the exact offline fixture, accessibility contract, scoring, and bonus. This starter only launches a placeholder; implementing the screens is your assignment.

Required environment: Xcode 26.3 and an iPhone 17 simulator with an installed iOS 26 simulator runtime. Run:

```sh
xcodebuild -project Catinder.xcodeproj -scheme Catinder -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/catinder-derived -parallel-testing-enabled NO test
```

Complete `PLAN.md` and `AGENT_WORKLOG.md`; document your testing and agent use. Add your own tests. Submit the repository URL and commit SHA as described in [SUBMISSION.md](SUBMISSION.md). CI uses the same test intent as the command above. Grading uses additional staff-owned tests and no live network.
