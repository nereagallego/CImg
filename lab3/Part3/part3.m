%load HDR
hdr = hdrread('../Part1/Results/tent_weights/hdr_image.hdr');

fignum = 6;

for dR = [2, 3, 4, 5, 6, 7, 8]

    imwrite( ...
        durand_tonemapping(hdr, dR, fignum), ...
        "Results/tonemapped_durand_dR_" + dR + ".png" ...
        )
    
    fignum = fignum + 1;

end

clear fignum dR;
