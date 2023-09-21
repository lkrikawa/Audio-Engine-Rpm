function engine_freq=fft_bulletV2(clip1,peak_tlr,hz_len,NFFT)
    fs=44100;
    L=numel(clip1);
    alpha=5;
    tol=peak_tlr;

    %not using windowing for speed 
    % (spectral leekage should not affect calculation of local max)         
    FFT = fft(clip1(:).*gausswin(L,alpha),NFFT);

    %uses rpm upper bounds to find range of 
    % corresponding values in clean_fft 
    % which cuts down on computations required
    search_range=(1:hz_len);

    clean_fft=abs(FFT(search_range));

    %cuts off bottom x percent of data 
    % based on how loud the max value in the search range is
    clean_fft=clean_fft/max(clean_fft);

    ix=islocalmax(clean_fft,'MinProminence',tol);
    
    %makes sure local maxes and within range are empty for mutliple runs of matlab
    local_mxs=[];
    potential_max_indicies=[];

    %indicies of local maxes
    local_mxs=find(ix);

    %if no local maxes
    if isempty(local_mxs)
        engine_freq=NaN;
    %if one local max
    elseif numel(local_mxs)==1
        %multiplying by fs/NFFT converts the x positions in clean_fft to Hz
        engine_freq=(local_mxs(1))*fs/NFFT;

    %if more than one local max
    else
        for i=2:numel(local_mxs)
            potential_max_indicies(1)=1;
            %scans for largest local maxes within 140% of first  
            % local max detected (see documentation for explaination)
            if (local_mxs(i))<(1.4*local_mxs(1)) 
                potential_max_indicies(i)=1;
            else
                potential_max_indicies(i)=0;
            end
        end
        %picks largest local max within 140 pct (largest range I found no
        %harmonics in
        [~,ixe]=max(clean_fft(local_mxs(potential_max_indicies>0)));
        engine_freq=local_mxs(ixe)*fs/NFFT;
    end
end