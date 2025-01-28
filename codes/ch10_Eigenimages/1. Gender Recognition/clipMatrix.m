function BClipped = clipMatrix(B)

% Find eigenvalues and eigenvectors for B
[V_B, D_B] = eig(B);
d = size(B,1);
eigenvalues_B = zeros(1,d);
for nEig = 1:d
    eigenvalues_B(nEig) = D_B(nEig,nEig);
end % nEig
[eigenvaluesSort_B, sortIdx_B] = sort(eigenvalues_B, 'descend');
VSort_B = zeros(d,d);
DSort_B = zeros(d,d);
for nEig = 1:d
    VSort_B(:,nEig) = V_B(:,sortIdx_B(nEig));
    DSort_B(nEig,nEig) = eigenvaluesSort_B(nEig);
end % nEig

% Clip eigenvalues of B
clipFrac = 0.2;
fracPower = zeros(1,d);
for nEig = 1:d
    fracPower(nEig) = sum( eigenvaluesSort_B(nEig:end) );
end % nEig
fracPower = fracPower / fracPower(1);
idxFind = find(fracPower <= clipFrac);
idxR = min(idxFind);
for nEig = 1:d
    DSort_B(nEig,nEig) = max(DSort_B(nEig,nEig), eigenvaluesSort_B(idxR));
end % nEig
BClipped = VSort_B * DSort_B * inv(VSort_B);