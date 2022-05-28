classdef quasarQlearner < handle
    
    properties
        Q
        alpha
        tau
        gamma
        trainingWheels
    end
    
    methods
        function obj = quasarQlearner(alphaFunc,tauFunc,gamma,varargin)
            isaFunc = @(x) isa(x,'function_handle');
            isValidGamma = @(x) (x > 0) && (x < 1);
            p = inputParser;
            addRequired(p,'alphaFunc',isaFunc)
            addRequired(p,'tauFunc',isaFunc)
            addRequired(p,'gamma',isValidGamma)
            addParameter(p,'trainingWheels',false,@islogical)
            parse(p,alphaFunc,tauFunc,gamma,varargin{:})
            
            obj.alpha = p.Results.alphaFunc;
            obj.tau = p.Results.tauFunc;
            obj.gamma = p.Results.gamma;
            obj.trainingWheels = p.Results.trainingWheels;
            
            obj.Q = rand(20,3);
            
        end
        
        function action = act(obj,state,t)
            if (obj.trainingWheels)
                if (state < 16)
                    [~,action] = mySoftmax(obj.Q(state,1:2),obj.tau(t));
                else
                    [~,action] = mySoftmax(obj.Q(state,:),obj.tau(t));
                end
            else
                [~,action] = mySoftmax(obj.Q(state,:),obj.tau(t));
            end
        end
        
        function deltaQ = updateQ(obj,state,action,reward,nextState,t)
            oldQ = obj.Q;
            if (nextState == 0)
                obj.Q(state,action) = obj.Q(state,action) + ...
                    obj.alpha(t)*(reward - obj.Q(state,action));
            else
                obj.Q(state,action) = obj.Q(state,action) + ...
                    obj.alpha(t)*(reward + obj.gamma*max(obj.Q(nextState,:)) - obj.Q(state,action));
                deltaQ = sqrt(sum((obj.Q - oldQ).^2));
            end
        end
        
    end
end

