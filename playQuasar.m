%play Quasar
trained_agent = load('trained_agent.mat');
trained_agent = trained_agent.trained_agent;

env = quasarEnv();

nGames = 10000;
money = nan(1,nGames+1);
rewards = nan(1,nGames);
money(1) = 10000;

for i=2:(nGames+1)
    done = false;
    state = env.reset();
    while (~done)
        action = agent.act(state,inf);
        oldState = state;
        [state,reward,done] = env.step(action);
        if (done)
            state = 0;
        end
    end
    rewards(i-1) = reward;
    money(i) = money(i-1) + reward;
end

figure;
plot(1:(nGames+1),money)

disp(['Average winnings per game = ' num2str((money(end) - money(1))/nGames)])