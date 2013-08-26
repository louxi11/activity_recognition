%% C
errorbar(X,mean(a),std(a),'b','LineWidth',2)
axis([0,3.5,0,92])
xlabel('epsilon')
ylabel('number of support vectors')
legend('SV training')
%% E
X = [0.01,0.1:0.1:1];
errorbar(X,mean(a),std(a),'b','LineWidth',2)
axis([0,1,0,92])
xlabel('C (N_z=1,epsilon=0.5)')
ylabel('number of support vectors')
legend('SV training')