% Quasar strategy
alpha = @(t) max(0.00001,1./(1 + .0001*t));
tau = @(t) max(0.0001,500./(1 + 0.0001*t));
gamma = 0.99;
trainingWheels = false;
badActionPenalty = -1000;

agent = quasarQlearner(alpha,tau,gamma,'trainingWheels',trainingWheels);

env = quasarEnv('badActionPenalty',badActionPenalty);

nGames = 1000000;
rewards = nan(1,nGames);
deltaQs = nan(1,nGames);

t = 0;
for i=1:nGames
    done = false;
    state = env.reset();
    oldQ = agent.Q;
    while (~done)
        t=t+1;
        action = agent.act(state,t);
        %disp([num2str(state) '   ' num2str(action) '   ' num2str(agent.Q(state,:))])
        oldState = state;
        [state,reward,done] = env.step(action);
        if (done)
            state = 0;
        end
        agent.updateQ(oldState,action,reward,state,t);
    end
    
    rewards(i) = reward;
    deltaQs(i) = sqrt(sum((agent.Q - oldQ).^2,'all'));
    if (mod(i,1000) == 0)
        disp(['Done with ' num2str(i) ' games'])
    end
end
deltaQs(deltaQs > 1000) = nan;
figure;
subplot(2,1,1)
plot(1:nGames,smoothdata(rewards,'gaussian',101));
ylabel('Reward')
subplot(2,1,2)
plot(1:nGames,deltaQs)
ylabel('\Delta Q')
xlabel('Game #')
[~,optimalPolicy] = max(agent.Q,[],2);
[(1:20)' optimalPolicy]

disp(['End alpha = ' num2str(alpha(t))])
disp(['End tau = ' num2str(tau(t))])

agent.Q

trained_agent = agent;
save('trained_agent.mat','trained_agent','-mat')
playQuasar