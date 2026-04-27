classdef AverageRun < GMLVQ.Run
    % Class that represents the "average" of a number of Runs, for example in a L1O-scenario.
    
    properties
        trainingPerfStd (1,:) GMLVQ.Performance
        validationPerfStd (1,:) GMLVQ.Performance
        
        prototypesStd (:,:) { mustBeNumeric, mustBeFinite }
        lambdaStd (:,:) { mustBeNumeric }
    end
    
    methods
        % Constructor of this class
        % @param gmlvq GMLVQ.GMLVQ
        % @param trainingData GMLVQ.DataPair
        % @out GMLVQ.AverageRun
        function this = AverageRun(gmlvq, trainingData)
            this@GMLVQ.Run(gmlvq, trainingData, GMLVQ.DataPair.empty);
            
            this.trainingPerfStd = GMLVQ.Performance.empty(this.nSteps, 0);
            this.validationPerfStd = GMLVQ.Performance.empty(this.nSteps, 0);
        end
        
        % Function that averages the validation performance parameters of the given result set
        % @param this GMLVQ.AverageRun
        % @param results GMLVQ.Result[]
        function setMeanPerformanceTraining(this, results)
            this.setMeanPerformance(results, 'trainingPerf');
        end
        
        % Function that averages the training performance parameters of the given result set
        % @param this GMLVQ.AverageRun
        % @param results GMLVQ.Result[]
        function setMeanPerformanceValidation(this, results)
            this.setMeanPerformance(results, 'validationPerf');
        end
    end
    
    methods (Access = protected)
        % Function that averages the performance parameters of the given result set
        % @param this GMLVQ.AverageRun
        % @param results GMLVQ.Result[]
        % @param type string
        function setMeanPerformance(this, results, type)
            % Each result contains a list of Performance objects that records the performance at a
            % specific step. We want to average the various metrics across the results, but on a
            % step-by-step basis. So the performance of run 1, step 1 is averaged with that of run
            % 2, step 1; run 3, step 1; etc.
            
            stdType = [type 'Std'];
            nResults = length(results);
            this.(type)(1:this.nSteps + 1) = GMLVQ.Performance(this.nClasses);
            this.(stdType)(1:this.nSteps + 1) = GMLVQ.Performance(this.nClasses);
            
            % This construct puts all auroc-vectors side by side. It makes a list of all runs, and
            % for each run it takes all aurocs in a column vector (the transpose)
            % Using cell magic we can then easily assign them to the separate step-performances
            aurocs = cell2mat(arrayfun(@(x) [x.(type).auroc]', [results.run], 'UniformOutput', false));
            aurocMean = num2cell(mean(aurocs, 2));
            aurocStd = num2cell(std(aurocs, 1, 2)); % We normalize by N, not N-1
            [this.(type).auroc] = aurocMean{:};
            [this.(stdType).auroc] = aurocStd{:};
            
            % This construct puts all classWise-matrices side by side in the third dimension
            classWiseCells = arrayfun(@(x) [x.(type).classWise]', [results.run], 'UniformOutput', false);
            classWiseSize = [(this.nSteps + 1) this.nClasses nResults]; % Take the size of the separate cw arrays
            classWise = reshape(cell2mat(classWiseCells), classWiseSize); % Put the matrices in another array
            classWiseMean = num2cell(squeeze(mean(classWise, 3))', 1);
            classWiseStd = num2cell(squeeze(std(classWise, 1, 3))', 1);
            [this.(type).classWise] = classWiseMean{:};
            [this.(stdType).classWise] = classWiseStd{:};
            
            % This construct puts all costFunction-vectors side by side.
            costFunctions = cell2mat(arrayfun(@(x) [x.(type).costFunction]', [results.run], 'UniformOutput', false));
            costFunctionMean = num2cell(mean(costFunctions, 2));
            costFunctionStd = num2cell(std(costFunctions, 1, 2));
            [this.(type).costFunction] = costFunctionMean{:};
            [this.(stdType).costFunction] = costFunctionStd{:};
            
            % This construct puts all totalError-vectors side by side.
            totalErrors = cell2mat(arrayfun(@(x) [x.(type).totalError]', [results.run], 'UniformOutput', false));
            totalErrorMean = num2cell(mean(totalErrors, 2));
            totalErrorStd = num2cell(std(totalErrors, 1, 2));
            [this.(type).totalError] = totalErrorMean{:};
            [this.(stdType).totalError] = totalErrorStd{:};
            
            % This construct puts all tpr-matrices side by side in the third dimension
            tprCells = arrayfun(@(x) [x.(type).tpr]', [results.run], 'UniformOutput', false);
            tprSize = [(this.nSteps + 1) size(tprCells{1}, 2) nResults];
            tpr = reshape(cell2mat(tprCells), tprSize);
            tprMean = num2cell(squeeze(mean(tpr, 3))', 1);
            tprStd = num2cell(squeeze(std(tpr, 1, 3))', 1);
            [this.(type).tpr] = tprMean{:};
            [this.(stdType).tpr] = tprStd{:};
            
            % This construct puts all fpr-matrices side by side in the third dimension
            fprCells = arrayfun(@(x) [x.(type).fpr]', [results.run], 'UniformOutput', false);
            fprSize = [(this.nSteps + 1) size(fprCells{1}, 2) nResults];
            fpr = reshape(cell2mat(fprCells), fprSize);
            fprMean = num2cell(squeeze(mean(fpr, 3))', 1);
            fprStd = num2cell(squeeze(std(fpr, 1, 3))', 1);
            [this.(type).fpr] = fprMean{:};
            [this.(stdType).fpr] = fprStd{:};
        end
    end
end