function Z = yeoldlinkage(Y, method)
%LINKAGEOLD Create hierarchical cluster tree using only MATLAB code.

% CD changes are for it to work on in memmap to deal with large data files


n = size(Y,2);
m = ceil(sqrt(2*n)); % (1+sqrt(1+8*n))/2, but works for large n
if isa(Y,'single')
   Z = zeros(m-1,3,'single'); % allocate the output matrix.
else
   Z = zeros(m-1,3); % allocate the output matrix.
end

% during updating clusters, cluster index is constantly changing, R is
% a index vector mapping the original index to the current (row, column)
% index in Y.  N denotes how many points are contained in each cluster.
N = zeros(1,2*m-1);
N(1:m) = 1;
n = m; % since m is changing, we need to save m in n.
R = 1:n;

% Square the distances so updates are easier.  The cluster heights will be
% square-rooted back to the original scale after everything is done.
if any(strcmp(method,{'ce' 'me' 'wa'}))
   Y = Y .* Y;
end
ynan = find(isnan(Y));
ynanf = find(ynan);
for s = 1:(n-1)
    disp(num2str(s));
   if strcmp(method,'av')
      p = (m-1):-1:2;
      I = zeros(m*(m-1)/2,1);
      I(cumsum([1 p])) = 1;
      I = cumsum(I);
      J = ones(m*(m-1)/2,1);
      J(cumsum(p)+1) = 2-p;
      J(1)=2;
      J = cumsum(J);
      W = N(R(I)).*N(R(J));
      [v, k] = min(Y./W,[],'omitnan');
   else
      [v, k] = min(Y,[],'omitnan');
   end

   i = floor(m+1/2-sqrt(m^2-m+1/4-2*(k-1)));
   j = k - (i-1)*(m-i/2)+i;

   Z(s,:) = [R(i) R(j) v]; % update one more row to the output matrix A

   % Update Y. In order to vectorize the computation, we need to compute
   % all the indices corresponding to cluster i and j in Y, denoted by I
   % and J.
   I1 = 1:(i-1); I2 = (i+1):(j-1); I3 = (j+1):m; % these are temp variables
   U = [I1 I2 I3];
   I = [I1.*(m-(I1+1)/2)-m+i i*(m-(i+1)/2)-m+I2 i*(m-(i+1)/2)-m+I3];
   J = [I1.*(m-(I1+1)/2)-m+j I2.*(m-(I2+1)/2)-m+j j*(m-(j+1)/2)-m+I3];
   
   % need to update indexing of I and J
   
       for id = ynanf'
           for tj = 1:numel(J)
               thisj = J(tj);
               if thisj>id
                   J(tj) = J(tj)+1;
               end
           end
           for ti = 1:numel(I)
               thisi = I(ti);
               if  thisi>id
                   I(ti) = I(ti)+1;
               end
           end
           
       end
   
   

%        for jd = 1:numel(J)
%            disp(num2str(jd))
%            tj = J(jd);
%            breaker=0;
%            st =1;
%             while breaker==0
%                 tjold = tj;
%                 tj = tj+sum(ynan(st:tj));
%                 st = tjold;
%                 if tj==tjold
%                     J(jd) = tj;
%                     breaker = 1;
%                 end
%             end
%        end
% 
%        for id = 1:numel(I)
%            ti = I(id);
%            breaker=0;
%            st=1;
%             while breaker==0
%                 tjold = ti;
%                 ti = ti+sum(ynan(st:ti));
%                 st = tjold;
%                 if tj==tjold
%                     J(id) = ti;
%                     breaker = 1;
%                 end
%             end
%        end
   
   %YI = memmapfile(Y.Filename, %need to create memmap to these regions to reduce memory load
   %YJ = %need to create memmap to these regions to reduce memory load
   switch method
   case 'si' % single linkage
      Y(I) = min(Y(I),Y(J));
   case 'co' % complete linkage
      Y(I) = max(Y(I),Y(J));
   case 'av' % average linkage
      Y(I) = Y(I) + Y(J);
   case 'we' % weighted average linkage
      Y(I) = (Y(I) + Y(J))/2;
   case 'ce' % centroid linkage
      K = N(R(i))+N(R(j));
      Y(I) = (N(R(i)).*Y(I)+N(R(j)).*Y(J)-(N(R(i)).*N(R(j))*v)./K)./K;
   case 'me' % median linkage
      Y(I) = (Y(I) + Y(J))/2 - v /4;
   case 'wa' % Ward's linkage
      Y(I) = ((N(R(U))+N(R(i))).*Y(I) + (N(R(U))+N(R(j))).*Y(J) - ...
	  N(R(U))*v)./(N(R(i))+N(R(j))+N(R(U)));
   end
   Jnew = single(i*(m-(i+1)/2)-m+j);
   
   
       for id = ynanf'
           Jnew(Jnew>id) = J(J>id)+1;
       end
   
   J = [J Jnew];
   
   Y(J) = nan; % no need for the cluster information about j. 
   ynan(J) = true;
   ynanf = find(ynan);
   % update m, N, R
   m = m-1;
   N(n+s) = N(R(i)) + N(R(j));
   R(i) = n+s;
   R(j:(n-1))=R((j+1):n);
end

if any(strcmp(method,{'ce' 'me' 'wa'}))
   Z(:,3) = sqrt(Z(:,3));
end

Z(:,[1 2])=sort(Z(:,[1 2]),2);



function Z = rearrange(Z)
     %Get indices to sort Z
     %Make sure the last row of Z won't be moved to any other rows.
    [~,idx] = sort(Z(1:end-1,3));
    nrows=size(Z,1);
    idx = [idx; nrows]; 
  
    % Get indices in the reverse direction
    revidx(idx) = 1:length(idx);
    
    % Get vector of desired cluster numbers for Z2
   
    v2 = [1:nrows+1,nrows+1+revidx];
    
    % Put Z2 into sorted order, without renumbering the clusters
    Z = Z(idx,:);
    
    % Renumber the clusters
    Z(:,1:2) = v2(Z(:,1:2));
    % Make sure the lower-numbered cluster is in column 1
   
    % is Z in chronological order?
    if any(max(Z(:,[1  2]),[],2) > ((nrows+1):(nrows+nrows))')
           Z = fixnonchronologicalZ(Z);
    end
   t = Z(:,1)>Z(:,2);
   Z(t,1:2) = Z(t,[2 1]);
   
   function Z = fixnonchronologicalZ(Z)
% Fixes a binary tree that has branches defined in a non-chronological order  
 
nl = size(Z,1)+1; % number of leaves
nb = size(Z,1); % number of branches
last = nl; % last defined node, we start only with leaves
for i = 1:nb-1
    tn = nl+i; %this node
    if any(Z(i,[1,2])>last)
        % this node (tn) uses nodes not defined yet, find a node (h) that
        % does use nodes already defined so we can interchange them:
        h = find(all(Z(i+1:end,[1 2])<=last,2),1)+i;
        % change nodes:
        Z([i h],:) = Z([h i],:);
        nn = nl+h; % new node
        % change references to such nodes
        to_nn = find(Z(1:2*nb) == tn,1);
        to_tn = find(Z(1:2*nb) == nn,1);
        Z(to_nn) = nn;
        Z(to_tn) = tn;         
    end
    last = tn;
end
