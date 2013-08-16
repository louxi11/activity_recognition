%%
load test_data/word_recognition/Part2Sample.mat

%%

w_trans = sampleFeatureCounts(params.idx_w_tran);
m_trans = reshape(w_trans,params.numStateYZ,params.numStateYZ);
m_trans = m_trans';
sampleFeatureCounts(params.idx_w_tran) = m_trans(:)';

%%
isequal(sampleFeatureCounts',phi)

%%
theta_trans = theta(end-26*26+1:end);
m_trans = reshape(theta_trans,Num_state,Num_state);
m_trans = m_trans';
theta(end-26*26+1:end) = m_trans(:)';

%% test constrantCB with theta and factor
load test_data/word_recognition/theta_factor
model.w=theta';
for i = 1 : length(factor)
  sum(factor(i).val-factors(i).val)
end


