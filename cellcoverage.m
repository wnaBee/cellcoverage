function [] = cellcoverage(mode, i1, i2, i3, i4, i5, i6, i7) 
              %Number of phones, towers, side of area, 
              %predetermined phone positions, tower positions
              %bandwidth, P, sigma squared, Kappa
    close all
    
    if mode == 0 %mode 0, generate a random set of phones and numbers
        if nargin == 4
            Cellnum = i1; %number of phones
            Towernum = i2; %number of towers
            Area = i3; %Side of Area
            Kappa = 4; %interference exponent
            P = 1; %Wattage
            Bandwidth = 10; %Bandwidth
            sigma2 = 10^(-11.2); %interfering wattage
        elseif nargin == 8
            Cellnum = i1;
            Towernum = i2;
            Area = i3;
            Bandwidth = i4;
            P = i5;
            Sigma2 = i6;
            Kappa = i7;
        else 
            error("you didn't provide correct numbers")
        end
        %generate coordinates for all towers and phones
        [PhoneData, TowerData] = Infogen(Cellnum, Towernum, Area);
    elseif mode == 1 %input specific coordinates for all data
        if nargin == 3
            PhoneData = i1; 
            TowerData = i2;
            Kappa = 4; 
            P = 1;
            Bandwidth = 10;
            sigma2 = 10^(-11.2);
        elseif nargin == 7
            PhoneData = i1;
            TowerData = i2;
            Kappa = i3; 
            P = i4;
            Bandwidth = i5;
            sigma2 = i6;
        else
            error('you dumbdumbd')
        end
        Towernum = height(TowerData);
    end
    
    Distances = DistanceCalc(PhoneData, TowerData)
    SignalStrength = Dataflow(Distances, Kappa, P, Bandwidth, sigma2);
    
       %draw all towers and phones
    figure
    scatter3(TowerData(:,1), TowerData(:,2), ...
        ones(Towernum, 1)*70, 'r')
    hold on
    scatter3(PhoneData(:,1),PhoneData(:,2), SignalStrength, 'b')
    legend('Towers', 'Phones')
    
    function [Smax] = Dataflow(Distances, k, P, B, sigma) %calculate Signal strength
        
        if nargin == 1
            %constants
            
        elseif nargin ~= 5
            error('oops you did a stupid, plz fix (placeholder message)')            
        end
        
        Smax = [];
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
    
    function [CellPos, TowerPos] = Infogen(Cellnum, Towernum, Area) 
                                   %Generate the coordinates 
                                   %of towers and phones
        CellPos = rand([Cellnum,2])*Area;
        TowerPos = rand([Towernum,2])*Area;
               
        return
    end 
    
    function [Dist] = DistanceCalc(CellPos, TowerPos)
        %calculate distance between an arbitrary
        %amount of towers and all phones
        
        Dist= [];
        for i = 1:height(TowerPos)
            Dist = [Dist ((CellPos(:,1)-TowerPos(i,1)).^2 ...
            + (CellPos(:,2)-TowerPos(i,2)).^2).^(1/2)]; 
        end
        return
    end

clear
end


%handy debug code
%figure %map phones (blue) and towers (red) onto 2-D plot.
%scatter(PhoneData(:,1),PhoneData(:,2), 'b')
%hold on
%scatter(TowerData(:,1), TowerData(:,2), 'r')
   
%figure
%bar(Distances, SignalStrength);
    
%disp([PhoneData, Distances, SignalStrength])