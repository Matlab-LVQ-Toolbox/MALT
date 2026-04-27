# MALT

**MALT** is the **Matlab LVQ Toolbox**.

This repository is the **canonical reference implementation** of MALT. It defines the ground-truth behaviour against which the future Python and R editions are validated.

`MALT` started as [A no-nonsense beginner’s tool for GMLVQ](https://www.cs.rug.nl/~biehl/gmlvq.html), and its maintenance and development were taken over by Roland Veen in 2021. The first release of the new package is now underway.

## Design goal

The purpose of `malt` is to provide a MATLAB toolbox for LVQ and variants, set up in a modular, object-oriented fashion. 

We are careful to standardize the following aspects:
- API design
- algorithmic semantics
- default parameter behavior
- training and inference behaviour
- numerical conventions
- expected results on reference test cases

## Intended audience

MALT is intended for:
- researchers
- students
- scientific programmers
- users who value interpretable LVQ methods

## Repository structure

- `+GMLVQ/` Library namespace 
- `manual` the manual
- `samplesData/` example datasets in .mat format

## Citation

If you use MALT in academic work, please cite the software DOI and the relevant core publication(s). See `CITATION.cff` for the preferred citation metadata.

[![DOI](https://zenodo.org/badge/798309171.svg)](https://doi.org/10.5281/zenodo.19829779)

## Status

MALT is in the process of being standardized, optimized and extended with different variants of LVQ. Other language versions with compatible API and numerically similar output are planned.
