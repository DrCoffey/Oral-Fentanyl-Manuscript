function [p t stats terms anovaY anovaX] = anovanTable(T, varargin)
% [p t stats terms] = anovanTable(T, varargin)
% this is the same as ANOVAN(Y,X,varargin), and performs an N-way ANOVA.
% where there is one observation per condition, simply pass the array of
% data, with one dimension per factor.
% 
% The input 'T' is an N-dimensional array, where each
% dimension is a factor in the ANOVA. Dimension 1 becomes factor 1,
% dimension 2 becomes factor 2 and so on...
% Elements with 'nan' are ignored, so you can compare groups of different 
% sizes by padding smaller group's data with nans.
% 
% If there are serveral observations per condition, use an extra array
% dimension to store repeated measures, and specify to collapse across this
% dimension with the parameter 
%   'collapse', DIM
% where DIM is a list of dimensions that are collapsed across.
%
% all ANOVAN named-parameters are passed on, e.g. 'varnames', 'random',
% 'nested', 'model' etc.  But of course, 'continuous' predictors will only 
% work as linearly spaced values, as the levels are specified as 1,2,3...
% etc.
% 
% the first 4 return values are the same as anovan.
% the anovaY and anovaX results are the actual values passed to anovan,
% i.e. the vector-flattened data and the corresponding regressor set


% check for collapse parameter
remove=[];
for(i=1:length(varargin))
  if(strcmpi(varargin{i}, 'collapse'))
    collapse = varargin{i+1};
    remove=[i i+1];
  end
end
varargin(remove)=[];
if(~exist('collapse','var')) collapse=0;end

s=size(T);
N=length(s);
% collapse across dimesions => there are fewer anova factors
if(collapse) N=N-length(collapse); end; 
anovaY=[]; anovaX=[];
for(i=1:prod(size((T)))) % for every datapoint
  if isnan(T(i)), continue; end;
  anovaY=[anovaY; T(i)]; % create Y data
  % get a level for each factor
  [j(1) j(2) j(3) j(4) j(5) j(6) j(7)]=ind2sub(s, i); 
  % remove factors that are collapsed
  if(collapse) j(collapse)=[]; end
  anovaX=[anovaX; j(1:N)]; % create X data
end
% do the anova
[p t stats terms]=anovan(anovaY, anovaX, varargin{:});

