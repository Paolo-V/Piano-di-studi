% Choose CdL
include "CdL1.dzn";
%include "CdL2.dzn";

% Check that the values in the data ﬁle are reasonable
constraint assert(c_min > 0,"Invalid datafile: " ++ "Amount of credits for core learning activities must be positive");
constraint assert(c_max > 0,"Invalid datafile: " ++ "Amount of credits for core learning activities must be positive");
constraint assert(a_min > 0,"Invalid datafile: " ++ "Amount of credits for supplementary learning activities must be positive");
constraint assert(a_max > 0,"Invalid datafile: " ++ "Amount of credits for supplementary learning activities must be positive");
constraint assert(t > 0,"Invalid datafile: " ++ "Amount of credits for final examination must be positive");
constraint assert(nc > 0,"Invalid datafile: " ++ "Amount of core learning activities must be positive");
constraint assert(na > 0,"Invalid datafile: " ++ "Amount of supplementary learning activities must be positive");

array[1..nc] of var bool: c;       % core activities selected
array[1..ncSSDs] of string: cSSDs; % distinct SSDs for core activities
array[1..nc] of string: cname;     % core activities name
array[1..nc] of int: cSSD;         % SSD corresponding to core activities
array[1..nc] of int: ccfu;         % core activities cfu
array[1..nc] of int: cy;           % core activities year
array[1..nc] of int: ct;           % core activities term
array[1..na] of var bool: a;       % supplementary activities selected
array[1..naSSDs] of string: aSSDs; % distinct SSDs for supplementary activities
array[1..na] of string: aname;     % supplementary activities name
array[1..na] of int: aSSD;         % SSD corresponding to supplementary activities
array[1..na] of int: acfu;         % supplementary activities cfu
array[1..na] of int: ay;           % supplementary activities year
array[1..na] of int: at;           % supplementary activities term

constraint c_min <= sum(i in 1..nc) (ccfu[i]*c[i]) /\ c_max >= sum(i in 1..nc) (ccfu[i]*c[i]);

constraint a_min <= sum(i in 1..na) (acfu[i]*a[i]) /\ a_max >= sum(i in 1..na) (acfu[i]*a[i]);
 
% original version constraints:
constraint 180 - t = sum(i in 1..nc) (ccfu[i]*c[i]) + sum(j in 1..na) (acfu[j]*a[j]);

constraint forall(k in 1..2)(60 = sum(i in 1..nc) (bool2int(cy[i] == k)*ccfu[i]*c[i]) + sum(j in 1..na) (bool2int(ay[j] == k)*acfu[j]*a[j]));

constraint forall(k in 1..3)(forall(l in 1..2)(30 >= sum(i in 1..nc) (bool2int(cy[i] == k /\ ct[i] == l)*ccfu[i]*c[i]) + sum(j in 1..na) (bool2int(ay[j] == k /\ at[j] == l)*acfu[j]*a[j])));

% alternative constraints:
%constraint forall(k in 1..2)(forall(l in 1..2)(30 = sum(i in 1..nc) (bool2int(cy[i] == k /\ ct[i] == l)*ccfu[i]*c[i]) + sum(j in 1..na) (bool2int(ay[j] == k /\ at[j] == l)*acfu[j]*a[j])));

%constraint 60 - t = sum(k in 1..2)((sum(i in 1..nc) (bool2int(cy[i] == 3 /\ ct[i] == k)*ccfu[i]*c[i]) + sum(j in 1..na) (bool2int(ay[j] == 3 /\ at[j] == k)*acfu[j]*a[j])));

%constraint forall(l in 1..2)(30 >= sum(i in 1..nc) (bool2int(cy[i] == 3 /\ ct[i] == l)*ccfu[i]*c[i]) + sum(j in 1..na) (bool2int(ay[j] == 3 /\ at[j] == l)*acfu[j]*a[j]));

solve satisfy;
output ["Materie caratterizzanti \n"];
output ["anno " ++ "semestre  " ++ "SSD      " ++ "insegnamento                                   " ++ "cfu" ++ "\n"];
output [show_int(4, cy[i]) ++ " " ++ show_int(8, ct[i]) ++ " " ++ show(cSSDs[cSSD[i]]) ++ " " ++ show(cname[i]) ++ "  " ++ show_int(2, ccfu[i]) ++ " " ++ "\n" | i in 1..nc where fix(c[i] == true)];
output ["Materie affini \n"];
output ["anno " ++ "semestre  " ++ "SSD      " ++ "insegnamento                                   " ++ "cfu" ++ "\n"];
output [show_int(4, ay[i]) ++ " " ++ show_int(8, at[i]) ++ " " ++ show(aSSDs[aSSD[i]]) ++ " " ++ show(aname[i]) ++ "  " ++ show_int(2, acfu[i]) ++ " " ++ "\n" | i in 1..na where fix(a[i] == true)];
