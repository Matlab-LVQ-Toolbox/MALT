classdef Parameters
    % Class that describes all parameters to use in a GMLVQ run
    
    properties
        doztr (1,1) { GMLVQ.Helpers.mustBeLogical } = true
        mode (1,1) GMLVQ.Mode = GMLVQ.Mode.GMLVQNS
        rndinit (1,1) { GMLVQ.Helpers.mustBeLogical } = false
        mu (1,1) { mustBeNumeric } = 0
        decfac (1,1) { mustBeNumeric } = 1.5
        incfac (1,1) { mustBeNumeric } = 1.1
        ncop (1,1) { mustBeInteger, mustBeNonnegative } = 5
        etam { mustBeNumeric }
        etap { mustBeNumeric }
        rngseed (1,1) { mustBeNumeric } = 291024
        showlegend (1,1) { GMLVQ.Helpers.mustBeLogical } = true
        randomization (1,1) { mustBeNumeric } = 0.02
        useKMeans (1,1) { GMLVQ.Helpers.mustBeLogical } = true
        rocClass (1,1) { mustBeInteger, mustBeNonnegative } = 1
    end
    
    methods
        % Set the parameters defined in key-value pairs in the
        % call-varargs and let them override the default values defined
        % above
        function params = Parameters(varargin)
            params = GMLVQ.Helpers.parseClassProperties(params, varargin{:});
            
            % Now do some validation and conditional parameter setting
            switch params.mode
                case {GMLVQ.Mode.GMLVQ, GMLVQ.Mode.GMLVQNS}
                    params.etam = 2;
                    params.etap = 1;
                    if params.mode == 0; disp('Matrix relevances without null-space correction'); end
                    if params.mode == 1; disp('Matrix relevances with null-space correction'); end
                case GMLVQ.Mode.GRLVQ
                    disp('Diagonal relevances, not encouraged, sensitive to step sizes');
                    params.etam = 0.2;
                    params.etap = 0.1;
                case GMLVQ.Mode.GLVQ
                    disp('GLVQ without relevances');
                    params.etam = 0;
                    params.etap = 1;
            end
            
            % Some general warnings
            if ~params.doztr
                disp('No z-score transformation, you may have to adjust step sizes');
                if params.mode < 3; disp('Rescale relevances for proper interpretation'); end
            end
        end
    end
end

