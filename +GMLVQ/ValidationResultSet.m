classdef ValidationResultSet < GMLVQ.ResultSet    
    % Class that extends the default resultset with custom plotting behaviour
    methods
        function plot(this)
            close all;
            
            % Assign all variables
            mcftra = [this.averageRun.trainingPerf.costFunction];
            scftra = [this.averageRun.trainingPerfStd.costFunction];
            mcfval = [this.averageRun.validationPerf.costFunction];
            scfval = [this.averageRun.validationPerfStd.costFunction];
            
            mtetra = [this.averageRun.trainingPerf.totalError];
            stetra = [this.averageRun.trainingPerfStd.totalError];
            mteval = [this.averageRun.validationPerf.totalError];
            steval = [this.averageRun.validationPerfStd.totalError];
            
            mauctra = [this.averageRun.trainingPerf.auroc];
            sauctra = [this.averageRun.trainingPerfStd.auroc];
            maucval = [this.averageRun.validationPerf.auroc];
            saucval = [this.averageRun.validationPerfStd.auroc];
            
            mcwtra = [this.averageRun.trainingPerf.classWise]';
            scwtra = [this.averageRun.trainingPerfStd.classWise]';
            mcwval = [this.averageRun.validationPerf.classWise]';
            scwval = [this.averageRun.validationPerfStd.classWise]';
            
            totalsteps = this.averageRun.nSteps + 1;
            onlyat = floor(linspace(1, totalsteps, 10));
            onlyatval = onlyat(1:end-1)+1;
            
            rocClass = num2str(this.averageRun.gmlvq.params.rocClass);
            
            figure(1);
            msize = 15; % Size of symbols
            if totalsteps < 50; msize = 20; end
            
            subplot(3,2,1);                 % total training and validation errors
            % axis([0 totalsteps 0 1.2*max(mteval)]); 
            plot(1:totalsteps,mtetra,':.',1:totalsteps,mteval,':.',...
                                                      'MarkerSize',msize); 
            axis tight; axis 'auto y'; 
            hold on; box on;
            title('total error rates',...
               'FontName','LucidaSans', 'FontWeight','bold'); 
            legend('training','test','Location','Best'); 
            xlabel('gradient steps');
            errorbar(onlyat,mtetra(onlyat),stetra(onlyat)/sqrt(this.nRuns),...
                   'co','MarkerSize',1); 
            errorbar(onlyatval,mteval(onlyatval),steval(onlyatval)/sqrt(this.nRuns),...
                   'go','MarkerSize',1);  
            hold off;


            subplot(3,2,2);                 % AUC(ROC) for training and validation 
            plot(1:totalsteps,mauctra,':.',1:totalsteps,maucval,':.',...
                                                         'MarkerSize',msize); 
            axis([1 totalsteps min(0.7,min(maucval)) 1.05]); % axis 'auto y';
            hold on; box on;
            % plot(1:totalsteps,maucval,'g.'); 
            legend('training','test','Location','Best'); 
            title(['AUC(ROC) w.r.t. to class',rocClass,'vs. all others'],...
                 'FontName','LucidaSans', 'FontWeight','bold'); 
            errorbar(onlyat,mauctra(onlyat),sauctra(onlyat)/sqrt(this.nRuns),'b.'); 
            errorbar(onlyatval,maucval(onlyatval),saucval(onlyatval)/sqrt(this.nRuns),'g.'); 
            hold off;

            subplot(3,2,3);                % class-wise training errors 
            plot(1:totalsteps,mcwtra,':.','MarkerSize',msize); 
            title('class-wise training errors',...
            'FontName','LucidaSans', 'FontWeight','bold');
            xlabel('gradient steps');
            legend(num2str([1:this.averageRun.nClasses]'),'Location','Best');
            axis tight; axis 'auto y'; 
            hold on; box on;
            hold off;

            subplot(3,2,4);                % class-wise test errors 
            plot(1:totalsteps,mcwval,':.','MarkerSize',msize); 
            title('class-wise test errors',...
               'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps')
            legend(num2str([1:this.averageRun.nClasses]'),'Location','Best');
            axis tight; axis 'auto y'; 
            hold on; box on;
            % plot(1:totalsteps,mcwval,'.'); 
            hold off;

            subplot(3,2,5);                % cost-function (training set)
            plot(1:totalsteps,mcftra,':.','MarkerSize',msize); 
            title('cost fct. per example w/o penalty',...
               'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps')
            axis tight; axis 'auto y'; 
            hold on; box on;
            % plot(1:totalsteps,mcftra,'.'); 
            hold off;

            subplot(3,2,6);                % cost-function (test)
            plot(1:totalsteps,mcfval,':.','MarkerSize',msize); 
            title('analagous for validation set',...
               'FontName','LucidaSans', 'FontWeight','bold'); 
            xlabel('gradient steps') 
            axis tight; axis 'auto y'; 
            hold on; box on;
            % plot(1:totalsteps,mcfval,'.'); 
            hold off;


            %  threshold-averaged validation roc of final gmlvq systems after 
            %  totalsteps gradient steps
            figure(2); 
            plot(this.averageRun.validationPerf(end).fpr',this.averageRun.validationPerf(end).tpr','b-','LineWidth',2);
            hold on;
            plot(mean(this.finalFprs(:,this.finalThresholds(end,:)==0.5)),...
                mean(this.finalTprs(:,this.finalThresholds(end,:)==0.5)),'ko',... % TODO why only the last one?
                'MarkerSize',10,'MarkerFaceColor','g');
            legend(['AUC= ',num2str(-trapz(this.averageRun.validationPerf(end).fpr,this.averageRun.validationPerf(end).tpr))],...
                   'NPC performance','Location','SouthEast');
            plot([0 1],[0 1],'k:'); 
            xlabel('false positive rate');
            ylabel('true positive rate'); 
            axis square; 
            title(['threshold-avg. test set ROC (class ',rocClass,' vs. all others)'],...
                 'FontName','LucidaSans', 'FontWeight','bold'); 
            hold off;
            
            figure(3);
            this.averageRun.plot();
        end
    end
end

