% Test B-function #1
smm_method = WSMMEstimator;
smm_method.length_cycle_weight = 3;

A = [[0 0 3];[4 5 6];[5 -7 0];[3 -1 3]];


funct_value = smm_method.compute_B_matrix(A);

%compute Q
Q0 = (A(1,:).'*A(1,:) + A(2,:).'*A(2,:) + A(3,:).'*A(3,:) + A(4,:).'*A(4,:))/4;
Q1 = (A(2,:).'*A(1,:) + A(3,:).'*A(2,:) + A(4,:).'*A(3,:))/4;
Q2 = (A(3,:).'*A(1,:) + A(4,:).'*A(2,:))/4;
Q3 = (A(4,:).'*A(1,:))/4;
%compute w
w13 = (3+1-1)/(3+1);
w23 = (3+1-2)/(3+1);
w33 = (3+1-3)/(3+1);

real_value = Q0 + w13 * (Q1 + Q1.') + w23 * (Q2 + Q2.') + w33 * (Q3 + Q3.');

assert_matrix = real_value == funct_value;
disp('Test 1')
disp(all(assert_matrix(:)))


% Test B-function #2
A = [[0 0 0 0];[4 5 6 2];[5 -7 0 6];[3 -1 3 5]; [4 8 2 0]];

smm_method = WSMMEstimator;
smm_method.length_cycle_weight = 4;
funct_value = smm_method.compute_B_matrix(A);

%compute Q
Q0 = (A(1,:).'*A(1,:) + A(2,:).'*A(2,:) + A(3,:).'*A(3,:) + A(4,:).'*A(4,:) + A(5,:).'*A(5,:))/5;
Q1 = (A(2,:).'*A(1,:) + A(3,:).'*A(2,:) + A(4,:).'*A(3,:) + A(5,:).'*A(4,:))/5;
Q2 = (A(3,:).'*A(1,:) + A(4,:).'*A(2,:) + A(5,:).'*A(3,:) )/5;
Q3 = (A(4,:).'*A(1,:) + A(5,:).'*A(2,:))/5;
Q4 = (A(5,:).'*A(1,:))/5;

%compute w
w14 = (4+1-1)/(4+1);
w24 = (4+1-2)/(4+1);
w34 = (4+1-3)/(4+1);
w44 = (4+1-4)/(4+1);

real_value = Q0 + w14 * (Q1 + Q1.') + w24 * (Q2 + Q2.') + w34 * (Q3 + Q3.') +  w44 * (Q4 + Q4.');
assert_matrix = real_value == funct_value;
disp('Test 2')
disp(all(assert_matrix(:)))


% Test B-function #3
A = [[0 0 0 0];[4 5 6 2];[5 -7 0 6];[3 -1 3 5]; [4 8 2 0]];

smm_method = WSMMEstimator;
smm_method.length_cycle_weight = 3;
funct_value = smm_method.compute_B_matrix(A);

%compute Q
Q0 = (A(1,:).'*A(1,:) + A(2,:).'*A(2,:) + A(3,:).'*A(3,:) + A(4,:).'*A(4,:) + A(5,:).'*A(5,:))/5;
Q1 = (A(2,:).'*A(1,:) + A(3,:).'*A(2,:) + A(4,:).'*A(3,:) + A(5,:).'*A(4,:))/5;
Q2 = (A(3,:).'*A(1,:) + A(4,:).'*A(2,:) + A(5,:).'*A(3,:) )/5;
Q3 = (A(4,:).'*A(1,:) + A(5,:).'*A(2,:))/5;

%compute w
w13 = (3+1-1)/(3+1);
w23 = (3+1-2)/(3+1);
w33 = (3+1-3)/(3+1);

real_value = Q0 + w13 * (Q1 + Q1.') + w23 * (Q2 + Q2.') + w33 * (Q3 + Q3.');
assert_matrix = real_value == funct_value;
disp('Test 3')
disp(all(assert_matrix(:)))
