sv = StochVolModel;
params = [-0.7, 0.9, 0.4];

length = 100;
traj = sv.generate_trajectory(params, length, true, RandStream("mt19937ar", "Seed", 1));
volatiles = sv.get_volatiles(traj, params);

time = 1:length;
plot(time, traj.endog, time, volatiles)
legend('log returns', 'volatiles')
