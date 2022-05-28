classdef quasarEnv < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        count
        curGame
        payout
        badActionPenalty
    end
    
    methods
        function obj = quasarEnv(varargin)
            p = inputParser;
            addParameter(p,'badActionPenalty',-1,@isnumeric)
            parse(p,varargin{:})
            
            obj.curGame = 1;
            obj.count = 0;
            obj.payout = [ones(1,14)*-200 -150 -100 0 50 100 200];
            obj.badActionPenalty = p.Results.badActionPenalty;
        end
        
        function [state,reward,done] = step(obj,action)
            % Valid action values 1,2,3
            % 1 : add 4-7
            % 2 : add 1-8
            % 3 : take payout
            if (action == 3)
                if (obj.count > 20)
                    error('No action possible when the count is > 20')
                elseif (obj.count < 15)
                    reward = obj.badActionPenalty;
                    done = false;
                    state = obj.count;
                else
                    reward = obj.payout(obj.count);
                    done = true;
                    state = ceil(rand*8);
                    obj.curGame = obj.curGame + 1;
                    return
                end
            elseif (action == 1)
                obj.count = obj.count + 3 + ceil(rand*4);
                if (obj.count > 20)
                    reward = -200;
                    done = true;
                    state = ceil(rand*8);
                    obj.curGame = obj.curGame + 1;
                else
                    reward = 0;
                    done = false;
                    state = obj.count;
                end
            elseif (action == 2)
                obj.count = obj.count + ceil(rand*8);
                if (obj.count > 20)
                    reward = -200;
                    done = true;
                    state = ceil(rand*8);
                    obj.curGame = obj.curGame + 1;
                else
                    reward = 0;
                    done = false;
                    state = obj.count;
                end
            else
                error(['Invalid action: ' num2str(action)])
            end
        end
        
        function state = reset(obj)
            obj.count = ceil(rand*8);
            state = obj.count;
        end
    end
end

