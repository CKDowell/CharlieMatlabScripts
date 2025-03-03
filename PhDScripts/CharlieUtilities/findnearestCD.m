function i = findnearestCD(refarray,searcharray,randselection)
% Function finds the nearest values in an vector. It requires creating what
% can be a large matrix so will be slow for large values.

%NB only works for 1D ref and search arrays
if nargin==2
    randselection=false;
end
A = refarray;
B = searcharray;

% Clip the size of A/B
% Can improve, there is a problem with sorting that isn't worth my time at
% the moment

%B = B(B>min(A));
%clipmin = sum(B>min(A));
%B = B(B<max(A));

%Make sure A is column vector and B is a row vector
if size(A,2)>1
    A = A';
end
if size(B,1)>1
B = B';
end

B = repmat(B,size(A,1),1);
delta = abs(B-A);

[v,i] = min(delta,[],2,'omitnan');
i(isnan(refarray)) = nan; %returns nan if not there
if randselection
    for s = 1:numel(v)
        [~,eq] = find(delta(s,:)==v);
        if eq==1
            continue
        else
            ran = randperm(numel(eq),1);
            i(s) = eq(ran);
        end
    end
end
%i = i+clipmin;
end