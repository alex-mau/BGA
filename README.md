# Bregman Generalized Subgradient Projected Algorithms

## Overview

This repository contains the implementation of Bregman Generalized Subgradient Projected Algorithms, which are developed as part of a graduate thesis titled "Bregman generalized subgradient projected algorithms and applications" by Xiaoyu Mao. The algorithms are designed to address the computational complexity of the projection operator in constrained minimization problems by utilizing Bregman distances.

## Thesis

**Title:** Bregman generalized subgradient projected algorithms and applications  
**Author:** Xiaoyu Mao  
**Degree:** Master of Science  
**Institution:** The University of British Columbia (Okanagan)  
**Year:** 2023

## Abstract

Projected subgradient methods are ideal for constrained minimization problems but are often hampered by the computational complexity of the projection operator. The generalized Bregman distance offers a solution to this issue. This thesis provides an in-depth analysis and conducts numerical experiments on projected subgradient methods utilizing Bregman distances. It extends the mirror descent algorithm to two-block situations, increases its applicability, and provides convergence proofs.

## Applications

### Simplex constrained generalized LASSO regression
Generalized LASSO regression is to perform regression analysis with a constraint that the solution lies within a unit simplex. The Bregman generalized subgradient algorithm is employed to handle the simplex constraint more efficiently than traditional methods. Numerical experiments demonstrate that this approach significantly reduces computation time while maintaining accurate regression results.

### Bounded Simplex Structured Matrix Factorization
In this application, matrix factorization is performed with the constraint that the factor matrices are bounded and lie within a unit simplex. This is particularly useful for tasks such as image compression and collaborative filtering. The Bregman distance is used to simplify the projection onto the unit simplex, which is computationally more efficient than the Euclidean projection. The results show that the Bregman generalized algorithm achieves faster convergence and better performance in preserving the structure of the original matrix.

### Projected Gradient Interior Point Method
This application involves solving optimization problems with complex constraints using the projected gradient interior point method. This method integrates the Bregman generalized subgradient algorithm to handle constraints more effectively, particularly when the feasible domain is non-trivial, such as in the case of a bounded simplex or other structured sets. The application showcases significant improvements in solving large-scale optimization problems, with numerical experiments validating the enhanced performance and reduced computation time.

## Repository Structure

- `src/`: Contains the implementation of the algorithms.
- `examples/`: Contains example applications and numerical experiments.
- `LICENSE`: The license for the repository.
