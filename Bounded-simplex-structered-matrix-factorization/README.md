# Bounded Simplex-Structered Matrix Factorization (BSSMF)

This code in MATLAB allows you to solve the BSSMF optimization problem: 
Given a matrix $`X\in\mathbb{R}^{m\times n}`$, a factorization rank $`r`$, and an interval $`[a,b]`$ in $`\mathbb{R}^m`$, 
solve
```math
\begin{equation*}
\begin{split}
       &\min_{W,H} ||X-WH||_F^2 \\

       \text{s.t. } &a \leq W \leq b,\\
       & H \geq 0, H^\top e=e, 
\end{split}
\end{equation*}
```

where $`e`$ is the vector of all ones of appropriate dimension and the inequalities constraints for $`W`$ and $`H`$ are element-wise.

* The function of main interest is in `src/boundedSSMF.m`
* `install.m` adds all these folders to MATLAB search path for the current session.
* Some tests are provided in `test/` and are made for the MNIST dataset (not provided here). In order to run them, `mnist.mat` and `mnist_labels.mat` should be in `../datasets`
