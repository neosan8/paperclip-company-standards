# Researcher Skills

---

## sector-research

**Purpose:** Produce a structured brief on a sector topic, competitor pattern, or technology area.

**Pattern:**
1. Run gbrain query first. If the vault already has a recent brief (less than 30 days old) on the topic, reference it and note staleness rather than repeating the work.
2. Identify 3-5 primary sources (official docs, peer-reviewed papers, verified practitioner posts).
3. Identify 2-3 community signals (X/community discussions from the last 90 days).
4. Synthesize into the brief format defined in `research-pattern.md`.
5. Note confidence level per finding: high (multiple independent sources agree), medium (single credible source), low (community signal only, unverified).

---

## frontier-scan

**Purpose:** Periodic scan of the frontier for tools, techniques, or patterns relevant to the company domain. Run when CEO assigns a "frontier check" issue.

**Scope guidance:**
- For a game company: scan for new Unity AI tools, mobile game mechanic innovations, CTR creative patterns.
- For a central company (Dev, Art, Lab): scan for relevant tooling advances, new open-source patterns, emerging standards.

**Output:** a brief summarizing what is new, what is noise, and what warrants a follow-up Worker implementation issue.

---

## source-vetting

**Purpose:** Evaluate whether a source is trustworthy enough to cite in a brief.

**Criteria:**

| Criterion | Check |
|-----------|-------|
| Recency | Published or updated within 12 months for fast-moving topics; 24 months for stable topics |
| Authority | Author or org is a known practitioner, official maintainer, or peer-reviewed venue |
| Independence | At least 2 of the top 3 sources are independent (not citing each other as their only basis) |
| Verifiability | The claim can be reproduced or cross-checked |

**Rule:** Never cite a source that fails the recency or authority check without explicitly flagging it as low-confidence in the brief.

---

## paper-search

**Purpose:** Find relevant academic or technical papers via Hugging Face papers, arXiv, or similar.

Use for:
- AI/ML technique research (especially for Lab company or art-generation workflows).
- Academic backing for a pattern being considered for adoption.

Output: 1-3 relevant papers with title, author, venue, abstract summary, and relevance note.

---

## community-read

**Purpose:** Read community signals on X, Discord, or dev forums.

Use `bird read <id>` (never `bird tweet`) for X post fetching.
Use WebFetch for Discord/forum threads.

Community signals are rated low-confidence unless corroborated by a primary source. Always note the community source separately from primary sources in the brief.
