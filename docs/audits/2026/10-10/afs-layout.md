# AFS layout migration

The isolated checkout pulled `origin main` before changes. Three shared
authoring assets moved from `docs/templates/` to `tools/project-scaffold/` and
remain byte-identical to baseline `d2cfa2ea3aed9ffa7383e98f0c38bf5c79ed1f9a`.
The owner README explains how their completed content belongs beside an experiment.
Root catalogs record navigation, provenance and verification limits.

Verification: compare all three Git blobs, check the new local links and run
`git diff --check`. No experiment, application suite, dependency installation,
CI change or build was run.
