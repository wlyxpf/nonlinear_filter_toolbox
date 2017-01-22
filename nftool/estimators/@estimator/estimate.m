function [est,p]=estimate(p,z,u,ne)
% ESTIMATE - estimate  (smoothing|filtering|predictive) step
% returns information structure
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% velikost vstupni a vystupni promenne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isnan(z)
    [Iz,Jz] = size(z);
else
    Jz = 0;
end

if ~isnan(u);
    [Iu,Ju] = size(u);
else
    Ju = 0;
end

if nargin == 3
    ne = Jz;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nutno provest kontrolu dimenzi u a y s ohledem na system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vlastni algoritmus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch sign(p.lag)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 0
        % v inicializaci je nutno do p.pipe dat p(x0)

        % provedu filtraci pro vsechna mereni
        panel=waitbar(0,'Please wait, filtering in progress ...');
        for jz = 1 : min(Jz,ne)
            %    if p.time > 0
            %      plast = p.result;
            %    else
            %      plast = get_cur(p.pipe);
            %    end

            % pokud je cas 0 zacinam az filtraci, jinak i predikce
            if p.time > 0
                % dve varianty - pro nezadany vstup a zadany vstup
                if Ju > 0
                    % predikce se vstupem
                    p.pipe = insert(p.pipe,prediction(p,p.result,u(:,jz-1)));
                else
                    % predikce bez vstupu
                    p.pipe = insert(p.pipe,prediction(p,p.result));
                end
            end
            ppred = get_cur(p.pipe);
            % filtrace

            p.result = filtering(p,get_cur(p.pipe),z(:,jz));

            % inc casu
            p.time = p.time+1;
            % vysledek filtrace
            est{jz} = p.result;

            waitbar(jz/min(Jz,ne),panel);

            %    figure;
            %    hold on;
            %    plot(samples(plast),zeros(size(samples(plast))),'r*');
            %    plot(samples(p.result),ones(size(samples(p.result))),'o');
            %    plot(samples(ppred),0.5*ones(size(samples(ppred))),'g*');
            %    title('estimate.m')
            %    pause
            %    close
        end
        close(panel)


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      3
        % prediction
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 1
        % v inicializaci je nutno do p.pipe dat p(x0)

        iout = 1;

        % cas 0 a pozadavek na pocatecni k-krokovou predikci
        if (p.time == 0) & (ne == Jz+1)

            cur = p.px0;

            % dopocitani dalsich kroku predikce na zaklade vstupu
            for i = 1:p.lag-1
                % 1-krokove predikce
                if i <= Ju
                    % predikce pokud je k dispozici vstup
                    cur = prediction(p,cur,u(:,i));
                else
                    % predikce pokud uz neni nebo nebyl k dispozici vstup
                    cur = prediction(p,cur);
                end
            end

            p.result = cur;
            est{iout} = p.result;
            iout = iout + 1;
        end

        % provedu predikci pro vsechna mereni

        panel=waitbar(0,'Please wait, prediction in progress ...');

        for jz = 1: min(Jz,ne)

            % filtrace

            f = filtering(p,get_cur(p.pipe),z(:,jz));

            % 1-krokova predikce pro nezadany/zadany vstup
            if Ju > 0
                cur = prediction(p,f,u(:,jz));
            else
                cur = prediction(p,f);
            end
            % ulozeni 1-krokove predikce
            p.pipe = insert(p.pipe,cur);

            % dopocitani dalsich kroku predikce na zaklade vstupu
            for i = 1:p.lag-1
                % 1-krokove predikce
                if (jz+i) <= Ju
                    % predikce pokud je k dispozici vstup
                    cur = prediction(p,cur,u(:,jz+i));
                else
                    % predikce pokud uz neni nebo nebyl k dispozici vstup
                    cur = prediction(p,cur);
                end
            end

            waitbar(jz/min(Jz,ne),panel);

            % zapsani vesledku k - krokove predikce
            p.result = cur;
            est{iout} = p.result;
            % inc casu
            p.time = p.time+1;
            iout = iout + 1;
        end
        close(panel)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %smoothing
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case -1

        iout = 1;
        % provedu vyhlazovani pro vsechna mereni
        panel=waitbar(0,'Please wait, smoothing in progress ...');
        for jz = 1 : min(Jz,ne)

            % dokad neni dost informaci neni mozno zacit vyhlazovat
            if p.time < (abs(p.lag))

                % pokud je cas 0 zacinam az filtraci, jinak i predikce
                if p.time > 0  %predikce
                    % dve varianty - pro nezadany vstup a zadany vstup
                    if Ju > 0
                        % predikce se vstupem
                        p.pipe = insert(p.pipe,prediction(p,get_last(p.pipe),u(:,jz)));
                    else
                        % predikce bez vstupu
                        p.pipe = insert(p.pipe,prediction(p,get_last(p.pipe)));
                    end
                end

                % filtrace
                p.pipe = insert(p.pipe,filtering(p,get_last(p.pipe),z(:,jz)));
                % inc casu
                p.time = p.time+1;

            else % uz mam dost naplnenou rouru

                %provedu zatrideni dat pro jeden casovy okamzik

                if Ju > 0
                    % predikce se vstupem
                    p.pipe = insert(p.pipe,prediction(p,get_last(p.pipe),u(:,jz)));
                else
                    % predikce bez vstupu
                    p.pipe = insert(p.pipe,prediction(p,get_last(p.pipe)));
                end
                % filtrace
                p.pipe = insert(p.pipe,filtering(p,get_last(p.pipe),z(:,jz)));

                % inicializace parametru
                p.pipe = mv_last(p.pipe); % dostanu se na posledni filtraci
                cur = get_cur(p.pipe);    % pocatecni podminka pro vyhlazovani
                p.pipe = mv_last(p.pipe); % dostanu se o jednu pozici zpet
                lastp = get_cur(p.pipe);  % minula predikce
                p.pipe = mv_last(p.pipe); % dostanu se o jednu pozici zpet
                lastf = get_cur(p.pipe);  % minula filtrace

                % vlastni vypocet
                for i = 1 : abs(p.lag)
                    if Ju > 0
                        % smoothing se vstupem
                        cur = smoothing(p,cur,lastp,lastf,u(:,jz));
                    else
                        % smoothing bez vstupu
                        cur = smoothing(p,cur,lastp,lastf);
                    end

                    % cekaji-li me jeste nejake kroky, provedu dalsi
                    % naplneni promennych lastp a lastf
                    if i < abs(p.lag)
                        p.pipe = mv_last(p.pipe); % dostanu se o jednu pozici zpet
                        lastp = get_cur(p.pipe);  % minula predikce
                        p.pipe = mv_last(p.pipe); % dostanu se o jednu pozici zpet
                        lastf = get_cur(p.pipe);  % minula filtrace
                    end
                end

                %naplneni vystupnich promennych
                p.result = cur;
                est{iout} = p.result;
                p.time = p.time+1;
                iout = iout + 1;
            end
            waitbar(jz/min(Jz,ne),panel);
        end
        close(panel)

end



% CHANGELOG
