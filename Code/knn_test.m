clear;
load fisheriris;
measT=meas';
X = zeros(32,150);

for i=1:4
    x_min = min(meas(:,i));
    x_max = max(meas(:,i));
    X(i,:) = (meas(:,i)' - x_min)/(x_max - x_min);
end

oriX = X; oriSpecies = species;
testpoints = 5;
testSetidx = randperm(150,testpoints);
testSet = X(:,testSetidx);      %%% Test set for knn
X(:,testSetidx) = [];
sampleset = X;                  %%% Sample set for knn
X = horzcat(X,testSet);
target = species(testSetidx);   %%% Targets for knn
species(testSetidx) = [];
species = vertcat(species, repmat(cellstr('query point'),testpoints,1));

[prob_2, O_2, Average_ct_2, Max_ct_2, Phi_2, NZ_2] = fjlt1_inequality(150,2,32,0.45,X);
[prob_3, O_3, Average_ct_3, Max_ct_3, Phi_3, NZ_3] = fjlt1_inequality(150,3,32,0.45,X);

tpX2 = Phi_2*X;
tpX3 = Phi_3*X;
pX2 = zeros(2,150);
pX3 = zeros(3,150);

for i=1:2
    x_min = min(tpX2(i,:));
    x_max = max(tpX2(i,:));
    pX2(i,:) = (tpX2(i,:) - x_min)/(x_max - x_min);
end

for i=1:3
    x_min = min(tpX3(i,:));
    x_max = max(tpX3(i,:));
    pX3(i,:) = (tpX3(i,:) - x_min)/(x_max - x_min);
end

[Phi_4,prob_4,Average_ct_4,Max_ct_4] = fjlt2_prep(150,4,32,16,X,0.45);
[Phi_5,prob_5,Average_ct_5,Max_ct_5] = fjlt2_prep(150,5,32,16,X,0.45);

tpX4 = Phi_4*X;
tpX5 = Phi_5*X;
pX4 = zeros(4,150);
pX5 = zeros(5,150);

for i=1:4
    x_min = min(tpX4(i,:));
    x_max = max(tpX4(i,:));
    pX4(i,:) = (tpX4(i,:) - x_min)/(x_max - x_min);
end

for i=1:5
    x_min = min(tpX5(i,:));
    x_max = max(tpX5(i,:));
    pX5(i,:) = (tpX5(i,:) - x_min)/(x_max - x_min);
end

timestamp = datestr(now, 'dd-mm-yy_HH-MM-SS-FFF');
%mkdir(['results/knn/',timestamp]);
dir = ['results/knn/',timestamp];

figure()
hold on
gscatter(X(1,:),X(2,:),species,'rgbk','osdx',[6,6,6,10]);
title('Original Plot')
xlabel('Sepal length')
ylabel('Sepal width')
hold off
%saveas(gca, strcat(dir, 'original.png'));

figure()
hold on
gscatter(pX2(1,:),pX2(2,:),species,'rgbk','osdx',[6,6,6,10]);
title('FJLT 1 with k = 2')
xlabel('x1')
ylabel('x2')
hold off
%saveas(gca, strcat(dir, '_FJLT_1_k2.png'));

figure()
hold on
gscatter(pX3(1,:),pX3(2,:),species,'rgbk','osdx',[6,6,6,10]);
title('FJLT 1 with k = 3')
xlabel('x1')
ylabel('x2')
hold off
%saveas(gca, strcat(dir, '_FJLT_1_k3.png'));

figure()
hold on
gscatter(pX4(1,:),pX4(2,:),species,'rgbk','osdx',[6,6,6,10]);
title('FJLT 2 with k = 4')
xlabel('x1')
ylabel('x2')
hold off
%saveas(gca, strcat(dir, '_FJLT_2_k4.png'));

figure()
hold on
gscatter(pX5(1,:),pX5(2,:),species,'rgbk','osdx',[6,6,6,10]);
title('FJLT 2 with k = 5')
xlabel('x1')
ylabel('x2')
hold off
%saveas(gca, strcat(dir, '_FJLT_2_k5.png'));


