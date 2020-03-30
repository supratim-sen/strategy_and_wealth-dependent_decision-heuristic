% Gini Coefficient Calculation
function y = Gini_cal(W)
l = length(W);
Diff = 0;
    for i = 1:l
        Diff = Diff + sum(abs(W(i) - W));
    end
y = Diff/(2*l*l*mean(W));
end
