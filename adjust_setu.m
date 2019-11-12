function adjust_setu(IN_FNAME, OUT_FNAME)

% ADJUST_SETU conduct systematic variation in SETU estimation using
% mixed-effects linear model including CE effects.
%
% Example
% >> adjust_setu('input_data.csv', 'out.csv')

% Author: S. Angus (Monash), 2019

SIZE_BREAKS = [0 30 60 120 240 inf];
BAR_CLR_POS = [22 80 80]./256;
BAR_CLR_NEG = [204 57 57]./256;
BAR_ALPHA   = 0.7;
LOW_RESPONSE_N = 10;	% thresholds for low_reponse var
LOW_RESPONSE_R = 0.10;

% .. read table in
fprintf(' --> reading datafile ''%s'' ... ', IN_FNAME)
db = readtable(IN_FNAME, 'delimiter', '\t');
fprintf('done. (%.0f rows)\n', height(db))

% .. check we don't already have pscores calculated, if so strip
STRIP_VARS = {'pscore' 'pscore_monbs' 'pscore_similar' 'pscore_similar_low' 'pscore_similar_high' 'pscore_faculty' 'pscore_faculty_low' 'pscore_faculty_high' 'pscore_fb' 'pscore_fb_low' 'pscore_fb_high'};
if sum(ismember(STRIP_VARS,db.Properties.VariableNames)) > 0
	db = db(:,setdiff(db.Properties.VariableNames, STRIP_VARS));
end

% .. construct size category
[~,~,db.size_bin] = histcounts(db.enrolled, SIZE_BREAKS);

% .. 'Summer_YYYY/YYYY -> Summer'
db.sem_ord = db.sem;
db.sem_ord(contains(db.sem_ord,'Summer')) = {'Summer'};

% .. ordinals, nominals
% db.year_ord = ordinal(db.year);
db.year_lin = db.year - min(db.year);
db.sem_ord  = nominal(db.sem_ord);
db.survey_method = nominal(db.survey_method);

% .. code isclayton variable
db.isclayton = ismember(db.location, 'Clayton');

% .. construct post-grad code
db.ispostgrad = [db.level >= 4];

% .. construct << 10 response var
db.low_response = [db.responses < LOW_RESPONSE_N | db.responses./db.enrolled < LOW_RESPONSE_R];

% OLS
% .. estimate linear model under iteratively weighted (robust) least-squares
lm = fitlm(db, 'setu_overall ~ year_lin + sem_ord + isclayton + class_size_log10 + low_response + ispostgrad + survey_method', 'Robust', 'on');
disp(lm)

% Linear Mixed-Effects model
% .. allow for Random-effects on intercept, by CE
lme = fitlme(db, 'setu_overall ~ year_lin + sem_ord + isclayton + class_size_log10 + low_response + ispostgrad + survey_method + (1|ChiefExaminer)');
disp(lme)

% .. get size of FE effect (Fitted value - intercept)
% nb: fitted is only marginal effects -- i.e. arising from FE only (not FE + RE)
db.fe_effect = round(fitted(lme, 'Conditional', false) - lme.Coefficients.Estimate(1),2);

% .. get adjusted setu based on FE model
db.setu_overall_adj = round(db.setu_overall - db.fe_effect, 2);

% .. calc p-scores, based on comparison cohorts (then, for every MonBusSchool unit in that year)
P       = rowfun(@pscore, db, 'InputVariables', {'setu_overall_adj' 'unit_id'}, 'GroupingVariables', {'year' 'isclayton' 'size_bin'}, 'OutputVariableNames', {'pscore_similar' 'pscore_similar_low' 'pscore_similar_high' 'unit_id'});
P_monbs = rowfun(@pscore, db, 'InputVariables', {'setu_overall_adj' 'unit_id'}, 'GroupingVariables', {'year'}, 'OutputVariableNames', {'pscore_faculty' 'pscore_faculty_low' 'pscore_faculty_high'  'unit_id'});

% .. join back in
db = join(db, P, 'Keys', 'unit_id', 'RightVariables', {'pscore_similar' 'pscore_similar_low' 'pscore_similar_high'});
db = join(db, P_monbs, 'Keys', 'unit_id', 'RightVariables', {'pscore_faculty' 'pscore_faculty_low' 'pscore_faculty_high'});

% .. if we can, plot the coefficients
if feature('ShowFigureWindows')

	% .. obtain non-constant coefficient data, re-order
	betas      = lme.Coefficients.Estimate(2:end);
	a = lme.coefCI;						% .. deals with a bug in MATLAB indexing here
	betas_ci   = a(2:end,:);
	names      = lme.CoefficientNames(2:end);
	[~,ix] = sort(betas);
	betas = betas(ix);
	betas_ci = betas_ci(ix,:);
	names = names(ix);
	% .. and ols
	betas_ols  = lm.Coefficients.Estimate(2:end);
	betas_ols  = betas_ols(ix);

	% >> Fixed Effects
	figure(1),clf
	set(gcf,'Color','w')
		for i = 1:numel(betas)
			h = barh(i,betas(i)); hold on
			if betas(i) > 0
				set(h,'FaceColor',BAR_CLR_POS,'FaceAlpha', BAR_ALPHA);
			else
				set(h,'FaceColor',BAR_CLR_NEG,'FaceAlpha', BAR_ALPHA);
			end
		end
	    plot(betas_ci',[1 1]' * [1:numel(betas)],'k-')
	    set(gca,'YTick', 1:numel(betas), 'YTickLabel', names, 'TickLabelInterpreter', 'none')
	    set(gca,'FontSize',16), grid on
	    set(gca,'XLim', [-0.31 0.31])
	    xlabel(sprintf('Estimated Effect Size\n(in SETU overall score)'),'FontName','Raleway')
	    box off
	    % .. overlay equivalent FE from OLS model to observe diffs
	    scatter(betas_ols,[1:numel(betas)],'MarkerFaceColor','k','MarkerEdgeColor','k')
	    % .. add title
	    title(sprintf('Estimated Effect Sizes\n[bars: ML with CE effects; markers: OLS (no CE effects)]'),'FontName','Raleway')

end

% .. write out
fprintf(' --> writing output file ''%s'' to current directory (%.0f rows) ... ', OUT_FNAME, height(db))
writetable(db, OUT_FNAME, 'Delimiter', '\t');
fprintf('done.\n')


%%%%%%%%%%%%%%%%%%%%%%
function [p,pL,pH, unit_id] = pscore(x, unit_id)

NOISE = 0.1;

p  = round(100*normcdf(x, mean(x,'omitnan'), std(x,'omitnan')));
pL = round(100*normcdf(x-NOISE, mean(x,'omitnan'), std(x,'omitnan')));
pH = round(100*normcdf(x+NOISE, mean(x,'omitnan'), std(x,'omitnan')));


