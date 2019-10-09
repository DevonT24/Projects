function [Jforce,Mforce,Jdispl,Mdispl] = ...
          truss3(n,m,joint,assembly,forceJ,stretch,index)
%   
%   THIS COMES FROM THE SILVERBERG MATLAB TOOLBOX, I DID NOT WRITE IT
%   It is included to be used with my simulated bridge file
%
%   truss3 solves space truss problems. 
%   truss3 calculates:
%
%       joint forces            member forces
%       joint displacements     member dispalcements
%
%   truss3 also displays a drawing of the space truss.  
%
%[Jforce,Mforce,Jdispl,Mdispl] =
% truss3(n,m,joint,assembly,forceJ,stretch,index)
%
% INPUTS
%           n           = number of joints
%
%           m           = number of members
%
%           joint       = n x 3 matrix of joint coordinates
%
%           assembly    = m x 2 matrix of A-joints and B-joints. The 1st 
%                       and 2nd columns of the j-th row are the A- and 
%                       B-joints of the j-th member.
%
%           forceJ      = n x 4 matrix of joint loads at internal joints 
%                       and reactions at external joints. The i-th row
%                       corresponds to the i-th joint. The 1st column of 
%                       the ith row indicates joint type.
%                       1) Let forceJ(i,1) = -1 when joint is internal. 
%                          Then let forceJ(i,2) = FX, forceJ(i,3) = FY, and
%                          forceJ(i,4) = FZ, where FX, FY, and FZ are 
%                          force loads in X, Y, and Z directions.
%                       2) Let forceJ(i,1) = 0 when joint is external with 
%                          0 reactions. Then let forceJ(i,2) = forceJ(i,3) 
%                          = forceJ(i,4) = 0.
%                       3) Let forceJ(i,1) = 1 when joint is external with 
%                          1 reaction. Then let forceJ(i,2) = NX, 
%                          forceJ(i,3) = NY, and forceJ(i,4) = NZ, where 
%                          NX, NY, and NZ are the X, Y, and Z components of
%                          the unit vector in the direction of the 
%                          reaction.
%                       4) Let forceJ(i,1) = 2 when joint is external with 
%                          2 reactions. Then let forceJ(i,2) = NX,
%                          forceJ(i,3) = NY, and forceJ(i,4) = NZ, where
%                          NX, NY, and NZ are the X, Y, and Z components of
%                          the unit vector in the direction PERPENDICULAR
%                          to the reaction. NX, NY, and NZ are in the 
%                          directions in which the displacements are free.
%                       5) Let forceJ(i,1) = 3 when joint is external with 
%                          3 reactions. Then let forceJ(i,2) = forceJ(i,3) 
%                          = forceJ(i,4) = 1.
%
%           stretch     = 1 x m vector of stretching moduli. Set to zero
%                       when index = 0.
%
%           index       = 1 x 1. index = 0, 1, or 2.
%                       1) When index = 0 the truss is drawn. The truss is
%                          displayed with displacements that are scaled for
%                          easy visualization. The values of stretch that
%                          are supplied do not effect the drawing. 
%                       2) When index = 1 the truss is drawn. You must 
%                          supply non-zero values of stretch.
%                       3) When index = 2 the truss is not drawn. You must 
%                          supply non-zero values of stretch.
% OUTPUTS
%           Jforce      = n x 4 matrix of joint forces. The ith row 
%                       corresponds to ith joint. The 1st column of ith row
%                       is i. The 2nd, 3rd, and 4th columns are for X, Y, 
%                       and Z force components.  
%
%           Mforce      = m x 1 vector of member forces.  
%                                                                     
%           Jdispl      = n x 4 matrix of joint displacements. The ith row
%                       corresponds to ith joint. The 1st column of ith row
%                       is i. The 2nd, 3rd, and 4th columns are for X, Y,
%                       and Z displacement components.  
%
%           Mdispl      = m x 1 vector of member stretches.   
%
%   EDUCATIONAL FREEWARE FOR ENGINEERING STATICS & DYNAMICS, L. SILVERBERG
%   rev 10-23-06

% Error Messages
[nn,mm] = size(joint);
if (nn ~= n)||(mm ~=3)
    error('Size of joint is wrong.')
end
[nn,mm] = size(assembly);
if (nn ~= m)||(mm ~=2)
    error('Size of assembly is wrong.')
end
[nn,mm] = size(forceJ);
if (nn ~= n)||(mm ~=4)
    error('Size of forceJ is wrong.');
end
if (index ~= 2)&&(index ~= 1)&&(index~=0)
    error('The value of index is not 0,1, or 2.')
end
if index == 2 || index == 1
    jstretch = 0;
    for j = 1:m
        if stretch(j) == 0
            jstretch = 1;
        end
    end
    if jstretch == 1
       error('At least one element of stretch is 0 while index is 1 or 2.')
    end
end
% Initialize quantities to zero.
p0 = 0;
for i = 1:n
    if forceJ(i,1) > 0 
    p0 = p0 + forceJ(i,1);
    end
end
N1 = 3*n; M1 = m+p0; N2 = p0+2*m; M2 = m+3*n;
b = zeros(1,N1); a = zeros(N1,M1); 
d = zeros(N2,M2); e = zeros(N2,M1);
zero1 = zeros(N1,M2); zero2 = zeros(1,N2);
% Graph the undisplaced structure.
if (index == 1)||(index == 0)
figure
grid on
hold
set(gca,'FontSize',13)
view(135,20)
    for j = 1:m
        jA = assembly(j,1); jB = assembly(j,2);
        A(1) = joint(jA,1); A(2) = joint(jA,2); A(3) = joint(jA,3);
        B(1) = joint(jB,1); B(2) = joint(jB,2); B(3) = joint(jB,3);
        x(1) = A(1); y(1) = A(2); z(1) = A(3);
        x(2) = B(1); y(2) = B(2); z(2) = B(3);
        plot3(x,y,z,'--','Linewidth',1)
    end
end
% Calculate the member unit vectors.
for j = 1:m
    jA = assembly(j,1); jB = assembly(j,2);
    L(j) = 0;
    for k = 1:3
    L(j) = L(j) + (joint(jB,k)-joint(jA,k))^2;
    end
    L(j) = sqrt(L(j));
        if L(j) == 0
        error ('The length of a member is 0.')
        end
    for k = 1:3
        u(j,k) = (joint(jB,k)-joint(jA,k))/L(j);
    end
end
% Calculate stretch stiffnesses (for index = 0 only).
if index == 0
    for j = 1:m
        stretch(j) = 1000;
    end
end
% Calculate the m member displacement equations in [d]{u}+[e]{f}={0}.
for i = 1:m
    d(i,i) = 1; e(i,i) = -L(i)/stretch(i);
end
% Calculate the 3n force equations in [a]{f}={b} and
% calculate the p joint displacement equations
% in [d]{u} + [e]{f} = {0}.  
for i = 1:n
    for j = 1:m
        i1 = 3*(i-1);
        for k = 1:2
            if assembly(j,k) == i
                for k1 = 1:3
                    a(i1+k1,j) = u(j,k1)*(3-2*k);
                end
            end
        end
    end
end
p = 0;
for i = 1:n
    i1 = 3*(i-1); j1 = m; i2 = m; j2 = m+3*(i-1);
    n1 = [forceJ(i,2),forceJ(i,3),forceJ(i,4)];
    if forceJ(i,1) == 1
        p = p + 1;
        for k1 = 1:3
            a(i1+k1,j1+p) = n1(k1); d(i2+p,j2+k1) = n1(k1);
        end
    end
    if forceJ(i,1) == 2
        [n2,n3] = units(n1); p = p + 1;
        for k1 = 1:3
            a(i1+k1,j1+p) = n2(k1); d(i2+p,j2+k1) = n2(k1);
        end
        p = p + 1;
        for k1 = 1:3
            a(i1+k1,j1+p) = n3(k1); d(i2+p,j2+k1) = n3(k1);
        end
    end
    if forceJ(i,1) == 3
        p = p + 1;
        a(i1+1,j1+p) = 1; d(i2+p,j2+1) = 1; p = p + 1;
        a(i1+2,j1+p) = 1; d(i2+p,j2+2) = 1; p = p + 1;
        a(i1+3,j1+p) = 1; d(i2+p,j2+3) = 1;
    end
    if forceJ(i,1) == -1
        for k1 = 1:3
            b(i1+k1) = -1*forceJ(i,k1+1);
        end
    end
end
% Calculate the m member-joint displacement equations 
% in [d]{u} + [e]{f} = {0}.
for j = 1:m
    iA = assembly(j,1); iB = assembly(j,2); i2 = m+p+j;
    j2A = m+3*(iA-1); j2B = m+3*(iB-1);
    d(i2,j) = 1;
    for k1 = 1:3
        d(i2,j2A+k1) = u(j,k1); d(i2,j2B+k1) = -u(j,k1);
    end
end
% Solve the force-displacement equations.
AA = [a,zero1;e,d]; BB = [b,zero2]'; detAA = det(AA);
if abs(detAA) < 1e-16
    warning('System may be partially constrained.')
end
AAinv = inv(AA); sol = AAinv*BB;
% Prepare the output quantities.
pp = 0;
for i = 1:n
    Jforce(i,1) = i; Jdispl(i,1) = i;
    isol = 2*m+p+3*(i-1); 
    Jdispl(i,2) = sol(isol+1); Jdispl(i,3) = sol(isol+2); 
    Jdispl(i,4) = sol(isol+3);
end
for i = 1:n
    if forceJ(i,1) == 0
        Jforce(i,2) = 0; Jforce(i,3) = 0; Jforce(i,4) = 0;
    end
    if forceJ(i,1) == 1
        pp = pp + 1;
        Jforce(i,2) = sol(m+pp)*forceJ(i,2);
        Jforce(i,3) = sol(m+pp)*forceJ(i,3);
        Jforce(i,4) = sol(m+pp)*forceJ(i,4);
    end
    if forceJ(i,1) == 2
        n1 = [forceJ(i,2),forceJ(i,3),forceJ(i,4)];
        [n2,n3] = units(n1);
        pp = pp + 1;
        Jforce(i,2) = sol(m+pp)*n2(1)+sol(m+pp+1)*n3(1);
        Jforce(i,3) = sol(m+pp)*n2(2)+sol(m+pp+1)*n3(2);
        Jforce(i,4) = sol(m+pp)*n2(3)+sol(m+pp+1)*n3(3);
        pp = pp + 1;
    end
    if forceJ(i,1) == 3
        pp = pp + 1;
        Jforce(i,2) = sol(m+pp); pp = pp + 1;
        Jforce(i,3) = sol(m+pp); pp = pp + 1;
        Jforce(i,4) = sol(m+pp);
    end
    if forceJ(i,1) == -1
        Jforce(i,2) = forceJ(i,2); Jforce(i,3) = forceJ(i,3); 
        Jforce(i,4) = forceJ(i,4);
    end
end
for j = 1:m
    Mforce(j) = sol(j); Mdispl(j) = sol(m+p+j);
end
if index == 0
    Jforce = 0; Jdispl = 0; Mforce = 0; Mdispl = 0;
end
if index == 0
    umax = 0;
    for j = 1:m 
        if abs(sol(m+p+j)/L(j)) > umax
            umax = abs(sol(m+p+j)/L(j));
        end
    end
    if umax == 0
        error('System is not acted on by a load.')
    end
    for i = 1:3*n
        isol = 2*m+p; sol(isol+i) = sol(isol+i)*0.1/umax;
    end
end
% Graph the displaced structure.
if (index == 1)|(index == 0)
for j = 1:m
    iA = assembly(j,1); iB = assembly(j,2);
    iiA = m+p+m+3*(iA-1); iiB = m+p+m+3*(iB-1);
    A(1) = joint(iA,1)+sol(iiA+1); A(2) = joint(iA,2)+sol(iiA+2);
    A(3) = joint(iA,3)+sol(iiA+3);
    B(1) = joint(iB,1)+sol(iiB+1); B(2) = joint(iB,2)+sol(iiB+2);
    B(3) = joint(iB,3)+sol(iiB+3);
    x(1) = A(1); y(1) = A(2); z(1) = A(3);
    x(2) = B(1); y(2) = B(2); z(2) = B(3);
    plot3(x,y,z,'black','Linewidth',1.5)
end
axis equal
end
