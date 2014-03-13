%% setup the plotlydata struct that deals with all things plotly+sm
global plotlydata;

plotlydata.export_aborted = true; % true = plot aborted scans;
plotlydata.dir_pattern = 'yyyy_mm_dd'; % leave empty to not separate into directories
plotlydata.auto_export = true; % if false, will prompt user whether to export