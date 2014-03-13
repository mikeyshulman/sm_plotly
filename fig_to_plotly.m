function [data, kwargs] = fig_to_plotly(fignum)
%function [data, kwargs] = fig_to_plotly(fignum)
%   grab data from a figure and populate structs data and kwargs to export
%   to plotly. this currently does not support the full functionality of
%   matlab figure. currently supports 1-D and 2-D data
%   this will force all subplots to be in one row, even if they aren't
%   works on single figures only (can havbe subplots);
%   will delete legends
if isempty(fignum)
    fignum = gcf;
end
if length(fignum)>1
    error('only works on single figures')
end
h = figure(fignum);
axesObjs = get(h, 'Children');
dataObjs = get(axesObjs, 'Children');

out = {}; layout = struct();
lab_data = struct();
%first loop through and remove colorbar
cbars = [];
for j = 1:length(dataObjs)
    if length(dataObjs{j})>1 %its a legend!
        cbars = [cbars,j];
        continue
    end
    tmp = get(dataObjs{j});
    if length(tmp.XData)==2 && length(tmp.YData)==2 &&...
            (isfield(tmp,'CData') && length(tmp.CData)>2)
        cbars = [cbars,j]; %#ok<AGROW>
    end
end
dataObjs(cbars) = [];
axesObjs(cbars) = [];
dataObjs = dataObjs(end:-1:1); %things come out backwards in matlab
axesObjs = axesObjs(end:-1:1);%things come out backwards in matlab

title_strings = {};
for j = 1:length(dataObjs)
    clear data1;
    tmp = get(dataObjs{j});
    data1.x = tmp.XData;
    data1.y = tmp.YData;
    if isfield(tmp,'CData') && ~isempty(tmp.CData)
       %this indicates 2-D plot
       data1.z = tmp.CData;
       data1.type = 'heatmap';
    end
    if j>1
       data1.xaxis = ['x',num2str(j)]; 
       data1.yaxis = ['y',num2str(j)]; 
    end
    out = [out,data1];%#ok<AGROW>
    lab_data(j).xlabel = get(get(axesObjs(j),'XLabel'),'string');
    lab_data(j).ylabel = get(get(axesObjs(j),'YLabel'),'string');
    lab_data(j).title = get(get(axesObjs(j),'title'),'string');
    title_tmp = get(get(axesObjs(2),'Title'),'String');
    if ~isempty(title_tmp)
        title_strings = [title_strings, title_tmp];%#ok<AGROW>
    end
end
spacer =.1; %how much buffer (in %) between plots
ival = 1/length(out)-spacer; %plot interval

% populate the layout struct
for j= 1:length(out)   
    domain = (j-1)/length(out) + (j>1)*j*spacer/length(out)+[0 ival];
    if j ==1
       layout.xaxis = struct('domain',domain,'title',lab_data(j).xlabel);
       layout.yaxis = struct('anchor','x','title',lab_data(j).ylabel);
       
    else
        layout.(['xaxis',num2str(j)]) = struct('domain',domain,'title',lab_data(j).xlabel);
        layout.(['yaxis',num2str(j)]) = struct('anchor',['x',num2str(j)],'title',lab_data(j).ylabel);
    end
end
layout.showlegend = false;
layout.title = title_strings{1};
data = out; %they come out backwards
kwargs.layout=layout;

end