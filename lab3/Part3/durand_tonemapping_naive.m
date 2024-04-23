function [final_image] = durand_tonemapping_naive( ...
    hdr ...
    )
    
   % Compute the intensity I by averaging the color channels.
    I = mean(hdr, 3);
    
    % Compute the log intensity: L=log2(I)
    L = log(I);
    
    % Compute the detail layer: D=L
    D = L;
    
    %Reconstruct the log intensity: O=2(B′+D)
    O = exp(D);
    
    % Put back the colors: R′,G′,B′=O∗(R/I,G/I,B/I)
    final_image = zeros(size(hdr));
    
    for c=1:3

        final_image(:, :, c) = O .* (hdr(:, :, c) ./ I);
    
    end
    
    % Apply gamma compression
    final_image=scale_and_gamma(final_image);

end