classdef Result
    % Class that represents the result of a single algorithm run
    properties
        run GMLVQ.Run
        stepsizeMatrix (:,1) { mustBeNumeric }
        stepsizePrototypes (:,1) { mustBeNumeric }
    end
    
    methods
        % Plot implementation
        function plot(this, performances)
            if nargin < 2 % We have not specified a data set properly, plot the training data
                this.plot(this.run.trainingPerf);
                return;
            end
            
            close all;
            
            finalPerformance = performances(end);
            rocClass = num2str(this.run.gmlvq.params.rocClass);
            
            scrsz = get(0,'ScreenSize');
            figure('Position',[1 scrsz(4)*8/10 scrsz(3)*4/10 scrsz(4)*8/10])   
    
            % figure(1);                                       % learning curves 
            msize=15;   % size of symbols
            totl=this.run.nSteps+1;
            subplot(3,2,1);  % plot glvq cost fucntion vs. steps
            plot([1:totl],[performances.costFunction],'b.','MarkerSize',msize); hold on;
    
            title('glvq costs per example w/o penalty term ', 'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps');
            axis([0 totl -1 1]); axis 'auto y';
 
            subplot(3,2,2);  % plot total training error vs. steps
            plot(1:totl, [performances.totalError], 'r.', 'Markersize', msize); hold on;
   
            title('total training error', 'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps'); 
            axis([0 totl 0 1]); axis 'auto y';
   
            subplot(3,2,3); % plot the class-wise errors vs. steps
            plot(1,performances(1).classWise,'.','MarkerSize',msize+10); hold on;
            plot(1,performances(1).classWise,'w.','MarkerSize',msize+10);
            plot(1:totl,[performances.classWise],'.','MarkerSize',msize);
            legend(num2str([1:this.run.nClasses]'),'Location','NorthEast');
  
            title('class-wise training errors', 'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps'); 
            axis([0 totl 0 1]);  axis 'auto y';
   
            subplot(3,2,4);   % plot AUC (ROC) vs. steps
            plot(1:totl, [performances.auroc], 'k.','MarkerSize',msize); 
            axis([ 0 totl min(0.9, min([performances.auroc])) 1.05 ]); 
            title(['AUC(ROC), class ',rocClass,' vs. all others'], 'FontName','LucidaSans', 'FontWeight','bold');
 
   
            subplot(3,2,5);  % plot glvq cost fucntion vs. steps
            plot([1:totl], this.stepsizePrototypes, 'b.','MarkerSize',msize); hold on;
            plot([1:totl], this.stepsizeMatrix, 'r.','Markersize',msize);
            title('stepsizes', 'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps');
            legend('prototype','relevances','Location','NorthEast');
            axis([0 totl -1 1]); axis 'auto y';
   
   
            figure(2);             % display the ROC curve of the final classifier 
            fprnpc = finalPerformance.fpr(finalPerformance.thresholds==0.5); % false positive of NPC
            tprnpc = finalPerformance.tpr(finalPerformance.thresholds==0.5); % true  positive of NPC
   
            plot(finalPerformance.fpr,finalPerformance.tpr,'-'); hold on;
            plot(fprnpc,tprnpc,'ko','MarkerSize',10,'MarkerFaceColor','b');
            axis square;
            xlabel('false positive rate');
            ylabel('true positive rate');
            title(['Training ROC, class ',rocClass,' (neg.) vs. all others (pos.)'], 'FontName','LucidaSans', 'FontWeight','bold'); 
            legend(['AUC = ',num2str(finalPerformance.auroc)],'NPC', 'Location','SouthEast');
            plot([0 1],[0 1],'k:'); 
            hold off;
 

            figure(3);                   % visualize prototyeps and lambda matrix 
            this.run.plot();
  
            figure(4);         % visualize data set in terms of projections on the
                               % leading eigenvectors of Lambda
            this.run.visu_2d();
            title('2d-visualization of the data set', 'FontName','LucidaSans', 'FontWeight','bold');
        end
        
    end
end

