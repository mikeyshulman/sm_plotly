function [scan,response] = sm_plotly_cleanup(scan,fname)
%function response = sm_plotly_cleanup(scan,fname)
% will grab data from figure(1000) and then export it.
% assumes already working plotly account....
% requires a plotldata struct, set up by the plotlygui
% plotlydata has fields:
%   export_aborted: should we export aborted scans (true/false)
%   auto_export: should you be prompted to export the scans (true/false)
%   dir_pattern: a pattern, passed to datestr to turn days into directory
%       names. blank will put everything into same directory
%   kwargs: additional fields to populate into kwargs, passed to ployly
%   plots: which plots (in smscan.disp) to export to plotly

global plotlydata;

[pdata,kwargs] = fig_to_plotly(1);
if isfield(plotlydata,'plots')
   ignore = setdiff((1:length(pdata)),plotlydata.plots); 
   pdata(ignore)=[];
   fn = fieldnames(kwargs);
   if any(ignore==1)
       kwargs.layout = rmfield(kwargs.layout,{'xaxis','yaxis'}); 
   end
   for j= 1:length(fn)
      if any(ignore == sscanf(fn{j},'xaxis%d')) || any(ignore == sscanf(fn{j},'yaxis%d'))
         kwargs.layout = rmfield(kwargs.layout,fn{j}); 
      end
   end
   
end

plot_dir = datestr(now,plotlydata.dir_pattern);
% the next line is sometimes buggy, conside replacing with
% kwargs.filename = [plot_dir,'/',fname]; 
kwargs.filename = fullfile(plot_dir,fname);
fn = fieldnames(plotlydata.kwargs);
for j = 1:length(fn)
   kwargs.(fn{j}) = plotlydata.kwargs.(fn{j}); 
end

if any(isnan(scan.data{1}(:))) && ~plotlydata.export_aborted
    response = [];
    return
end
if ~plotlydata.auto_export
   expt = strcmp(questdlg('Export to plot.ly?','Export?','yes','no','yes') ,'yes');
else
    expt = true;
end

if expt
    response = plotly(pdata,kwargs);
end
scan.data.plotly_response = response;

end