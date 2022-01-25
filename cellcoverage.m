 clear
close all
Cellnum = 1;
Towernum = 2;

[PhoneData TowerData, Distances] = Infogen(Cellnum, Towernum);
SignalStrength = Dataflow(Distances);

%figure %map phones (blue) and towers (red) onto 2-D plot.
%scatter(PhoneData(:,1),PhoneData(:,2), 'b')
%hold on
%scatter(TowerData(:,1), TowerData(:,2), 'r')

%figure
%bar(Distances, SignalStrength);

disp([PhoneData, Distances, SignalStrength])
figure
scatter3(PhoneData(:,1),PhoneData(:,2), SignalStrength, 'b')
hold on
scatter3(TowerData(:,1), TowerData(:,2), ones(Towernum, 1)*70, 'r')

function [Smax] = Dataflow(Distances) %calculate Signal strength
    %constants
    k = 4; 
    P = 1;
    B = 10;
    sigma = 10^(-11.2);
    Smax = []
    SignalStrength = [];
    for j = 1:width(Distances) 
    %calculate signal strength for every phone, iterating over towers 
        
        %Arrays
        R = [];
        Noise = [];
        for i = 1:size(Distances(:,1)) %Noise to tower j
            %disp(i)
            Noise = [Noise;P/(((1+Distances(i,j))^k)*(sigma))]; %calculate signal noise
        end

        %calculate Noise and signal strength to tower j
        for i = 1:size(Distances(:,1))
           
            if Noise(i) > 63       %calculate bit/s
                R = [R;B*log2(64)];
                
            elseif Noise(i) >= 0.3
                R = [R;B*log2(1+Noise(i))];
                
            else
                R = [R;0];
                            
            end
        end
        SignalStrength = [SignalStrength R]; %generate matrix for all towers
    end
    for i = 1:height(SignalStrength)
       Smax = [Smax; max(SignalStrength(i,:))]; 
    end
    
    %disp(SignalStrength)
    return
end

function [PhoneData TowerData Distances] = Infogen(Cellnum, Towernum) %Generate the coordinates 
                                                                      % of towers and phones
    CellPos = rand([Cellnum,2])*1000;
    TowerPos = rand([Towernum,2])*1000;
    
    %calculate distance between an arbitrary amount of towers and all phones
    Dist= [];
    for i = 1:Towernum
        Dist = [Dist ((CellPos(:,1)-TowerPos(i,1)).^2 + (CellPos(:,2)-TowerPos(i,2)).^2).^(1/2)]; 
        
    end
    
    PhoneData = [CellPos]; %Export the data
    TowerData = [TowerPos];
    Distances = [Dist];
    return
end 

