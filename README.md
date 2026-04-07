# MALT

**MALT** is the **Matlab LVQ Toolbox**.

This repository is the **canonical reference implementation** of MALT. It defines the ground-truth behaviour against which the future Python and R editions are validated.

`MALT` started as [A no-nonsense beginner’s tool for GMLVQ](https://www.cs.rug.nl/~biehl/gmlvq.html), and its maintenance and development were taken over by Roland Veen in 2021. The first release of the new package is now underway.

## Position in the MALT ecosystem

MALT will consist of three closely related repositories:

- [`MALT`](https://github.com/Matlab-LVQ-Toolbox/MALT): canonical MATLAB implementation
- [`MALT-PE`](https://github.com/MALT/maltpe): Python edition
- [`MALT-RE`](https://github.com/MALT/maltre): R edition

In the MALT ecosystem, **MATLAB is the source of truth**.

## Design goal

The purpose of `malt` is not only to provide a MATLAB toolbox for LVQ, but also to define the reference behaviour for cross-language implementations.

This includes:
- API design
- algorithmic semantics
- default parameter behavior
- training and inference behaviour
- numerical conventions
- expected results on reference test cases

## Ground-truth policy

`MALT-PE` and `MALT-RE` are expected to reproduce the behaviour of `MALT` within documented numerical tolerance.

Discrepancies beyond tolerance will be treated as implementation bugs unless explicitly documented.

## Conformance dimensions

Cross-language conformance is evaluated along three dimensions:

1. **API conformance**  
   Matching function names, argument semantics, defaults, and return values.

2. **Behavioral conformance**  
   Matching predictions, losses, learned quantities, and edge-case handling.

3. **Numerical conformance**  
   Matching outputs within documented floating-point tolerance.

## Intended audience

MALT is intended for:
- researchers
- students
- scientific programmers
- users who value interpretable LVQ methods
- developers who need consistent behaviour across MATLAB, Python, and R

## Repository structure

Future structure:

- `src/` or MATLAB package folders for implementation
- `tests/` for MATLAB tests
- `testdata/` for golden inputs and expected outputs
- `spec/` for canonical API and behaviour definitions
- `docs/` for algorithms, numerics, and compatibility notes

## Citation

If you use MALT in academic work, please cite the software DOI and the relevant core publication(s). See `CITATION.cff` (will be added soon) for the preferred citation metadata.

## Status

MALT is the reference implementation and evolves first. New features should land here before being ported downstream.
