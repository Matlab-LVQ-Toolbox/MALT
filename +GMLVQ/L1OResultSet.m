classdef L1OResultSet < GMLVQ.ResultSet
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
            
            rocClass = num2str(this.averageRun.gmlvq.params.rocClass);
            
            figure(1);
            msize = 15; % Size of symbols
            if totalsteps < 50; msize = 20; end
            
            subplot(2,2,1);   % total training error rate 
            % axis([0 totalsteps 0 1.2*max(mteval)]); 
            plot(1:totalsteps,mtetra,':.','MarkerSize',msize); 
            axis tight; axis 'auto y'; 
            hold on; box on;
            title('total training error rate',...
                'FontName','LucidaSans', 'FontWeight','bold'); 
            legend('training','Location','Best'); 
            xlabel('gradient steps');
            errorbar(onlyat,mtetra(onlyat),stetra(onlyat)/sqrt(this.nRuns),...
                'co','MarkerSize',1); 
            hold off;

            subplot(2,2,2);  % total training AUC(ROC)
            plot(1:totalsteps,mauctra,':.','MarkerSize',msize); 
            axis([1 totalsteps 0.8 1.05]); % axis 'auto y';
            hold on; box on;
            % plot(1:totalsteps,maucval,'g.'); 
            legend('training','Location','Best'); 
            title(['AUC(ROC) w.r.t. to class ',rocClass,' vs. all others'],...
                'FontName','LucidaSans', 'FontWeight','bold'); 
            errorbar(onlyat,mauctra(onlyat),sauctra(onlyat)/sqrt(this.nRuns),'b.'); 
            hold off;

            subplot(2,2,3);   % class-wise training errors
            plot(1:totalsteps,mcwtra,':.','MarkerSize',msize); 
            title('class-wise training errors',...
                'FontName','LucidaSans', 'FontWeight','bold');
            xlabel('gradient steps');
            legend(num2str([1:this.averageRun.nClasses]'),'Location','Best');
            axis tight; axis 'auto y'; 
            hold on; box on;
            hold off;

            subplot(2,2,4);   % cost function (training)
            plot(1:totalsteps,mcftra,':.','MarkerSize',msize); 
            title('cost fct. w/o penalty term (training)',...
                'FontName','LucidaSans', 'FontWeight','bold');
            xlabel('gradient steps');
            axis tight; axis 'auto y'; 
            hold on; box on;
            hold off;

            %  single l1O roc of final gmlvq systems after 
            %  totalsteps gradient steps

            figure(2); 
            fprs = this.averageRun.validationPerf(end).fpr;
            tprs = this.averageRun.validationPerf(end).tpr;
            thresh = this.averageRun.validationPerf(end).thresholds;
            plot(fprs,tprs,'b-','LineWidth',2);
            hold on;
            plot((fprs(thresh==0.5)),...
                (tprs(thresh==0.5)),'ko',...
            'MarkerSize',10,'MarkerFaceColor','g');
            legend(['AUC= ',num2str(-trapz((fprs),(tprs)))],...
                'NPC performance','Location','SouthEast');
            plot([0 1],[0 1],'k:'); 
            xlabel('false positive rate');
            ylabel('true positive rate'); 
            axis square; 
            title(['Leave-One-Out ROC (class ',rocClass,' vs. all others)'],...
                'FontName','LucidaSans', 'FontWeight','bold'); 
            hold off;
            
            figure(3);
            this.averageRun.plot();
        end
    end
end

