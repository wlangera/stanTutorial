
data {
  int n_schools;
  array[n_schools] real y;
  vector<lower = 0>[n_schools] sigma;
}


parameters {
  real mu;
  real<lower = 0> tau;
}

model {
  mu ~ normal(5, 3);
  tau ~ normal(0, 10);

  y ~ normal(mu, sqrt(square(tau) + square(sigma)));
}

generated quantities {
  vector[n_schools] theta;
  for (i in 1:n_schools) {
	real conjugate_variance =  1 / (1 / square(sigma[i]) + 1 / square(tau));
	real conjugate_mean_num = ((y[i] / square(sigma[i])) + mu / square(tau));
	real conjugate_mean_denom = ((1 / square(sigma[i])) + 1 / square(tau));
	
	theta[i] = normal_rng(conjugate_mean_num / conjugate_mean_denom, sqrt(conjugate_variance));
  }
}
