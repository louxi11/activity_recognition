function encoded = oneOfNendcoding( data )
%ONE_OF_N_ENDCODING Summary of this function goes here
%   Detailed explanation goes here

assert(isrow(data)) % data must be a row vector

encoded = zeros(2,length(data));
for i = 1 : length(data)
    encoded(data(i),i) = 1;
end

encoded = encoded(:)'; % output a row vector with 1-of-n encoding