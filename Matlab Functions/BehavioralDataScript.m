% Function loops through Date file and returns cell array of data points
function a = BehavioralDataScript(file)
% create empty cell array, import file, and create variables for inside for
% loop
T = {};
Date1020 = file;

% looping through every row of the imported data 
for row = 1:(size(Date1020)-1)

    % if the value in the first column is equal to the string, take the
    % value at the same row but second column and append to T
    if num2str(Date1020{row,1}) == "Start Date"
       Date= datetime(Date1020{row,2});
    end

    if num2str(Date1020{row,1}) == "Subject"
       Subject= categorical(Date1020(row,2));
    end
    
   % split data points in C array and add to corresponding file
   if num2str(Date1020{row,1}) == "A" 
       Q = strsplit(num2str(Date1020{row+3,2}));
       Weight = str2num(Q{6}); % Animal Weight       
   end 

    % split data points in C array and add to corresponding file
   if num2str(Date1020{row,1}) == "C" 
       C = strsplit(num2str(Date1020{row+1,2}));
       D = strsplit(num2str(Date1020{row+2,2}));
       E = strsplit(num2str(Date1020{row+3,2}));

       Infusions = str2num(C{2})-str2num(E{4}); % Remove automatic infusions       
       HeadEntries = str2num(C{6});
       Latency = str2num(D{6});
       ActiveLever = str2num(E{2});
       InactiveLever = str2num(E{3});
   end 
    
end
a = table(Subject,Date,Infusions,HeadEntries,Latency,ActiveLever,InactiveLever,Weight);
end


   
