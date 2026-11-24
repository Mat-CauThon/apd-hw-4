# HW4 — Catinder: tasks and automatic grading

Individual assignment: **12 base points + 4 optional bonus points**. Build an iOS app with discovery and favorites screens. The starter is deliberately incomplete. You may use UIKit or SwiftUI and choose your architecture. Keep the `CatService`, `Cat`, and `FixtureCatService` interfaces and fixture behavior provided in `Catinder/Fixtures.swift`; you may add other services and your own application types.

## How the grader runs the app

Keep `Catinder.xcodeproj`, the `Catinder` scheme, and the starter’s filesystem-synchronized `CatinderUITests` target and source directory. The grader copies staff-owned tests into that directory as `HW4GradingTests.swift` with class `HW4GradingTests`; reserve that filename and class name. Removing or disconnecting the target can make the submission ungradable.

The grader uses a clean installation and sets launch environment variables. When `CATINDER_SCENARIO=success`, `CATINDER_SCENARIO=loading`, or `CATINDER_SCENARIO=fail-first`, the app must use a **new** `FixtureCatService`, initialized with `failFirst: true` only for `fail-first` and `false` for the other scenarios. A launch without a scenario must also be usable offline; using this same fixture service by default is permitted. Grading never calls a live service. When `CATINDER_RESET=1`, clear persisted favorites before displaying the first screen. Otherwise retain favorites between terminations and launches. The grader uses the reset flag only on the first launch of a scenario. Never erase favorites merely because the app is relaunched.

The fixture service waits one second per request in `success` and `fail-first`; in `loading` it waits 30 seconds, allowing the pending state to be observed reliably. It returns Milo, Luna, Leo in that order and repeats, and fails its first request in the `fail-first` scenario. An optional breed argument filters the sequence; each filter has its own sequence. `milo` and `leo` are Tabby and `luna` is Siamese. Images are bundled SF Symbols named by each fixture's `imageName`; show the corresponding image in an image view. The UI must remain responsive while a request is pending. Do not edit fixture values or delay, replace the fixture with hard-coded UI responses, or access the network in test scenarios.

## Required behavior

1. Launch on discovery and request the first cat. While a request is pending show `cat.loading` and hide `cat.image` and `cat.name`; after a successful request show `cat.image` and `cat.name`, whose accessibility value is the cat ID. On failure show `cat.error` and `cat.retry`. Tapping retry requests the next result from the same service instance. Only one request may be in flight at a time; disable next, favorite and retry as applicable during loading.
2. Tapping `cat.next` requests another cat. The next successful fixture result replaces the displayed cat. Failed requests leave the app in an error state with retry available.
3. Tapping `cat.favorite` saves the displayed cat once; saving an already saved cat is idempotent. `nav.favorites` opens the favorites screen. An empty screen exposes `favorites.empty`; otherwise each saved cat has an element `favorite.<id>` with accessibility value equal to its ID and a button `favorite.remove.<id>`. Remove deletes that cat. Display favorites vertically in insertion order, earliest at the top; removing then saving again appends it. `nav.discovery` returns to discovery without starting another request. Changing screens must not alter favorites. Navigation controls must remain available while a request is pending.
4. Favorite IDs and their associated displayed cat data must survive app termination and relaunch. Do not rely on UI-test process memory for persistence. The grader will relaunch without `CATINDER_RESET` and verify both retained and removed cats.
5. The controls and indicators named above must be accessible to XCUITest by their exact identifiers. `cat.name` and each `favorite.<id>` must expose the specified accessibility value. Controls must be hittable when their action is available. Layout and visual styling are otherwise open.

## Optional bonus: breed filtering

Expose a `breed.all`, `breed.tabby`, and `breed.siamese` control on discovery. Selecting a filter requests a cat using `nil`, `"tabby"`, or `"siamese"`, respectively. Selection must be reflected in the accessibility value of `breed.selection` as `all`, `tabby`, or `siamese`. Next and retry use the active filter. Persist the active filter across termination and relaunch; a reset restores `all`. Filtering never removes favorites. When switching filters, request the first or next result for that filter from the same fixture service instance. On relaunch a new service starts each filter at its first result.

## Grading: all-or-nothing categories

The grader runs staff-owned XCUITests against the submitted app and checks repository files at the submitted commit. A category earns its listed points only when all its stated assertions pass. Tests may vary interaction sequences and combine published requirements, not invent new requirements. Staff tests are not taken from the student's repository. CI and student tests are useful feedback; neither a green CI badge nor source text earns behavior points.

| Category | Points | Assertions |
|---|---:|---|
| Loading and recovery | 3 | Loading is visible before success and next/favorite are not hittable while loading; successful first cat exposes `cat.image` and has ID `milo`; fail-first shows error and retry returns `milo`. |
| Next cat | 2 | Repeated next actions show `luna`, `leo`, then `milo`. |
| Favorites | 3 | Empty state; add, idempotent re-add, insertion order and remove; navigation preserves discovery. |
| Persistence | 2 | Added cats survive relaunch, and removed cats remain removed after another relaunch. |
| Navigation and accessibility | 1 | Required navigation controls and relevant identifiers are present and hittable; discovery is initially selected. |
| Repository evidence | 1 | Root `PLAN.md` and `AGENT_WORKLOG.md` each exist, decode as UTF-8, and contain at least 100 non-whitespace characters. This checks presence and length only, not quality or authenticity. |
| Bonus: selection | 1 | Three controls select the published filters and expose the selection value. |
| Bonus: filtered next | 1 | Tabby cycles `milo`, `leo`, `milo`; Siamese cycles `luna`. |
| Bonus: persistence | 1 | The selected filter survives a relaunch; reset restores `all`. |
| Bonus: favorites | 1 | Switching filters leaves favorites unchanged and a filtered cat can be saved and removed. |

A failed build is reported as **build or infrastructure error** without a score; staff must diagnose and rerun it. A simulator, grader, or test-infrastructure failure is reported as **infrastructure error**, not interpreted as student failure. The optional bonus is independent and cannot reduce base points. Test output is evidence of what ran; staff should not award a score from a run with an infrastructure error.

### Requirements not scored by the automated checks

The staff UI tests check that the `cat.image` accessibility element exists; they do **not** inspect its pixels or prove that the specified image is rendered. They verify favorite IDs across relaunches, but do not separately inspect persisted image or breed data. The score also does not verify that a student used the supplied service internally, that only one request is in flight, that the UI remains responsive throughout a request, that fixture source was left unchanged, or that the app makes no network calls. The runner does not itself block network access; staff must isolate the grading environment. Students should still implement the requested behavior and comply with the course integrity policy, but these unverified details do not affect the automated score.

## Verification and submission

Run the command in `README.md`, maintain your plan and worklog, and submit as described in `SUBMISSION.md`. The starter tests check the fixture service and basic app launch only; they are not the staff grading suite. Add your own meaningful unit and UI tests for your app, including failure and persistence cases. Follow the course AI disclosure policy; the automated evidence check does not assess compliance or correctness of those disclosures.
