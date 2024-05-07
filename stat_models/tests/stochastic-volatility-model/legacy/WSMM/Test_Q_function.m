% Test Q-function #1
smm_method = WSMMEstimator;
A = [[0 0 3];[4 5 6];[5 -7 0];[3 -1 3]];

funct_value = smm_method.compute_Q_matrix(A,0);
real_value = (A(1,:).'*A(1,:) + A(2,:).'*A(2,:) + A(3,:).'*A(3,:) + A(4,:).'*A(4,:))/4;
assert_matrix = real_value == funct_value;
disp('For j=0 check')
disp(all(assert_matrix(:)))


funct_value = smm_method.compute_Q_matrix(A,1);
real_value = (A(2,:).'*A(1,:) + A(3,:).'*A(2,:) + A(4,:).'*A(3,:))/4;
assert_matrix = real_value == funct_value;
disp('For j=1 check')
disp(all(assert_matrix(:)))


funct_value = smm_method.compute_Q_matrix(A,2);
real_value = (A(3,:).'*A(1,:) + A(4,:).'*A(2,:))/4;
assert_matrix = real_value == funct_value;
disp('For j=2 check')
disp(all(assert_matrix(:)))

funct_value = smm_method.compute_Q_matrix(A,3);
real_value = (A(4,:).'*A(1,:))/4;
assert_matrix = real_value == funct_value;
disp('For j=3 check')
disp(all(assert_matrix(:)))


% Test Q-function #2
smm_method = WSMMEstimator;
A = [[0 0 0 0];[4 5 6 2];[5 -7 0 6];[3 -1 3 5]; [4 8 2 0]];

funct_value = smm_method.compute_Q_matrix(A,0);
real_value = (A(1,:).'*A(1,:) + A(2,:).'*A(2,:) + A(3,:).'*A(3,:) + A(4,:).'*A(4,:) + A(5,:).'*A(5,:))/5;
assert_matrix = real_value == funct_value;
disp('For j=0 check')
disp(all(assert_matrix(:)))


funct_value = smm_method.compute_Q_matrix(A,1);
real_value = (A(2,:).'*A(1,:) + A(3,:).'*A(2,:) + A(4,:).'*A(3,:) + A(5,:).'*A(4,:))/5;
assert_matrix = real_value == funct_value;
disp('For j=1 check')
disp(all(assert_matrix(:)))


funct_value = smm_method.compute_Q_matrix(A,2);
real_value = (A(3,:).'*A(1,:) + A(4,:).'*A(2,:) + A(5,:).'*A(3,:) )/5;
assert_matrix = real_value == funct_value;
disp('For j=2 check')
disp(all(assert_matrix(:)))


funct_value = smm_method.compute_Q_matrix(A,3);
real_value = (A(4,:).'*A(1,:) + A(5,:).'*A(2,:))/5;
assert_matrix = real_value == funct_value;
disp('For j=3 check')
disp(all(assert_matrix(:)))

funct_value = smm_method.compute_Q_matrix(A,4);
real_value = (A(5,:).'*A(1,:))/5;
assert_matrix = real_value == funct_value;
disp('For j=4 check')
disp(all(assert_matrix(:)))