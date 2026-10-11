---
name: unit-tester
description: Use when writing, reviewing, or refactoring unit tests, or when deciding what to test and how. Applies Vladimir Khorikov's unit testing principles (classical school, four pillars, observable behavior over implementation details, mocks only at system boundaries) and enforces an 85% coverage floor without treating coverage as a goal. Includes Python/pytest specifics.
---

# Unit Tester (Khorikov principles)

Goal of unit tests: **sustainable growth of the project**. Not coverage, not test count.
A test that doesn't protect a business requirement is a liability: it costs maintenance and returns nothing.

## 1. Unit = unit of behavior
- Follow the **classical (Detroit) school**: a unit is a piece of behavior meaningful to the domain, not a class or function. It may span several classes.
- Use real collaborators. Isolate tests from *each other* (no shared mutable state), not code from its collaborators.
- Name tests in plain language describing the behavior: `test_delivery_with_past_date_is_invalid`, not `test_is_delivery_valid_returns_false`.

## 2. Four pillars
Every test is judged on:
1. Protection against regressions
2. **Resistance to refactoring** (non-negotiable: a test must not fail when behavior is unchanged)
3. Fast feedback
4. Maintainability

You trade off 1 vs 3 (unit vs integration). Never trade away 2.

## 3. Observable behavior, not implementation details
- Observable behavior = operations or state that help the *client* achieve its goal. Everything else is an implementation detail.
- Assert on the end result, never on the steps taken to produce it.
- Never test private methods directly. If one is complex enough to need it, it's a missing abstraction; extract it into its own class/module.
- Don't leak domain knowledge into tests (don't re-implement the algorithm to compute `expected`; hardcode the expected value).
- Bad public API (exposed internals, leaky setters) produces bad tests. Fix the API.

## 4. Testing styles, in order of preference
1. **Output-based**: call with input, check return value. Best on all pillars.
2. **State-based**: act, then check the resulting state through the public API.
3. **Communication-based** (mocks verifying calls): only at system boundaries (see §5).

Design for output-based tests: a functional core with side effects pushed to the edges.

## 5. Mocks
- **Managed dependencies** (your own DB, only your app talks to it) are implementation details. Use the real thing in integration tests, don't mock.
- **Unmanaged dependencies** (SMTP, payment gateway, third-party API, message bus others consume) are observable behavior. Mock them, and only at the outermost edge of the system.
- **Never mock intra-system communication** (calls between your own classes). Needing to do so is a design smell.
- Stubs (return canned data) are fine for incoming data, but **never assert on calls made to stubs**.
- Mock types you own (a thin adapter over the third-party client), not the third-party library directly.

## 6. What to test: the four quadrants
Classify code by **complexity or domain significance** vs **number of collaborators**:

| | Few collaborators | Many collaborators |
|---|---|---|
| **Complex / domain-significant** | Domain model, algorithms: **unit test thoroughly** | Overcomplicated: **refactor first** (split it) |
| **Trivial** | **Don't test** | Controllers: **integration test** (happy path + critical edge cases) |

- Code should be **deep or wide, never both** (humble object pattern): logic goes in the domain layer, orchestration stays thin.
- Trivial getters/setters, plain data containers, and pass-through code need no tests of their own.

## 7. Test structure
- **Arrange / Act / Assert**, separated by blank lines. No comments labelling the sections.
- Act is **one line**. If it takes more, the API is leaking: the client must call multiple things to reach one goal.
- One behavior per test; multiple asserts are fine if they check that one behavior.
- No `if`/loops in tests. Branching means it's two tests.
- Arrange: prefer private factory functions over shared fixtures that couple tests together.
- Call the system under test `sut` when it isn't obvious.

## 8. Coverage: a floor, not a target
- Coverage is a **negative indicator only**: low coverage proves a problem; high coverage proves nothing.
- Enforce a **minimum of 85% (line + branch)**. If below, add tests for **untested domain logic and edge cases first**. Never reach the number with trivial or implementation-coupled tests.
- If the only way to reach 85% is testing trivial code, exclude that code explicitly (with a reason) rather than writing worthless tests.
- Above 85%, stop optimizing coverage. Spend effort on pillar quality instead.

## Workflow

### When writing tests
1. Identify the observable behaviors from the requirements/public API.
2. Classify the code by quadrant (§6). Refactor overcomplicated code before testing it, and tell the user.
3. Write tests: output-based where possible, mocks only for unmanaged deps.
4. Run with coverage. If below 85%, find the gaps that are real behaviors and fill them.

### When reviewing tests
Report problems first, ordered by severity. For each: what's wrong, which principle/pillar it violates, the fix. Check for:
- Assertions on internal calls, call order, or private state (breaks refactoring resistance)
- Mocks of the project's own classes
- Asserting interactions with stubs
- Tests of trivial code, or controllers heavily unit tested with mocks
- Re-implemented logic in expected values
- Multi-line Act, logic in tests, shared mutable fixtures
- Coverage below 85%, or coverage padded with trivial tests
- Missing tests for domain logic and edge cases

## Python specifics
- Use **pytest**: plain `assert`, `@pytest.mark.parametrize` for input/output tables (ideal for output-based tests).
- Coverage via **pytest-cov** with branch coverage and the floor enforced:
  `pytest --cov=<package> --cov-branch --cov-report=term-missing --cov-fail-under=85`
  Persist it in `pyproject.toml` (`[tool.coverage.run] branch = true`, `[tool.coverage.report] fail_under = 85`).
- Exclude genuinely trivial code with `# pragma: no cover` sparingly, or via `exclude_also` in coverage config (e.g. `if TYPE_CHECKING:`, `raise NotImplementedError`).
- Fixtures: keep them local to the test module and shallow. Prefer plain factory functions (`make_order(...)`) for Arrange; reserve fixtures for resource setup/teardown (`tmp_path`, DB connections). Don't build deep fixture chains in `conftest.py`.
- Mocks (unmanaged deps only): use `create_autospec` / `autospec=True` so signature changes fail loudly. Prefer **dependency injection** (pass the client/clock in) over `mock.patch`; if you must patch, patch where the name is *looked up*, not where it's defined.
- Hand-written fakes (e.g. an in-memory class satisfying a `typing.Protocol`) are often clearer than `MagicMock`.
- Time and randomness are unmanaged: inject them (`now: Callable[[], datetime]`) instead of patching `datetime`.
- Don't test `_private` functions or access `obj._attr` in asserts.
- FastAPI controllers: integration test through `TestClient` with real managed deps (test DB), override only unmanaged deps via `app.dependency_overrides`.
