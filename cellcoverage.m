clear
close all
Cellnum = 100;
Towernum = 1;

Data = Infogen(Cellnum, Towernum);
SignalStrength = Dataflow(Data);
bar(Data(:,3), SignalStrength)
%scatter3(Data(:,1),Data(:,2),SignalStrength)

function [R] = Dataflow(Data) %calculate Signal strength
    %constants
    k = 4; 
    P = 1;
    B = 10;
    sigma = 10^(-11.2);
    %Arrays
    R = [];
    Noise = [];
    
    for i = 1:size(Data(:,3))
        %disp(i)
        Noise = [Noise;P/(((1+Data(i,3))^k)*(sigma))]; %calculate signal noise
    end
    %calculate Noise and signal strength
    for i = 1:size(Data(:,3))
       
        if Noise(i) > 63       %calculate bit/s
            R = [R;B*log2(64)];
            
        elseif Noise(i) >= 0.3
            R = [R;B*log2(1+Noise(i))];
            
        else
            R = [R;0];
                        
        end
    end
    return
end

function [Data] = Infogen(Cellnum, Towernum) %Generate the coordinates 
                                             % of towers and phones
    CellPos = rand([Cellnum,2])*1000;
    TowerPos = [0 0]; %rand([Towernum,2])*10
    %calculate distance between 1 tower and all phones
    Dist = ((CellPos(:,1)-TowerPos(1)).^2 + (CellPos(:,2)-TowerPos(2)).^2).^(1/2); 
   
    Data = [CellPos Dist];
    return
end 

