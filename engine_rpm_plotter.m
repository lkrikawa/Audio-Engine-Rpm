function Engine_RpmV2(audiot,num_str,num_cyl,rpm_upperbound,tlr);
    a=1;%locations of graphs a, b, c, and d
    b=2;
    c=3;
    d=4;

    fs=44100
    NFFT=2^18;
    framelength=fs/4;%One frame is a quarter second
    
    %choses how many values of the fft calculated frequencies are used 
    % based on rpm upper bound
    hz_len=NFFT/fs*rpm_upperbound*num_cyl/60*(2/num_str);
    rpm_per_hz=(num_str/2)*(60/num_cyl);

    %makes sure rpmbox is empty for multiple runs
    rpmbox=[];

    for i=1:(length(audiot)-mod(length(audiot),framelength)-1)/framelength
        clip1=audiot((i-1)*framelength+1:(i+1)*framelength);
        engine_freq=fft_bulletV2(clip1,tlr,hz_len,NFFT);
        rpm1=engine_freq*rpm_per_hz;%converts to rpm
    
        if rpm1<rpm_upperbound %only includes values within rpm bound
            rpmbox(end+1)=rpm1;
        else
            rpmbox(end+1)=NaN;
        end
    end
    
    %spectrogram paramters (what worked the best for me)
    L_standard=fs/.8;
    L=min([numel(audiot),L_standard]);
    alpha=5;
    g=gausswin(round(L),alpha);
    spectrogram_nfft=round(L);
    noverlap=round(.9*spectrogram_nfft);

    [~,Ft,t,psd]=spectrogram(audiot,g,noverlap,spectrogram_nfft,fs,'yaxis','psd',Minthreshold=-75);
    winmax=rpm_upperbound/rpm_per_hz;%Hz
    win=round(winmax*spectrogram_nfft/fs);
    Ft=Ft(1:win);
    psd=psd(1:win,:);
    ridge2=tfridge(psd,Ft,0.01);

    tsm=(t-t(1))/(t(end)-t(1))*numel(audiot)/fs;
    figure(a)
    %plots spectrogram
    imagesc(tsm,Ft,psd);
    hold on
    title('Audio Spectrogram')
    ylabel('Hz')
    xlabel('Time (s)')
    axis xy

    hold off

    
    figure(c)
    plot(0)
    hold on
    plot(t,ridge2*rpm_per_hz,'black')
    plot(rpm_upperbound)
    title('Rpm vs Time from Spectogram Ridge Line')
    ylabel('Rpm')
    xlabel('Time (s)')


    %plot created from FFT slices (outputs from fft_bullet)
    figure(b);
    plot(0)
    hold on
    plot(rpm_upperbound)
    plot(linspace(0.25,round(numel(audiot)/44100)-0.25,numel(rpmbox)),rpmbox,'r');
    title('Rpm vs Time from FFT slices')
    ylabel('Rpm')
    xlabel('Time (s)')

    %all plots overlayed
    figure(d);
    imagesc(tsm,Ft,psd);
    axis xy
    hold on
    title('All plots on top of Spectrogram')
    ylabel('Hz')
    xlabel('Time (s)')
    plot(0)
    rpm_slices_times=linspace(0.25,round(numel(audiot)/44100)-0.25,numel(rpmbox));
    plot(rpm_slices_times,rpmbox/rpm_per_hz,'r');
    plot(tsm,ridge2,'black')

    figure(a)
    hold off
    figure(b)
    hold off 
    figure(c)
    hold off
    figure(d)
    hold off
end

